// lib/features/roles/domain/repositories/roles_repository.dart
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/permission.dart';
import '../entities/role_assignment.dart';
import '../entities/user_role.dart';

/// Abstract repository interface for roles management operations.
///
/// This repository defines the contract for all role-related data operations
/// including fetching user roles, managing permissions, and handling role assignments.
abstract class RolesRepository {
  /// Retrieves all available user roles from the data source.
  ///
  /// Returns a list of [UserRoleEntity] objects wrapped in an [Either]
  /// containing either a [Failure] on error or the list of roles on success.
  Future<Either<Failure, List<UserRoleEntity>>> getUserRoles();

  /// Retrieves all available permissions from the data source.
  ///
  /// Returns a list of [Permission] objects wrapped in an [Either]
  /// containing either a [Failure] on error or the list of permissions on success.
  Future<Either<Failure, List<Permission>>> getPermissions();

  /// Retrieves all role assignments from the data source.
  ///
  /// Returns a list of [RoleAssignment] objects wrapped in an [Either]
  /// containing either a [Failure] on error or the list of assignments on success.
  Future<Either<Failure, List<RoleAssignment>>> getRoleAssignments();

  /// Checks if a specific user has a particular permission.
  ///
  /// Takes a [userId] and [permission] string and returns a boolean
  /// wrapped in an [Either] indicating whether the user has the permission.
  /// Returns [Failure] if the check cannot be performed.
  Future<Either<Failure, bool>> checkPermission(
      String userId, String permission);

  /// Assigns a role to a user.
  ///
  /// Takes a [userId], [roleId], and optional [expiresAt] date.
  /// Returns an [Either] with [Failure] on error or void on success.
  Future<Either<Failure, void>> assignRole({
    required String userId,
    required String roleId,
    DateTime? expiresAt,
  });

  /// Revokes a role from a user.
  ///
  /// Takes a [userId] and [roleId] to revoke the specified role.
  /// Returns an [Either] with [Failure] on error or void on success.
  Future<Either<Failure, void>> revokeRole({
    required String userId,
    required String roleId,
  });
}
