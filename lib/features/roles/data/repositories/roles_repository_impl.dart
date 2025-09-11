// lib/features/roles/data/repositories/roles_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/entities/permission.dart';
import '../../domain/entities/role_assignment.dart';
import '../../domain/repositories/roles_repository.dart';
import '../datasources/roles_remote_datasource.dart';

class RolesRepositoryImpl implements RolesRepository {
  final RolesRemoteDataSource remoteDataSource;

  RolesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<UserRoleEntity>>> getUserRoles() async {
    try {
      final roles = await remoteDataSource.getUserRoles();
      return Right(roles.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Permission>>> getPermissions() async {
    try {
      final permissions = await remoteDataSource.getPermissions();
      return Right(permissions.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RoleAssignment>>> getRoleAssignments() async {
    try {
      final assignments = await remoteDataSource.getRoleAssignments();
      return Right(assignments.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkPermission(
      String userId, String permission) async {
    try {
      final hasPermission =
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
