// lib/features/roles/data/datasources/roles_local_datasource.dart
import '../../../../core/services/local_storage_service.dart';
import '../models/permission_model.dart';
import '../models/role_assignment_model.dart';
import '../models/user_role_model.dart';

abstract class RolesLocalDataSource {
  Future<List<UserRoleModel>> getCachedRoles();
  Future<void> cacheRoles(List<UserRoleModel> roles);
  Future<void> clearRolesCache();
  Future<List<PermissionModel>> getCachedPermissions();
  Future<void> cachePermissions(List<PermissionModel> permissions);
  Future<List<RoleAssignmentModel>> getCachedRoleAssignments();
  Future<void> cacheRoleAssignments(List<RoleAssignmentModel> assignments);
}

class RolesLocalDataSourceImpl implements RolesLocalDataSource {
  final LocalStorageService localStorage;
  static const String _rolesCacheKey = 'cached_roles';
  static const String _permissionsCacheKey = 'cached_permissions';
  static const String _assignmentsCacheKey = 'cached_role_assignments';

  RolesLocalDataSourceImpl(this.localStorage);

  @override
  Future<List<UserRoleModel>> getCachedRoles() async {
    try {
      final rolesData = localStorage.getObject(_rolesCacheKey);
      if (rolesData != null && rolesData['roles'] is List) {
        final rolesList = rolesData['roles'] as List;
        return rolesList
            .map((role) =>
                UserRoleModelLocalStorage.fromMap(role as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheRoles(List<UserRoleModel> roles) async {
    try {
      final rolesData = {
        'roles': roles.map((role) => role.toMap()).toList(),
        'cachedAt': DateTime.now().toIso8601String(),
      };
      await localStorage.setObject(_rolesCacheKey, rolesData);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<void> clearRolesCache() async {
    try {
      await localStorage.remove(_rolesCacheKey);
      await localStorage.remove(_permissionsCacheKey);
      await localStorage.remove(_assignmentsCacheKey);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<List<PermissionModel>> getCachedPermissions() async {
    try {
      final permissionsData = localStorage.getObject(_permissionsCacheKey);
      if (permissionsData != null && permissionsData['permissions'] is List) {
        final permissionsList = permissionsData['permissions'] as List;
        return permissionsList
            .map((permission) => PermissionModelLocalStorage.fromMap(
                permission as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cachePermissions(List<PermissionModel> permissions) async {
    try {
      final permissionsData = {
        'permissions':
            permissions.map((permission) => permission.toMap()).toList(),
        'cachedAt': DateTime.now().toIso8601String(),
      };
      await localStorage.setObject(_permissionsCacheKey, permissionsData);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<List<RoleAssignmentModel>> getCachedRoleAssignments() async {
    try {
      final assignmentsData = localStorage.getObject(_assignmentsCacheKey);
      if (assignmentsData != null && assignmentsData['assignments'] is List) {
        final assignmentsList = assignmentsData['assignments'] as List;
        return assignmentsList
            .map((assignment) => RoleAssignmentModelLocalStorage.fromMap(
                assignment as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheRoleAssignments(
      List<RoleAssignmentModel> assignments) async {
    try {
      final assignmentsData = {
        'assignments':
            assignments.map((assignment) => assignment.toMap()).toList(),
        'cachedAt': DateTime.now().toIso8601String(),
      };
      await localStorage.setObject(_assignmentsCacheKey, assignmentsData);
    } catch (e) {
      // Silently fail
    }
  }
}
