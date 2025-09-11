// lib/shared/widgets/main_navigation.dart (Updated)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

class MainNavigation extends StatelessWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) return const SizedBox();

          final canManageMembers = state.user.role.canApproveMembers;
          final currentLocation = GoRouterState.of(context).uri.toString();

          int selectedIndex = 0;
          if (currentLocation.contains('/pending-applications')) {
            selectedIndex = 1;
          } else if (currentLocation.contains('/profile')) {
            selectedIndex = canManageMembers ? 2 : 1;
          }

          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF667EEA),
            unselectedItemColor: Colors.grey,
            currentIndex: selectedIndex,
            items: [
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
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go('/home');
                  break;
                case 1:
                  if (canManageMembers) {
                    context.go('/pending-applications');
                  } else {
                    context.go('/profile');
                  }
                  break;
                case 2:
                  if (canManageMembers) {
                    context.go('/profile');
                  }
                  break;
              }
            },
          );
        },
      ),
    );
  }
}

// // lib/shared/widgets/main_navigation.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import '../../features/auth/presentation/bloc/auth_bloc.dart';

// class MainNavigation extends StatelessWidget {
//   final Widget child;

//   const MainNavigation({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: child,
//       bottomNavigationBar: BlocBuilder<AuthBloc, AuthState>(
//         builder: (context, state) {
//           if (state is! AuthAuthenticated) return const SizedBox();

//           final canManageMembers = state.user.role.canApproveMembers;

//           return BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             selectedItemColor: const Color(0xFF667EEA),
//             unselectedItemColor: Colors.grey,
//             items: [
//               const BottomNavigationBarItem(
//                 icon: Icon(Icons.newspaper),
//                 label: 'News',
//               ),
//               if (canManageMembers)
//                 const BottomNavigationBarItem(
//                   icon: Icon(Icons.people),
//                   label: 'Members',
//                 ),
//               const BottomNavigationBarItem(
//                 icon: Icon(Icons.person),
//                 label: 'Profile',
//               ),
//             ],
//             onTap: (index) {
//               switch (index) {
//                 case 0:
//                   context.go('/home');
//                   break;
//                 case 1:
//                   if (canManageMembers) {
//                     context.go('/pending-applications');
//                   }
//                   break;
//                 case 2:
//                   // Profile page
//                   break;
//               }
//             },
//           );
//         },
//       ),
//     );
//   }
// }
