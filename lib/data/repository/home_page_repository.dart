import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/bg_img_model.dart';
import '../models/quote_model.dart';
import '../models/result_model.dart';

abstract class HomePageRepository {
  Future<QuoteModel> fetchQuote();
  Future<BgImgModel> fetchBackgroundImg({
    required bool hasErrorFetchingImg,
  });
  Future<ResultModel> fetchQuoteAndBgImg({
    required bool hasErrorFetchingImg,
  });
}

class HomePageDataRepository implements HomePageRepository {
  @override
  Future<BgImgModel> fetchBackgroundImg({
    required bool hasErrorFetchingImg,
  }) async {
    final String apiKey = dotenv.get('API_KEY', fallback: 'API_KEY not found');
    final url = Uri.https('api.unsplash.com', 'photos/random', {
      'query': 'sky',
      'client_id': apiKey,
    });
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return BgImgModel.fromJson(jsonDecode(response.body));
    }
    hasErrorFetchingImg = true;
    throw Exception('Failed to load background image');
  }

  @override
  Future<QuoteModel> fetchQuote() async {
    final url = Uri.https('stoicquotesapi.com', 'v1/api/quotes/random');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return QuoteModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load quote');
    }
  }

  @override
  Future<ResultModel> fetchQuoteAndBgImg({
    required bool hasErrorFetchingImg,
  }) async {
    final results = await Future.wait([
      fetchQuote(),
      fetchBackgroundImg(
        hasErrorFetchingImg: hasErrorFetchingImg,
      )
    ]);
    return ResultModel(
      quote: results[0] as QuoteModel,
      bgImage: results[1] as BgImgModel,
    );
  }
}
