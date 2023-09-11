import 'package:equatable/equatable.dart';
import 'package:news_app/models/categories_model.dart';
import 'package:news_app/models/headline_model.dart';

enum Status { initial, success, failure }

class NewsState extends Equatable {
  NewsState({
    this.status = Status.initial,
    this.categoriesStatus = Status.initial,
    this.categoriesMessage = '',
    this.message = '',
    headlinesModel? newsList,
    CategoriesModel? categoriesNewsModel,
  })  : newsList = newsList ?? headlinesModel(),
        newsCategoriesList = categoriesNewsModel ?? CategoriesModel();

  final Status status;
  final headlinesModel? newsList;
  final String message;
  final Status categoriesStatus;
  final String categoriesMessage;
  final CategoriesModel? newsCategoriesList;

  NewsState copyWith(
      {Status? status,
      headlinesModel? newsList,
      String? message,
      CategoriesModel? categoriesNewsModel,
      String? categoriesMessage,
      Status? categoriesStatus}) {
    return NewsState(
      status: status ?? this.status,
      newsList: newsList ?? this.newsList,
      message: message ?? this.message,
      categoriesMessage: message ?? this.categoriesMessage,
      categoriesNewsModel: categoriesNewsModel ?? newsCategoriesList,
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $message,}''';
  }

  @override
  List<Object?> get props =>
      [status, newsList, message, identityHashCode(this)];
}

# touched on 2025-05-28T20:50:15.626542Z
# touched on 2025-05-28T20:51:07.824661Z
# touched on 2025-05-28T20:52:06.068114Z