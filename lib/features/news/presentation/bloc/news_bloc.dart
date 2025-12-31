// lib/features/news/presentation/bloc/news_bloc.dart (Updated)
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/news_article.dart';
import '../../domain/usecases/get_news_usecase.dart';
import '../../domain/usecases/create_news_usecase.dart';

// Events
abstract class NewsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNewsEvent extends NewsEvent {}

class CreateNewsEvent extends NewsEvent {
  final String title;
  final String content;
  final String category;
  final String authorId;
  final String authorName;

  CreateNewsEvent({
    required this.title,
    required this.content,
    required this.category,
    required this.authorId,
    required this.authorName,
  });

  @override
  List<Object?> get props => [title, content, category, authorId, authorName];
}

// States
abstract class NewsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsArticle> articles;

  NewsLoaded({required this.articles});

  @override
  List<Object?> get props => [articles];
}

class NewsError extends NewsState {
  final String message;

  NewsError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNewsUseCase getNewsUseCase;
  final CreateNewsUseCase createNewsUseCase;

  NewsBloc({
    required this.getNewsUseCase,
    required this.createNewsUseCase,
  }) : super(NewsInitial()) {
    on<LoadNewsEvent>(_onLoadNews);
    on<CreateNewsEvent>(_onCreateNews);

    // Auto-load news on initialization
    add(LoadNewsEvent());
  }

  void _onLoadNews(LoadNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      final result = await getNewsUseCase();
      result.fold(
        (failure) => emit(NewsError(message: failure.message)),
        (articles) => emit(NewsLoaded(articles: articles)),
      );
    } catch (e) {
      emit(NewsError(
          message: 'Connection timeout. Please check your internet.'));
    }
  }

  void _onCreateNews(CreateNewsEvent event, Emitter<NewsState> emit) async {
    final result = await createNewsUseCase(CreateNewsParams(
      title: event.title,
      content: event.content,
      category: event.category,
      authorId: event.authorId,
      authorName: event.authorName,
    ));

    result.fold(
      (failure) => emit(NewsError(message: failure.message)),
      (_) => add(LoadNewsEvent()), // Reload news after creation
    );
  }
}
