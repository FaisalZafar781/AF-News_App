import 'package:news_app/models/categories_model.dart';
import 'package:news_app/models/headline_model.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel {
  final _rep = HeadlineRepository();

  NewsViewModel();

  Future<headlinesModel> fetchHeadlineApi(String name) async {
    final response = await _rep.fetchHeadlineApi(name);
    return response;
  }

  Future<CategoriesModel> fetchCategoriesApi(String category) async {
    final response = await _rep.fetchCategoriesApi(category);
    return response;
  }
}
