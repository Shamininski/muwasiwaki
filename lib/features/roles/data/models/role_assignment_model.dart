// lib/features/roles/data/models/role_assignment_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/role_assignment.dart';

class RoleAssignmentModel extends RoleAssignment {
  const RoleAssignmentModel({
    required super.id,
    required super.userId,
    required super.roleId,
    required super.roleName,
    required super.assignedBy,
    required super.assignedByName,
    required super.assignedAt,
    super.expiresAt,
    required super.isActive,
  });

  factory RoleAssignmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RoleAssignmentModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      roleId: data['roleId'] ?? '',
      roleName: data['roleName'] ?? '',
      assignedBy: data['assignedBy'] ?? '',
      assignedByName: data['assignedByName'] ?? '',
      assignedAt:
          (data['assignedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: data['expiresAt'] != null
          ? (data['expiresAt'] as Timestamp).toDate()
          : null,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'roleId': roleId,
      'roleName': roleName,
      'assignedBy': assignedBy,
      'assignedByName': assignedByName,
      'assignedAt': Timestamp.fromDate(assignedAt),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'isActive': isActive,
    };
  }

  RoleAssignment toEntity() {
    return RoleAssignment(
      id: id,
      userId: userId,
      roleId: roleId,
      roleName: roleName,
      assignedBy: assignedBy,
      assignedByName: assignedByName,
      assignedAt: assignedAt,
      expiresAt: expiresAt,
      isActive: isActive,
    );
  }
}

// 
// /error/failures.dart';
// import '../entities/user_role.dart';
// import '../entities/permission.dart';
// import '../entities/role_assignment.dart';

// abstract class RolesRepository {
//   Future<Either<Failure, List<UserRoleEntity>>> getUserRoles();
//   Future<Either<Failure, List<Permission>>> getPermissions();
//   Future<Either<Failure, List<RoleAssignment>>> getRoleAssignments();
//   Future<Either<Failure, bool>> checkPermission(String userId, String permission);
//   Future<Either<Failure, void>> assignRole({
//     required String userId,
//     required String roleId,
//     DateTime? expiresAt,
//   });
//   Future<Either<Failure, void>> revokeRole({
//     required String userId,
//     required String roleId,
//   });
// }
// 