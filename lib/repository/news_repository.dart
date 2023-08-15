import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/categories_model.dart';
import 'package:news_app/models/headline_model.dart';

class HeadlineRepository {
  Future<headlinesModel> fetchHeadlineApi(String name) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=$name&apiKey=dfee27e0db73414dbe3432778299def6';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return headlinesModel.fromJson(body);
    } else {
      throw Exception('Failed to load headline');
    }
  }

  Future<CategoriesModel> fetchCategoriesApi(String category) async {
    String url =
        'https://newsapi.org/v2/everything?q=$category&apiKey=dfee27e0db73414dbe3432778299def6';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesModel.fromJson(body);
    } else {
      throw Exception('Failed to load headline');
    }
  }
}
