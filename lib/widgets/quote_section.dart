import 'package:flutter/material.dart';

class QuoteSection extends StatelessWidget {
  const QuoteSection({
    Key? key,
    required this.quoteBody,
    required this.quoteAuthor,
  }) : super(key: key);

  final String quoteBody;
  final String quoteAuthor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            quoteBody,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'LibreBaskerville',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Text(
            '- ${quoteAuthor.toUpperCase()}',
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
