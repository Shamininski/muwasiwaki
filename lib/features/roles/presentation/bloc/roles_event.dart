// lib/features/roles/presentation/bloc/roles_event.dart
import 'package:equatable/equatable.dart';

abstract class RolesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRolesEvent extends RolesEvent {}

class RefreshRolesEvent extends RolesEvent {}

class CheckPermissionEvent extends RolesEvent {
  final String userId;
  final String permission;

  CheckPermissionEvent({required this.userId, required this.permission});

  @override
  List<Object?> get props => [userId, permission];
}

class AssignRoleEvent extends RolesEvent {
  final String userId;
  final String roleId;
  final DateTime? expiresAt;

  AssignRoleEvent({
    required this.userId,
    required this.roleId,
    this.expiresAt,
  });

  @override
  List<Object?> get props => [userId, roleId, expiresAt];
}

class RevokeRoleEvent extends RolesEvent {
  final String userId;
  final String roleId;

  RevokeRoleEvent({required this.userId, required this.roleId});

  @override
  List<Object?> get props => [userId, roleId];
}

class LoadPermissionsEvent extends RolesEvent {}

class LoadRoleAssignmentsEvent extends RolesEvent {}

class ClearRolesErrorEvent extends RolesEvent {}
