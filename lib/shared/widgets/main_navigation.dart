// lib/shared/widgets/main_navigation.dart (Updated)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muwasiwaki/shared/enums/user_role.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

class MainNavigation extends StatelessWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  int _getCurrentIndex(BuildContext context, bool canManageMembers) {
    final location = GoRouterState.of(context).matchedLocation;

    if (canManageMembers) {
      if (location == '/home') return 0;
      if (location.startsWith('/news')) return 1;
      if (location.startsWith('/pending-applications')) return 2;
      if (location.startsWith('/profile')) return 3;
      return 0;
    } else {
      if (location == '/home') return 0;
      if (location.startsWith('/news')) return 1;
      if (location.startsWith('/profile')) return 2;
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
          if (state is! AuthAuthenticated) return const SizedBox();

          final canManageMembers = state.user.role.canApproveMembers;
          final currentIndex = _getCurrentIndex(context, canManageMembers);

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

//  ********* THE CODE FROM HERE BELOW IS NOT PRESENT IN THE AGENT TEMPLATE  **********// 01 JAN 2026
          final String currentLocation =
              GoRouterState.of(context).uri.toString();
//  ********* THIS CODE BLOCK IS NOT PRESENT IN THE REVISION FOR 7 SUBREGIONS **********// 16 DEC 2025
          var selectedIndex = 0;
          if (currentLocation.contains('/pending-applications')) {
            selectedIndex = 1;
          } else if (currentLocation.contains('/profile')) {
            selectedIndex = canManageMembers ? 2 : 1;
          }
//  ********* THIS COD BLOCK IS NOT PRESENT IN THE REVISION FOR 7 SUBREGIONS **********// 16 DEC 2025

          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF667EEA),
            unselectedItemColor: Colors.grey,
            currentIndex: selectedIndex,
            items: items,
            // replaced the below with the item variable above
            // items: <BottomNavigationBarItem>[
            //   const BottomNavigationBarItem(
            //     icon: Icon(Icons.newspaper),
            //     label: 'News',
            //   ),
            //   if (canManageMembers)
            //     const BottomNavigationBarItem(
            //       icon: Icon(Icons.people),
            //       label: 'Members',
            //     ),
            //   const BottomNavigationBarItem(
            //     icon: Icon(Icons.person),
            //     label: 'Profile',
            //   ),
            // ],
            onTap: (index) {
              if (canManageMembers) {
                // Has 4 items: Home, News, Members, Profile
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
                // Has 3 items: Home, News, Profile
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
    );
  }
}
