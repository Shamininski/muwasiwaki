// lib/features/roles/data/repositories/roles_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:muwasiwaki/features/roles/data/models/permission_model.dart';
import 'package:muwasiwaki/features/roles/data/models/role_assignment_model.dart';
import 'package:muwasiwaki/features/roles/data/models/user_role_model.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/permission.dart';
import '../../domain/entities/role_assignment.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/repositories/roles_repository.dart';
import '../datasources/roles_remote_datasource.dart';

class RolesRepositoryImpl implements RolesRepository {
  RolesRepositoryImpl(this.remoteDataSource);
  final RolesRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<UserRoleEntity>>> getUserRoles() async {
    try {
      final List<UserRoleModel> roles = await remoteDataSource.getUserRoles();
      return Right(
          roles.map((UserRoleModel model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Permission>>> getPermissions() async {
    try {
      final List<PermissionModel> permissions =
          await remoteDataSource.getPermissions();
      return Right(permissions
          .map((PermissionModel model) => model.toEntity())
          .toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RoleAssignment>>> getRoleAssignments() async {
    try {
      final List<RoleAssignmentModel> assignments =
          await remoteDataSource.getRoleAssignments();
      return Right(assignments
          .map((RoleAssignmentModel model) => model.toEntity())
          .toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkPermission(
      String userId, String permission) async {
    try {
      final bool hasPermission =
          await remoteDataSource.checkPermission(userId, permission);
      return Right(hasPermission);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> assignRole({
    required String userId,
    required String roleId,
    DateTime? expiresAt,
  }) async {
    try {
      await remoteDataSource.assignRole(
        userId: userId,
        roleId: roleId,
        expiresAt: expiresAt,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> revokeRole({
    required String userId,
    required String roleId,
  }) async {
    try {
      await remoteDataSource.revokeRole(userId: userId, roleId: roleId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
