// lib/features/news/domain/usecases/create_news_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/news_repository.dart';

class CreateNewsUseCase implements UseCase<void, CreateNewsParams> {
  final NewsRepository repository;

  CreateNewsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateNewsParams params) async {
    return await repository.createNews(
      title: params.title,
      content: params.content,
      category: params.category,
      authorId: params.authorId,
      authorName: params.authorName,
    );
  }
}

class CreateNewsParams {
  final String title;
  final String content;
  final String category;
  final String authorId;
  final String authorName;

  CreateNewsParams({
    required this.title,
    required this.content,
    required this.category,
    required this.authorId,
    required this.authorName,
  });
}
