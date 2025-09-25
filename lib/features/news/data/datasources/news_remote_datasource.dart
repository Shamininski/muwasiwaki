// lib/features/news/data/datasources/news_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/news_article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsArticleModel>> getNews();
  Future<void> createNews({
    required String title,
    required String content,
    required String category,
  });
  Future<NewsArticleModel?> getNewsById(String id);
  Future<void> updateNews({
    required String id,
    required String title,
    required String content,
    required String category,
  });
  Future<void> deleteNews(String id);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final FirebaseFirestore firestore;

  NewsRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<NewsArticleModel>> getNews() async {
    try {
      final querySnapshot = await firestore
          .collection('news')
          .where('isPublished', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => NewsArticleModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to load news: ${e.toString()}');
    }
  }

  @override
  Future<void> createNews({
    required String title,
    required String content,
    required String category,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Get user details for author information
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) throw Exception('User data not found');

      final userData = userDoc.data() as Map<String, dynamic>;

      final newsArticle = NewsArticleModel(
        id: '', // Firestore will generate this
        title: title,
        content: content,
        category: category,
        authorId: user.uid,
        authorName: userData['name'] ?? 'Unknown',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPublished: true,
      );

      await firestore.collection('news').add(newsArticle.toFirestore());
    } catch (e) {
      throw Exception('Failed to create news: ${e.toString()}');
    }
  }

  @override
  Future<NewsArticleModel?> getNewsById(String id) async {
    try {
      final doc = await firestore.collection('news').doc(id).get();
      if (doc.exists) {
        return NewsArticleModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get news by ID: ${e.toString()}');
    }
  }

  @override
  Future<void> updateNews({
    required String id,
    required String title,
    required String content,
    required String category,
  }) async {
    try {
      await firestore.collection('news').doc(id).update({
        'title': title,
        'content': content,
        'category': category,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update news: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteNews(String id) async {
    try {
      await firestore.collection('news').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete news: ${e.toString()}');
    }
  }
}
