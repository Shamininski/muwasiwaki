// lib/features/news/presentation/pages/news_feed_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../bloc/news_bloc.dart';
import '../../domain/entities/news_article.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class NewsFeedPage extends StatelessWidget {
  const NewsFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MUWASIWAKI News'),
        backgroundColor: const Color(0xFF667EEA),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        ],
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<NewsBloc>().add(LoadNewsEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.articles.length,
                itemBuilder: (context, index) {
                  final article = state.articles[index];
                  return _NewsCard(article: article);
                },
              ),
            );
          } else if (state is NewsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<NewsBloc>().add(LoadNewsEvent()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated && state.user.role.canCreateNews) {
            return FloatingActionButton(
              onPressed: () => context.push('/create-news'),
              backgroundColor: const Color(0xFF667EEA),
              child: const Icon(Icons.add),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsArticle article;

  const _NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF667EEA), width: 1),
      ),
      child: InkWell(
        onTap: () => context.push('/news/${article.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'By ${article.authorName}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Text(' • ', style: TextStyle(color: Colors.grey)),
                  Text(
                    DateFormat('MMM dd, yyyy').format(article.createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Text(' • ', style: TextStyle(color: Colors.grey)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF667EEA).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      article.category,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF667EEA),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                article.content.length > 150
                    ? '${article.content.substring(0, 150)}...'
                    : article.content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
