// lib/shared/widgets/permission_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

class PermissionWrapper extends StatelessWidget {
  final String permission;
  final Widget child;
  final Widget? fallback;

  const PermissionWrapper({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return fallback ?? const SizedBox.shrink();
        }

        // For now, use role-based permissions
        final user = state.user;
        bool hasPermission = false;

        switch (permission) {
          case 'create_news':
            hasPermission = user.role.canCreateNews;
            break;
          case 'approve_members':
            hasPermission = user.role.canApproveMembers;
            break;
          default:
            hasPermission = false;
        }

        if (!hasPermission) {
          return fallback ?? const SizedBox.shrink();
        }

        return child;
      },
    );
  }
}
