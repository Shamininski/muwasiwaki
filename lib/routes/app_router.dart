// lib/routes/app_router.dart (Updated)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/news/presentation/pages/news_feed_page.dart';
import '../features/news/presentation/pages/create_news_page.dart';
import '../features/membership/presentation/pages/membership_application_page.dart';
import '../features/membership/presentation/pages/pending_applications_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../shared/widgets/main_navigation.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final isLoggedIn = authState is AuthAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/apply-membership';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/apply-membership',
        builder: (context, state) => const MembershipApplicationPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const NewsFeedPage(),
          ),
          GoRoute(
            path: '/create-news',
            builder: (context, state) => const CreateNewsPage(),
          ),
          GoRoute(
            path: '/pending-applications',
            builder: (context, state) => const PendingApplicationsPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
}

// // lib/routes/app_router.dart
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../features/auth/presentation/bloc/auth_bloc.dart';
// import '../features/auth/presentation/pages/login_page.dart';
// import '../features/auth/presentation/pages/register_page.dart';
// import '../features/news/presentation/pages/news_feed_page.dart';
// import '../features/news/presentation/pages/create_news_page.dart';
// import '../features/membership/presentation/pages/membership_application_page.dart';
// import '../features/membership/presentation/pages/pending_applications_page.dart';
// import '../shared/widgets/main_navigation.dart';

// class AppRouter {
//   static final GoRouter router = GoRouter(
//     initialLocation: '/login',
//     redirect: (context, state) {
//       final authState = context.read<AuthBloc>().state;
//       final isLoggedIn = authState is AuthAuthenticated;
//       final isLoggingIn =
//           state.matchedLocation == '/login' ||
//           state.matchedLocation == '/register' ||
//           state.matchedLocation == '/apply-membership';

//       if (!isLoggedIn && !isLoggingIn) return '/login';
//       if (isLoggedIn && isLoggingIn) return '/home';
//       return null;
//     },
//     routes: [
//       GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
//       GoRoute(
//         path: '/register',
//         builder: (context, state) => const RegisterPage(),
//       ),
//       GoRoute(
//         path: '/apply-membership',
//         builder: (context, state) => const MembershipApplicationPage(),
//       ),
//       ShellRoute(
//         builder: (context, state, child) => MainNavigation(child: child),
//         routes: [
//           GoRoute(
//             path: '/home',
//             builder: (context, state) => const NewsFeedPage(),
//           ),
//           GoRoute(
//             path: '/create-news',
//             builder: (context, state) => const CreateNewsPage(),
//           ),
//           GoRoute(
//             path: '/pending-applications',
//             builder: (context, state) => const PendingApplicationsPage(),
//           ),
//         ],
//       ),
//     ],
//   );
// }
