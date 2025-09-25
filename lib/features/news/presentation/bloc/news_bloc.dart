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

class RefreshNewsEvent extends NewsEvent {}

class CreateNewsEvent extends NewsEvent {
  final String title;
  final String content;
  final String category;

  CreateNewsEvent({
    required this.title,
    required this.content,
    required this.category,
  });

  @override
  List<Object?> get props => [title, content, category];
}

class ClearNewsErrorEvent extends NewsEvent {}

// States
abstract class NewsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsRefreshing extends NewsState {
  final List<NewsArticle> articles;

  NewsRefreshing({required this.articles});

  @override
  List<Object?> get props => [articles];
}

class NewsLoaded extends NewsState {
  final List<NewsArticle> articles;

  NewsLoaded({required this.articles});

  @override
  List<Object?> get props => [articles];
}

class NewsCreating extends NewsState {}

class NewsCreated extends NewsState {
  final String message;

  NewsCreated({this.message = 'News article created successfully'});

  @override
  List<Object?> get props => [message];
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
    on<RefreshNewsEvent>(_onRefreshNews);
    on<CreateNewsEvent>(_onCreateNews);
    on<ClearNewsErrorEvent>(_onClearNewsError);
  }

  Future<void> _onLoadNews(LoadNewsEvent event, Emitter<NewsState> emit) async {
    // Only show loading if we don't already have articles
    if (state is! NewsLoaded) {
      emit(NewsLoading());
    }

    final result = await getNewsUseCase();
    result.fold(
      (failure) => emit(NewsError(message: failure.message)),
      (articles) => emit(NewsLoaded(articles: articles)),
    );
  }

  Future<void> _onRefreshNews(
      RefreshNewsEvent event, Emitter<NewsState> emit) async {
    // Show refreshing state if we have articles, otherwise show loading
    if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;
      emit(NewsRefreshing(articles: currentState.articles));
    }

    final result = await getNewsUseCase();
    result.fold(
      (failure) => emit(NewsError(message: failure.message)),
      (articles) => emit(NewsLoaded(articles: articles)),
    );
  }

  Future<void> _onCreateNews(
      CreateNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsCreating());

    final result = await createNewsUseCase(CreateNewsParams(
      title: event.title,
      content: event.content,
      category: event.category,
    ));

    result.fold(
      (failure) => emit(NewsError(message: failure.message)),
      (_) {
        emit(NewsCreated());
        // Automatically reload news after creating
        add(LoadNewsEvent());
      },
    );
  }

  void _onClearNewsError(ClearNewsErrorEvent event, Emitter<NewsState> emit) {
    if (state is NewsError) {
      emit(NewsInitial());
    }
  }
}
