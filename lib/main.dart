import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:random_quotes_app/models/quote_model.dart';

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
                  Text(
                    snapshot.data!.body,
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    snapshot.data!.author.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // KeypadSection(fetchNew: fetchQuote()),
                  RawMaterialButton(
                    onPressed: () {
                      setState(() {
                        quote = fetchQuote();
                      });
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    child: Icon(
                      Icons.replay_outlined,
                      size: 35.0,
                    ),
                    padding: const EdgeInsets.all(15.0),
                    shape: const CircleBorder(),
                  ),
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

// Hacer get request
Future<QuoteModel> fetchQuote() async {
  final url = Uri.https('stoicquotesapi.com', 'v1/api/quotes/random');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return QuoteModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load quote');
  }
}
