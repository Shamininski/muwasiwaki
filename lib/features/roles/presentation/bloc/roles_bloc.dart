// lib/features/roles/presentation/bloc/roles_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/entities/permission.dart';
import '../../domain/entities/role_assignment.dart';
import '../../domain/usecases/get_user_roles_usecase.dart';
import '../../domain/usecases/check_permission_usecase.dart';
import '../../domain/usecases/assign_role_usecase.dart';
import '../../domain/usecases/revoke_role_usecase.dart';

// Events
abstract class RolesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRolesEvent extends RolesEvent {}

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

// States
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

class PermissionChecked extends RolesState {
  final bool hasPermission;

  PermissionChecked({required this.hasPermission});

  @override
  List<Object?> get props => [hasPermission];
}

class RoleAssigned extends RolesState {}

class RoleRevoked extends RolesState {}

class RolesError extends RolesState {
  final String message;

  RolesError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class RolesBloc extends Bloc<RolesEvent, RolesState> {
  final GetUserRolesUseCase getUserRolesUseCase;
  final CheckPermissionUseCase checkPermissionUseCase;
  final AssignRoleUseCase assignRoleUseCase;
  final RevokeRoleUseCase revokeRoleUseCase;

  RolesBloc({
    required this.getUserRolesUseCase,
    required this.checkPermissionUseCase,
    required this.assignRoleUseCase,
    required this.revokeRoleUseCase,
  }) : super(RolesInitial()) {
    on<LoadRolesEvent>(_onLoadRoles);
    on<CheckPermissionEvent>(_onCheckPermission);
    on<AssignRoleEvent>(_onAssignRole);
    on<RevokeRoleEvent>(_onRevokeRole);
  }

  void _onLoadRoles(LoadRolesEvent event, Emitter<RolesState> emit) async {
    emit(RolesLoading());
    final result = await getUserRolesUseCase();
    result.fold(
      (failure) => emit(RolesError(message: failure.message)),
      (roles) => emit(RolesLoaded(roles: roles)),
    );
  }

  void _onCheckPermission(
      CheckPermissionEvent event, Emitter<RolesState> emit) async {
    final result = await checkPermissionUseCase(CheckPermissionParams(
      userId: event.userId,
      permission: event.permission,
    ));
    result.fold(
      (failure) => emit(RolesError(message: failure.message)),
      (hasPermission) => emit(PermissionChecked(hasPermission: hasPermission)),
    );
  }

  void _onAssignRole(AssignRoleEvent event, Emitter<RolesState> emit) async {
    final result = await assignRoleUseCase(AssignRoleParams(
      userId: event.userId,
      roleId: event.roleId,
      expiresAt: event.expiresAt,
    ));
    result.fold(
      (failure) => emit(RolesError(message: failure.message)),
      (_) => emit(RoleAssigned()),
    );
  }

  void _onRevokeRole(RevokeRoleEvent event, Emitter<RolesState> emit) async {
    final result = await revokeRoleUseCase(RevokeRoleParams(
      userId: event.userId,
      roleId: event.roleId,
    ));
    result.fold(
      (failure) => emit(RolesError(message: failure.message)),
      (_) => emit(RoleRevoked()),
    );
  }
}
