import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/result_model.dart';

class KeypadSection extends StatelessWidget {
  const KeypadSection({
    Key? key,
    required this.onRefresh,
    required this.hasErrorFetchingImg,
    required this.data,
  }) : super(key: key);

  final Function onRefresh;
  final bool hasErrorFetchingImg;
  final ResultModel data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RawMaterialButton(
          onPressed: onRefresh(),
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(15.0),
          child: Icon(
            Icons.replay_outlined,
            size: 35.0,
            color: hasErrorFetchingImg ? Colors.black : Colors.white,
          ),
        ),
        const SizedBox(width: 32),
        RawMaterialButton(
          onPressed: () async {
            await Share.share(
              '${data.quote.body}  - ${data.quote.author}',
              subject: 'Look at this stoic quote!',
            );
          },
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(15.0),
          child: Icon(
            Icons.share,
            size: 35.0,
            color: hasErrorFetchingImg ? Colors.black : Colors.white,
          ),
        )
      ],
    );
  }
}
