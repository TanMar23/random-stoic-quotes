import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:random_quotes_app/models/quote_model.dart';
import 'package:random_quotes_app/widgets/quote_section.dart';

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
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  QuoteSection(
                    quoteAuthor: snapshot.data!.author,
                    quoteBody: snapshot.data!.body,
                  ),
                  const SizedBox(height: 32),
                  RawMaterialButton(
                    onPressed: () {
                      setState(() {
                        quote = fetchQuote();
                      });
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(15.0),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.replay_outlined,
                      size: 35.0,
                    ),
                  ),
                  const SizedBox(height: 32),
                  RawMaterialButton(
                    onPressed: () {
                      print('share quote');
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(15.0),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.share,
                      size: 35.0,
                    ),
                  )
                ],
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

// Share the quote in Facebook, Twitter and WhatsApp.
