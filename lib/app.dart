// lib/app.dart (Updated)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import 'core/injection/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/news/presentation/bloc/news_bloc.dart';
import 'features/membership/presentation/bloc/membership_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/roles/presentation/bloc/roles_bloc.dart';
import 'routes/app_router.dart';

class MuwasiwakiApp extends StatelessWidget {
  const MuwasiwakiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(CheckAuthEvent()),
        ),
        BlocProvider<NewsBloc>(
          create: (_) => sl<NewsBloc>()..add(LoadNewsEvent()),
        ),
        BlocProvider<MembershipBloc>(
          create: (_) => sl<MembershipBloc>(),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => sl<ProfileBloc>(),
        ),
        BlocProvider<RolesBloc>(
          create: (_) => sl<RolesBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'MUWASIWAKI',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
