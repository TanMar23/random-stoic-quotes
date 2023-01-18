import 'package:flutter/material.dart';

import '../models/quote_model.dart';

class KeypadSection extends StatelessWidget {
  const KeypadSection({
    Key? key,
    required this.fetchNew,
    // required this.share,
  }) : super(key: key);

  final Future<QuoteModel> fetchNew;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RawMaterialButton(
          onPressed: () {
            fetchNew;
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
          onPressed: () {},
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
  }
}
