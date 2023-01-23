import 'package:flutter/material.dart';

class QuoteSection extends StatelessWidget {
  const QuoteSection({
    Key? key,
    required this.quoteBody,
    required this.quoteAuthor,
    required this.darkColor,
  }) : super(key: key);

  final String quoteBody;
  final String quoteAuthor;
  final bool darkColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            quoteBody,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'LibreBaskerville',
              color: darkColor ? Colors.black : Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            '- ${quoteAuthor.toUpperCase()}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: darkColor ? Colors.black : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
