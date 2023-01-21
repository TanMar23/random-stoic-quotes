import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:random_quotes_app/models/quote_model.dart';
import 'package:random_quotes_app/widgets/quote_section.dart';
import 'package:share_plus/share_plus.dart';

import 'models/bg_img_model.dart';
import 'models/result_model.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const RandomQuotesApp());
}

class RandomQuotesApp extends StatelessWidget {
  const RandomQuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Quotes App',
      theme: ThemeData(fontFamily: 'LibreBaskerville'),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<QuoteModel> quote;
  late Future<BgImgModel> backgroundImg;

  @override
  void initState() {
    super.initState();
    quote = fetchQuote();
    backgroundImg = fetchBackgroundImg();
  }

  @override
  // This method is rerun every time setState is called
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Center(
          child: FutureBuilder<ResultModel>(
            future: _fetchQuoteAndBgImg(),
            builder: (context, snapshot) {
              final UrlsModel? urls = snapshot.data?.bgImage.urls;

              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Container(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        image: (urls != null)
                            ? DecorationImage(
                                colorFilter: const ColorFilter.mode(
                                  Colors.grey,
                                  BlendMode.modulate,
                                ),
                                image: NetworkImage(urls.regular),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      color: (urls == null)
                          ? Color((math.Random().nextDouble() * 0xFFFFFF)
                                  .toInt())
                              .withOpacity(0.10)
                          : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          QuoteSection(
                            quoteAuthor: snapshot.data?.quote.author ?? '',
                            quoteBody: snapshot.data?.quote.body ?? '',
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    _fetchQuoteAndBgImg();
                                  });
                                },
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(15.0),
                                child: const Icon(
                                  Icons.replay_outlined,
                                  size: 35.0,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 32),
                              RawMaterialButton(
                                onPressed: () async {
                                  // Send image with quote?
                                  await Share.share(
                                    '${snapshot.data?.quote.body}  - ${snapshot.data?.quote.author}',
                                    subject: 'Look at this stoic quote!',
                                  );
                                },
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(15.0),
                                child: const Icon(
                                  Icons.share,
                                  size: 35.0,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

Future<QuoteModel> fetchQuote() async {
  final url = Uri.https('stoicquotesapi.com', 'v1/api/quotes/random');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return QuoteModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load quote');
  }
}

Future<BgImgModel> fetchBackgroundImg() async {
  final String apiKey = dotenv.get('API_KEY', fallback: 'API_KEY not found');
  final url = Uri.https('api.unsplash.com', 'photos/random', {
    'query': 'sky',
    'client_id': apiKey,
  });
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return BgImgModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load background image');
  }
}

Future<ResultModel> _fetchQuoteAndBgImg() async {
  final results = await Future.wait([fetchQuote(), fetchBackgroundImg()]);
  return ResultModel(
    quote: results[0] as QuoteModel,
    bgImage: results[1] as BgImgModel,
  );
}
