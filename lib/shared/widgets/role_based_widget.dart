// lib/shared/widgets/role_based_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../shared/enums/user_role.dart';

class RoleBasedWidget extends StatelessWidget {

  const RoleBasedWidget({
    super.key,
    required this.child,
    this.allowedRoles,
    this.requiredPermissions,
    this.fallback,
  });
  final Widget child;
  final List<UserRole>? allowedRoles;
  final List<String>? requiredPermissions;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (BuildContext context, AuthState state) {
        if (state is! AuthAuthenticated) {
          return fallback ?? const SizedBox.shrink();
        }

        final AppUser user = state.user;

        // Check role-based access
        if (allowedRoles != null && !allowedRoles!.contains(user.role)) {
          return fallback ?? const SizedBox.shrink();
        }

        // TODO: Check permission-based access when roles feature is fully implemented
        // if (requiredPermissions != null) {
        //   // Check permissions
        // }

        return child;
      },
    );
  }
}
