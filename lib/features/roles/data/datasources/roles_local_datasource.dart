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

// // lib/features/roles/data/datasources/roles_local_datasource.dart
// import '../../../../core/services/local_storage_service.dart';
// import '../models/permission_model.dart';
// import '../models/role_assignment_model.dart';
// import '../models/user_role_model.dart';

// abstract class RolesLocalDataSource {
//   Future<List<UserRoleModel>> getCachedRoles();
//   Future<void> cacheRoles(List<UserRoleModel> roles);
//   Future<void> clearRolesCache();
//   Future<List<PermissionModel>> getCachedPermissions();
//   Future<void> cachePermissions(List<PermissionModel> permissions);
//   Future<List<RoleAssignmentModel>> getCachedRoleAssignments();
//   Future<void> cacheRoleAssignments(List<RoleAssignmentModel> assignments);
// }

// class RolesLocalDataSourceImpl implements RolesLocalDataSource {
//   final LocalStorageService localStorage;
//   static const String _rolesCacheKey = 'cached_roles';
//   static const String _permissionsCacheKey = 'cached_permissions';
//   static const String _assignmentsCacheKey = 'cached_role_assignments';

//   RolesLocalDataSourceImpl(this.localStorage);

//   @override
//   Future<List<UserRoleModel>> getCachedRoles() async {
//     try {
//       final rolesData = localStorage.getObject(_rolesCacheKey);
//       if (rolesData != null && rolesData['roles'] is List) {
//         final rolesList = rolesData['roles'] as List;
//         return rolesList
//             .map((role) => UserRoleModel.fromMap(role as Map<String, dynamic>))
//             .toList();
//       }
//       return [];
//     } catch (e) {
//       return [];
//     }
//   }

//   @override
//   Future<void> cacheRoles(List<UserRoleModel> roles) async {
//     try {
//       final rolesData = {
//         'roles': roles.map((role) => role.toMap()).toList(),
//         'cachedAt': DateTime.now().toIso8601String(),
//       };
//       await localStorage.setObject(_rolesCacheKey, rolesData);
//     } catch (e) {
//       // Silently fail
//     }
//   }

//   @override
//   Future<void> clearRolesCache() async {
//     try {
//       await localStorage.remove(_rolesCacheKey);
//       await localStorage.remove(_permissionsCacheKey);
//       await localStorage.remove(_assignmentsCacheKey);
//     } catch (e) {
//       // Silently fail
//     }
//   }

//   @override
//   Future<List<PermissionModel>> getCachedPermissions() async {
//     try {
//       final permissionsData = localStorage.getObject(_permissionsCacheKey);
//       if (permissionsData != null && permissionsData['permissions'] is List) {
//         final permissionsList = permissionsData['permissions'] as List;
//         return permissionsList
//             .map((permission) =>
//                 PermissionModel.fromMap(permission as Map<String, dynamic>))
//             .toList();
//       }
//       return [];
//     } catch (e) {
//       return [];
//     }
//   }

//   @override
//   Future<void> cachePermissions(List<PermissionModel> permissions) async {
//     try {
//       final permissionsData = {
//         'permissions':
//             permissions.map((permission) => permission.toMap()).toList(),
//         'cachedAt': DateTime.now().toIso8601String(),
//       };
//       await localStorage.setObject(_permissionsCacheKey, permissionsData);
//     } catch (e) {
//       // Silently fail
//     }
//   }

//   @override
//   Future<List<RoleAssignmentModel>> getCachedRoleAssignments() async {
//     try {
//       final assignmentsData = localStorage.getObject(_assignmentsCacheKey);
//       if (assignmentsData != null && assignmentsData['assignments'] is List) {
//         final assignmentsList = assignmentsData['assignments'] as List;
//         return assignmentsList
//             .map((assignment) =>
//                 RoleAssignmentModel.fromMap(assignment as Map<String, dynamic>))
//             .toList();
//       }
//       return [];
//     } catch (e) {
//       return [];
//     }
//   }

//   @override
//   Future<void> cacheRoleAssignments(
//       List<RoleAssignmentModel> assignments) async {
//     try {
//       final assignmentsData = {
//         'assignments':
//             assignments.map((assignment) => assignment.toMap()).toList(),
//         'cachedAt': DateTime.now().toIso8601String(),
//       };
//       await localStorage.setObject(_assignmentsCacheKey, assignmentsData);
//     } catch (e) {
//       // Silently fail
//     }
//   }
// }

// // Extensions for Map conversion
// extension UserRoleModelMap on UserRoleModel {
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'description': description,
//       'permissions': permissions,
//       'level': level,
//       'isActive': isActive,
//       'createdAt': createdAt.toIso8601String(),
//     };
//   }

//   static UserRoleModel fromMap(Map<String, dynamic> map) {
//     return UserRoleModel(
//       id: map['id'] ?? '',
//       name: map['name'] ?? '',
//       description: map['description'] ?? '',
//       permissions: List<String>.from(map['permissions'] ?? []),
//       level: map['level'] ?? 0,
//       isActive: map['isActive'] ?? true,
//       createdAt: DateTime.parse(map['createdAt']),
//     );
//   }
// }

// extension PermissionModelMap on PermissionModel {
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'description': description,
//       'category': category,
//       'isActive': isActive,
//     };
//   }

//   static PermissionModel fromMap(Map<String, dynamic> map) {
//     return PermissionModel(
//       id: map['id'] ?? '',
//       name: map['name'] ?? '',
//       description: map['description'] ?? '',
//       category: map['category'] ?? '',
//       isActive: map['isActive'] ?? true,
//     );
//   }
// }

// extension RoleAssignmentModelMap on RoleAssignmentModel {
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'userId': userId,
//       'roleId': roleId,
//       'roleName': roleName,
//       'assignedBy': assignedBy,
//       'assignedByName': assignedByName,
//       'assignedAt': assignedAt.toIso8601String(),
//       'expiresAt': expiresAt?.toIso8601String(),
//       'isActive': isActive,
//     };
//   }

//   static RoleAssignmentModel fromMap(Map<String, dynamic> map) {
//     return RoleAssignmentModel(
//       id: map['id'] ?? '',
//       userId: map['userId'] ?? '',
//       roleId: map['roleId'] ?? '',
//       roleName: map['roleName'] ?? '',
//       assignedBy: map['assignedBy'] ?? '',
//       assignedByName: map['assignedByName'] ?? '',
//       assignedAt: DateTime.parse(map['assignedAt']),
//       expiresAt:
//           map['expiresAt'] != null ? DateTime.parse(map['expiresAt']) : null,
//       isActive: map['isActive'] ?? true,
//     );
//   }
// }
