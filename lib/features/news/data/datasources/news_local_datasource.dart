// lib/features/news/data/datasources/news_local_datasource.dart (Fixed)
import '../../../../core/services/local_storage_service.dart';
import '../models/news_article_model.dart';

abstract class NewsLocalDataSource {
  Future<List<NewsArticleModel>> getCachedNews();
  Future<void> cacheNews(List<NewsArticleModel> articles);
  Future<void> clearNewsCache();
  Future<void> cacheNewsArticle(NewsArticleModel article);
  Future<NewsArticleModel?> getCachedNewsArticle(String id);
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final LocalStorageService localStorage;
  static const String _newsCacheKey = 'cached_news';
  static const String _newsArticlePrefix = 'news_article_';

  NewsLocalDataSourceImpl(this.localStorage);

  @override
  Future<List<NewsArticleModel>> getCachedNews() async {
    try {
      final newsData = localStorage.getObject(_newsCacheKey);
      if (newsData != null && newsData['articles'] is List) {
        final articlesList = newsData['articles'] as List;
        return articlesList
            .map((article) => NewsArticleModelLocalStorage.fromMap(
                article as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheNews(List<NewsArticleModel> articles) async {
    try {
      final newsData = {
        'articles': articles.map((article) => article.toMap()).toList(),
        'cachedAt': DateTime.now().toIso8601String(),
      };
      await localStorage.setObject(_newsCacheKey, newsData);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearNewsCache() async {
    try {
      await localStorage.remove(_newsCacheKey);

      // Also clear individual article cache
      final keys = localStorage.getKeys();
      for (final key in keys) {
        if (key.startsWith(_newsArticlePrefix)) {
          await localStorage.remove(key);
        }
      }
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<void> cacheNewsArticle(NewsArticleModel article) async {
    try {
      await localStorage.setObject(
          '$_newsArticlePrefix${article.id}', article.toMap());
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<NewsArticleModel?> getCachedNewsArticle(String id) async {
    try {
      final articleData = localStorage.getObject('$_newsArticlePrefix$id');
      if (articleData != null) {
        return NewsArticleModelLocalStorage.fromMap(articleData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
