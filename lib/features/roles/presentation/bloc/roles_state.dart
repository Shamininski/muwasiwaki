// lib/features/roles/presentation/bloc/roles_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/entities/permission.dart';
import '../../domain/entities/role_assignment.dart';

abstract class RolesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RolesInitial extends RolesState {}

class RolesLoading extends RolesState {}

class RolesLoaded extends RolesState {
  final List<UserRoleEntity> roles;

  RolesLoaded({required this.roles});

  @override
  List<Object?> get props => [roles];
}

class PermissionsLoaded extends RolesState {
  final List<Permission> permissions;

  PermissionsLoaded({required this.permissions});

  @override
  List<Object?> get props => [permissions];
}

class RoleAssignmentsLoaded extends RolesState {
  final List<RoleAssignment> assignments;

  RoleAssignmentsLoaded({required this.assignments});

  @override
  List<Object?> get props => [assignments];
}

class PermissionChecked extends RolesState {
  final bool hasPermission;
  final String userId;
  final String permission;

  PermissionChecked({
    required this.hasPermission,
    required this.userId,
    required this.permission,
  });

  @override
  List<Object?> get props => [hasPermission, userId, permission];
}

class RoleAssigned extends RolesState {
  final String message;

  RoleAssigned({this.message = 'Role assigned successfully'});

  @override
  List<Object?> get props => [message];
}

class RoleRevoked extends RolesState {
  final String message;

  RoleRevoked({this.message = 'Role revoked successfully'});

  @override
  List<Object?> get props => [message];
}

class RolesError extends RolesState {
  final String message;

  RolesError({required this.message});

  @override
  List<Object?> get props => [message];
}
