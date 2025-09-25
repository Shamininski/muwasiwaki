// lib/features/roles/presentation/bloc/roles_bloc.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muwasiwaki/core/error/failures.dart';
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
  List<Object?> get props => <Object?>[];
}

class LoadRolesEvent extends RolesEvent {}

class CheckPermissionEvent extends RolesEvent {

  CheckPermissionEvent({required this.userId, required this.permission});
  final String userId;
  final String permission;

  @override
  List<Object?> get props => <Object?>[userId, permission];
}

class AssignRoleEvent extends RolesEvent {

  AssignRoleEvent({
    required this.userId,
    required this.roleId,
    this.expiresAt,
  });
  final String userId;
  final String roleId;
  final DateTime? expiresAt;

  @override
  List<Object?> get props => <Object?>[userId, roleId, expiresAt];
}

class RevokeRoleEvent extends RolesEvent {

  RevokeRoleEvent({required this.userId, required this.roleId});
  final String userId;
  final String roleId;

  @override
  List<Object?> get props => <Object?>[userId, roleId];
}

// States
abstract class RolesState extends Equatable {
  @override
  List<Object?> get props => <Object?>[];
}

class RolesInitial extends RolesState {}

class RolesLoading extends RolesState {}

class RolesLoaded extends RolesState {

  RolesLoaded({required this.roles});
  final List<UserRoleEntity> roles;

  @override
  List<Object?> get props => <Object?>[roles];
}

class PermissionChecked extends RolesState {

  PermissionChecked({required this.hasPermission});
  final bool hasPermission;

  @override
  List<Object?> get props => <Object?>[hasPermission];
}

class RoleAssigned extends RolesState {}

class RoleRevoked extends RolesState {}

class RolesError extends RolesState {

  RolesError({required this.message});
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

// Bloc
class RolesBloc extends Bloc<RolesEvent, RolesState> {

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
  final GetUserRolesUseCase getUserRolesUseCase;
  final CheckPermissionUseCase checkPermissionUseCase;
  final AssignRoleUseCase assignRoleUseCase;
  final RevokeRoleUseCase revokeRoleUseCase;

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
    final Either<Failure, bool> result = await checkPermissionUseCase(CheckPermissionParams(
      userId: event.userId,
      permission: event.permission,
    ));
    result.fold(
      (Failure failure) => emit(RolesError(message: failure.message)),
      (bool hasPermission) => emit(PermissionChecked(hasPermission: hasPermission)),
    );
  }

  void _onAssignRole(AssignRoleEvent event, Emitter<RolesState> emit) async {
    final Either<Failure, void> result = await assignRoleUseCase(AssignRoleParams(
      userId: event.userId,
      roleId: event.roleId,
      expiresAt: event.expiresAt,
    ));
    result.fold(
      (Failure failure) => emit(RolesError(message: failure.message)),
      (_) => emit(RoleAssigned()),
    );
  }

  void _onRevokeRole(RevokeRoleEvent event, Emitter<RolesState> emit) async {
    final Either<Failure, void> result = await revokeRoleUseCase(RevokeRoleParams(
      userId: event.userId,
      roleId: event.roleId,
    ));
    result.fold(
      (Failure failure) => emit(RolesError(message: failure.message)),
      (_) => emit(RoleRevoked()),
    );
  }
}
