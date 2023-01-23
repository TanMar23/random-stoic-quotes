import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'presentation/pages/home_page.dart';

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
