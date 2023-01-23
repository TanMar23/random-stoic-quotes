import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../../data/models/bg_img_model.dart';
import '../../data/models/quote_model.dart';
import '../../data/models/result_model.dart';
import '../../data/repository/home_page_repository.dart';
import '../widgets/keypad_section.dart';
import '../widgets/quote_section.dart';

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
  final bool hasErrorFetchingImg = false;

  @override
  void initState() {
    super.initState();
    quote = HomePageDataRepository().fetchQuote();
    backgroundImg = HomePageDataRepository()
        .fetchBackgroundImg(hasErrorFetchingImg: hasErrorFetchingImg);
  }

  @override
  // This method is rerun every time setState is called
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: hasErrorFetchingImg
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Center(
          child: FutureBuilder<ResultModel>(
            future: HomePageDataRepository()
                .fetchQuoteAndBgImg(hasErrorFetchingImg: hasErrorFetchingImg),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                return buildDataLayout(
                    data: snapshot.data!,
                    hasErrorFetchingImg: hasErrorFetchingImg,
                    onRefresh: () {
                      // Por qué tengo que usar esto?
                      Future.delayed(Duration.zero, () {
                        setState(() {
                          HomePageDataRepository().fetchQuoteAndBgImg(
                            hasErrorFetchingImg: hasErrorFetchingImg,
                          );
                        });
                      });
                    });
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

Widget buildDataLayout({
  required ResultModel data,
  hasErrorFetchingImg,
  required Function onRefresh,
}) =>
    LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            image: (!hasErrorFetchingImg)
                ? DecorationImage(
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.modulate,
                    ),
                    image: NetworkImage(data.bgImage.urls.regular),
                    fit: BoxFit.cover,
                  )
                : null,
            color: (hasErrorFetchingImg)
                ? Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(0.20)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              QuoteSection(
                quoteAuthor: data.quote.author,
                quoteBody: data.quote.body,
                darkColor: hasErrorFetchingImg,
              ),
              const SizedBox(
                height: 100,
              ),
              KeypadSection(
                data: data,
                hasErrorFetchingImg: hasErrorFetchingImg,
                onRefresh: onRefresh,
              ),
            ],
          ),
        );
      },
    );
