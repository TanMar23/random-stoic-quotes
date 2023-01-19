import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:random_quotes_app/models/quote_model.dart';
import 'package:random_quotes_app/widgets/quote_section.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const RandomQuotesApp());
}

class RandomQuotesApp extends StatelessWidget {
  const RandomQuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Quotes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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

  @override
  void initState() {
    super.initState();
    quote = fetchQuote();
  }

  @override
  // This method is rerun every time setState is called
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<QuoteModel>(
          future: fetchQuote(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    color:
                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(0.10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        QuoteSection(
                          quoteAuthor: snapshot.data!.author,
                          quoteBody: snapshot.data!.body,
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
                                  quote = fetchQuote();
                                });
                              },
                              elevation: 2.0,
                              padding: const EdgeInsets.all(15.0),
                              child: const Icon(
                                Icons.replay_outlined,
                                size: 35.0,
                              ),
                            ),
                            const SizedBox(width: 32),
                            RawMaterialButton(
                              onPressed: () async {
                                // Send image with quote?
                                await Share.share(
                                  '${snapshot.data!.body}  - ${snapshot.data!.author}',
                                  subject: 'Look at this stoic quote!',
                                );
                              },
                              padding: const EdgeInsets.all(15.0),
                              child: const Icon(
                                Icons.share,
                                size: 35.0,
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
