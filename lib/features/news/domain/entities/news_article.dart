import 'package:equatable/equatable.dart';

class NewsArticle extends Equatable {
  final String id;
  final String title;
  final String content;
  final String category;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublished;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    required this.updatedAt,
    required this.isPublished,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    category,
    authorId,
    authorName,
    createdAt,
    updatedAt,
    isPublished,
  ];
}
