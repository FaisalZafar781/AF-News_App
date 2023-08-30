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

# touched on 2025-05-28T20:50:53.742131Z
# touched on 2025-05-28T20:51:30.123943Z