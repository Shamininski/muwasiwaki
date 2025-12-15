// lib/features/news/data/models/news_article_model.dart (Updated with extension)
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/news_article.dart';

class NewsArticleModel extends NewsArticle {
  const NewsArticleModel({
    required super.id,
    required super.title,
    required super.content,
    required super.category,
    required super.authorId,
    required super.authorName,
    required super.createdAt,
    required super.updatedAt,
    required super.isPublished,
  });

  factory NewsArticleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NewsArticleModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? 'General',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isPublished: data['isPublished'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isPublished': isPublished,
    };
  }

  NewsArticle toEntity() {
    return NewsArticle(
      id: id,
      title: title,
      content: content,
      category: category,
      authorId: authorId,
      authorName: authorName,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isPublished: isPublished,
    );
  }

  factory NewsArticleModel.fromEntity(NewsArticle entity) {
    return NewsArticleModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      category: entity.category,
      authorId: entity.authorId,
      authorName: entity.authorName,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isPublished: entity.isPublished,
    );
  }
}

// Extension for local storage Map conversion
extension NewsArticleModelLocalStorage on NewsArticleModel {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPublished': isPublished,
    };
  }

  static NewsArticleModel fromMap(Map<String, dynamic> map) {
    return NewsArticleModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      category: map['category'] ?? 'General',
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isPublished: map['isPublished'] ?? false,
    );
  }
}
