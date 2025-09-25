// lib/shared/widgets/permission_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muwasiwaki/features/auth/domain/entities/user.dart';
import 'package:muwasiwaki/shared/enums/user_role.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

class PermissionWrapper extends StatelessWidget {
  const PermissionWrapper({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });
  final String permission;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (BuildContext context, AuthState state) {
        if (state is! AuthAuthenticated) {
          return fallback ?? const SizedBox.shrink();
        }

        // For now, use role-based permissions
        final AppUser user = state.user;
        var hasPermission = false;

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
