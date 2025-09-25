// lib/features/news/domain/usecases/get_news_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/news_article.dart';
import '../repositories/news_repository.dart';

class GetNewsUseCase implements UseCaseNoParams<List<NewsArticle>> {
  final NewsRepository repository;

  GetNewsUseCase(this.repository);

  @override
  Future<Either<Failure, List<NewsArticle>>> call() async {
    return await repository.getNews();
  }
}
