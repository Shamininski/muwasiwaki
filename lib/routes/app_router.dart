// lib/routes/app_router.dart (Updated)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/news/presentation/pages/news_feed_page.dart';
import '../features/news/presentation/pages/news_detail_page.dart';
import '../features/news/presentation/pages/create_news_page.dart';
import '../features/membership/presentation/pages/membership_application_page.dart';
import '../features/membership/presentation/pages/pending_applications_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../shared/widgets/main_navigation.dart';
import '../features/auth/presentation/pages/login_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (BuildContext context, GoRouterState state) {
      final AuthState authState = context.read<AuthBloc>().state;
      final bool isLoggedIn = authState is AuthAuthenticated;
      final bool isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/apply-membership';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/home';
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterPage(),
      ),
      GoRoute(
        path: '/apply-membership',
        builder: (BuildContext context, GoRouterState state) =>
            const MembershipApplicationPage(),
      ),
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) =>
            MainNavigation(child: child),
        routes: <RouteBase>[
          GoRoute(
            path: '/home',
            builder: (BuildContext context, GoRouterState state) =>
                const NewsFeedPage(),
          ),
          GoRoute(
            path:
                '/news/:id', // Added this route on 17Dec2025 to fix No news detail page
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return NewsDetailPage(newsId: id); // created this page afterwards
            },
          ),
          GoRoute(
            path: '/create-news',
            builder: (BuildContext context, GoRouterState state) =>
                const CreateNewsPage(),
          ),
          GoRoute(
            path: '/pending-applications',
            builder: (BuildContext context, GoRouterState state) =>
                const PendingApplicationsPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (BuildContext context, GoRouterState state) =>
                const ProfilePage(),
          ),
        ],
      ),
    ],
  );
}
