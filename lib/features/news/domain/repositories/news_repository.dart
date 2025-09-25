// lib/features/news/domain/repositories/news_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/news_article.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<NewsArticle>>> getNews();
  Future<Either<Failure, void>> createNews({
    required String title,
    required String content,
    required String category,
  });
  Future<Either<Failure, NewsArticle?>> getNewsById(String id);
  Future<Either<Failure, void>> updateNews({
    required String id,
    required String title,
    required String content,
    required String category,
  });
  Future<Either<Failure, void>> deleteNews(String id);
}
