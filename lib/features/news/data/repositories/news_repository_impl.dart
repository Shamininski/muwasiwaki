// lib/features/news/data/repositories/news_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/news_article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<NewsArticle>>> getNews() async {
    try {
      final newsModels = await remoteDataSource.getNews();
      final newsArticles = newsModels.map((model) => model.toEntity()).toList();
      return Right(newsArticles);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NewsArticle>> createNews({
    required String title,
    required String content,
    required String category,
    required String authorId,
    required String authorName,
  }) async {
    try {
      final newsModel = await remoteDataSource.createNews(
        title: title,
        content: content,
        category: category,
        authorId: authorId,
        authorName: authorName,
      );
      return Right(newsModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

// &&&&&&&&&&&&&&&&&&&&& CommentedOut on 17 DEC 2025 - 7subRegions &&&&&&&&&&&&&&&&&&&&
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../../domain/entities/news_article.dart';
// import '../../domain/repositories/news_repository.dart';
// import '../datasources/news_remote_datasource.dart';

// class NewsRepositoryImpl implements NewsRepository {
//   final NewsRemoteDataSource remoteDataSource;

//   NewsRepositoryImpl(this.remoteDataSource);

//   @override
//   Future<Either<Failure, List<NewsArticle>>> getNews() async {
//     try {
//       final newsModels = await remoteDataSource.getNews();
//       final newsArticles = newsModels.map((model) => model.toEntity()).toList();
//       return Right(newsArticles);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> createNews({
//     required String title,
//     required String content,
//     required String category,
//   }) async {
//     try {
//       await remoteDataSource.createNews(
//         title: title,
//         content: content,
//         category: category,
//       );
//       return const Right(null);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, NewsArticle?>> getNewsById(String id) async {
//     try {
//       final newsModel = await remoteDataSource.getNewsById(id);
//       return Right(newsModel?.toEntity());
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> updateNews({
//     required String id,
//     required String title,
//     required String content,
//     required String category,
//   }) async {
//     try {
//       await remoteDataSource.updateNews(
//         id: id,
//         title: title,
//         content: content,
//         category: category,
//       );
//       return const Right(null);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> deleteNews(String id) async {
//     try {
//       await remoteDataSource.deleteNews(id);
//       return const Right(null);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
// }
