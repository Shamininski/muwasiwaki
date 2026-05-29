// // lib/shared/widgets/main_navigation.dart (Updated)
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:muwasiwaki/shared/enums/user_role.dart';
// import '../../features/auth/presentation/bloc/auth_bloc.dart';

// class MainNavigation extends StatelessWidget {
//   final Widget child;

//   const MainNavigation({super.key, required this.child});

//   int _getCurrentIndex(BuildContext context, bool canManageMembers) {
//     final location = GoRouterState.of(context).matchedLocation;

//     if (canManageMembers) {
//       if (location == '/home') return 0;
//       if (location.startsWith('/news')) return 1;
//       if (location.startsWith('/pending-applications')) return 2;
//       if (location.startsWith('/profile')) return 3;
//       return 0;
//     } else {
//       if (location == '/home') return 0;
//       if (location.startsWith('/news')) return 1;
//       if (location.startsWith('/profile')) return 2;
//       return 0;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: child,
//       bottomNavigationBar: BlocBuilder<AuthBloc, AuthState>(
//         builder: (BuildContext context, AuthState state) {
//           if (state is! AuthAuthenticated) return const SizedBox();

//           final canManageMembers = state.user.role.canApproveMembers;
//           final currentIndex = _getCurrentIndex(context, canManageMembers);

//           final items = [
//             const BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             const BottomNavigationBarItem(
//               icon: Icon(Icons.newspaper),
//               label: 'News',
//             ),
//             if (canManageMembers)
//               const BottomNavigationBarItem(
//                 icon: Icon(Icons.people),
//                 label: 'Members',
//               ),
//             const BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               label: 'Profile',
//             ),
//           ];

// //  ********* THE CODE FROM HERE BELOW IS NOT PRESENT IN THE AGENT TEMPLATE  **********// 01 JAN 2026
//           final String currentLocation =
//               GoRouterState.of(context).uri.toString();
// //  ********* THIS CODE BLOCK IS NOT PRESENT IN THE REVISION FOR 7 SUBREGIONS **********// 16 DEC 2025
//           var selectedIndex = 0;
//           if (currentLocation.contains('/pending-applications')) {
//             selectedIndex = 1;
//           } else if (currentLocation.contains('/profile')) {
//             selectedIndex = canManageMembers ? 2 : 1;
//           }
// //  ********* THIS COD BLOCK IS NOT PRESENT IN THE REVISION FOR 7 SUBREGIONS **********// 16 DEC 2025

//           return BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             selectedItemColor: const Color(0xFF667EEA),
//             unselectedItemColor: Colors.grey,
//             currentIndex: selectedIndex,
//             items: items,
//             // replaced the below with the item variable above
//             // items: <BottomNavigationBarItem>[
//             //   const BottomNavigationBarItem(
//             //     icon: Icon(Icons.newspaper),
//             //     label: 'News',
//             //   ),
//             //   if (canManageMembers)
//             //     const BottomNavigationBarItem(
//             //       icon: Icon(Icons.people),
//             //       label: 'Members',
//             //     ),
//             //   const BottomNavigationBarItem(
//             //     icon: Icon(Icons.person),
//             //     label: 'Profile',
//             //   ),
//             // ],
//             onTap: (index) {
//               if (canManageMembers) {
//                 // Has 4 items: Home, News, Members, Profile
//                 switch (index) {
//                   case 0:
//                     context.go('/home');
//                     break;
//                   case 1:
//                     context.go('/news');
//                     break;
//                   case 2:
//                     context.go('/pending-applications');
//                     break;
//                   case 3:
//                     context.go('/profile');
//                     break;
//                 }
//               } else {
//                 // Has 3 items: Home, News, Profile
//                 switch (index) {
//                   case 0:
//                     context.go('/home');
//                     break;
//                   case 1:
//                     context.go('/news');
//                     break;
//                   case 2:
//                     context.go('/profile');
//                     break;
//                 }
//               }
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// lib/shared/widgets/main_navigation.dart (Updated on 18th May 2026)
//Commented out on 29th May 2026

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import '../../features/auth/presentation/bloc/auth_bloc.dart';
// import '../../features/news/presentation/bloc/news_bloc.dart';
// import '../../features/membership/presentation/bloc/membership_bloc.dart';
// import '../../core/injection/injection_container.dart' as di;
// import 'package:muwasiwaki/routes/app_router.dart';

// class MuwasiwakiApp extends StatelessWidget {
//   const MuwasiwakiApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => di.sl<AuthBloc>()..add(CheckAuthEvent()),
//         ),
//         BlocProvider(create: (context) => di.sl<NewsBloc>()),
//         BlocProvider(create: (context) => di.sl<MembershipBloc>()),
//       ],
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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muwasiwaki/routes/app_router.dart';
import 'package:muwasiwaki/shared/enums/user_role.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/news/presentation/bloc/news_bloc.dart';
import '../../features/membership/presentation/bloc/membership_bloc.dart';
import '../../core/injection/injection_container.dart' as di;

class MainNavigation extends StatelessWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  int _getCurrentIndex(String location, bool canManageMembers) {
    if (canManageMembers) {
      // Has 4 items: Home, News, Members, Profile
      if (location == '/home') return 0;
      if (location.startsWith('/news')) return 1;
      if (location.startsWith('/create-news')) return 1;
      if (location.startsWith('/pending-applications')) return 2;
      if (location.startsWith('/profile')) return 3;
      return 0;
    } else {
      // Has 3 items: Home, News, Profile
      if (location == '/home') return 0;
      if (location.startsWith('/news')) return 1;
      if (location.startsWith('/create-news')) return 1;
      if (location.startsWith('/profile')) return 2;
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;

        // If not on home, go to home
        if (location != '/home') {
          context.go('/home');
          return;
        }

        // If on home, show exit dialog
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App?'),
            content: const Text('Do you want to exit MUWASIWAKI?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Exit'),
              ),
            ],
          ),
        );

        if (shouldExit == true && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is! AuthAuthenticated) return const SizedBox();

            final canManageMembers = state.user.role.canApproveMembers;
            final currentIndex = _getCurrentIndex(location, canManageMembers);

            final items = [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.newspaper),
                label: 'News',
              ),
              if (canManageMembers)
                const BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Members',
                ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ];

            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF667EEA),
              unselectedItemColor: Colors.grey,
              currentIndex: currentIndex,
              items: items,
              onTap: (index) {
                if (canManageMembers) {
                  switch (index) {
                    case 0:
                      context.go('/home');
                      break;
                    case 1:
                      context.go('/news');
                      break;
                    case 2:
                      context.go('/pending-applications');
                      break;
                    case 3:
                      context.go('/profile');
                      break;
                  }
                } else {
                  switch (index) {
                    case 0:
                      context.go('/home');
                      break;
                    case 1:
                      context.go('/news');
                      break;
                    case 2:
                      context.go('/profile');
                      break;
                  }
                }
              },
            );
          },
        ),
      ),
    );
  }
}
