// // lib/app.dart (Updated) Commentd out on 29May2026-resolve the WillPopScope

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:go_router/go_router.dart';
// import 'package:nested/nested.dart';
// import 'core/injection/injection_container.dart';
// import 'core/theme/app_theme.dart';
// import 'features/auth/presentation/bloc/auth_bloc.dart';
// import 'features/news/presentation/bloc/news_bloc.dart';
// import 'features/membership/presentation/bloc/membership_bloc.dart';
// import 'features/profile/presentation/bloc/profile_bloc.dart';
// import 'features/roles/presentation/bloc/roles_bloc.dart';
// import 'routes/app_router.dart';

// class MuwasiwakiApp extends StatelessWidget {
//   const MuwasiwakiApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: <SingleChildWidget>[
//         BlocProvider<AuthBloc>(
//           create: (_) => sl<AuthBloc>()..add(CheckAuthEvent()),
//         ),
//         BlocProvider<NewsBloc>(
//           create: (_) => sl<NewsBloc>()..add(LoadNewsEvent()),
//         ),
//         BlocProvider<MembershipBloc>(
//           create: (_) => sl<MembershipBloc>(),
//         ),
//         BlocProvider<ProfileBloc>(
//           create: (_) => sl<ProfileBloc>(),
//         ),
//         BlocProvider<RolesBloc>(
//           create: (_) => sl<RolesBloc>(),
//         ),
//       ],
//       // child: MaterialApp.router(
//       //   title: 'MUWASIWAKI',
//       //   theme: AppTheme.lightTheme,
//       //   routerConfig: AppRouter.router,
//       //   debugShowCheckedModeBanner: false,
//       // ),
//       child: BlocBuilder<AuthBloc, AuthState>(
//         builder: (context, state) {
//           // Show splash while checking auth
//           if (state is AuthInitial || state is AuthLoading) {
//             return MaterialApp(
//               debugShowCheckedModeBanner: false,
//               home: Scaffold(
//                 body: Container(
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//                     ),
//                   ),
//                   child: const Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.group, size: 80, color: Colors.white),
//                         SizedBox(height: 16),
//                         Text(
//                           'MUWASIWAKI',
//                           style: TextStyle(
//                             fontSize: 32,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(height: 32),
//                         CircularProgressIndicator(color: Colors.white),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }
//           // Auth checked, show app
//           return MaterialApp.router(
//             title: 'MUWASIWAKI',
//             debugShowCheckedModeBanner: false,
//             theme: ThemeData(
//               primarySwatch: Colors.blue,
//               useMaterial3: true,
//             ),
//             routerConfig: AppRouter.router,
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/news/presentation/bloc/news_bloc.dart';
import 'features/membership/presentation/bloc/membership_bloc.dart';
import 'core/injection/injection_container.dart' as di;
import 'routes/app_router.dart';

class MuwasiwakiApp extends StatelessWidget {
  const MuwasiwakiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AuthBloc>()..add(CheckAuthEvent()),
        ),
        BlocProvider(create: (context) => di.sl<NewsBloc>()),
        BlocProvider(create: (context) => di.sl<MembershipBloc>()),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Show splash while checking auth
          if (state is AuthInitial || state is AuthLoading) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.group, size: 80, color: Colors.white),
                        SizedBox(height: 16),
                        Text(
                          'MUWASIWAKI',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 32),
                        CircularProgressIndicator(color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          // Auth checked, show app
          return MaterialApp.router(
            title: 'MUWASIWAKI',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
            ),
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
