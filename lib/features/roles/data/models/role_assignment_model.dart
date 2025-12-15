// lib/features/roles/data/models/role_assignment_model.dart (Updated with extension)
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

  factory RoleAssignmentModel.fromEntity(RoleAssignment entity) {
    return RoleAssignmentModel(
      id: entity.id,
      userId: entity.userId,
      roleId: entity.roleId,
      roleName: entity.roleName,
      assignedBy: entity.assignedBy,
      assignedByName: entity.assignedByName,
      assignedAt: entity.assignedAt,
      expiresAt: entity.expiresAt,
      isActive: entity.isActive,
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

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get isValidNow => isActive && !isExpired;
}

// Extension for local storage Map conversion
extension RoleAssignmentModelLocalStorage on RoleAssignmentModel {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'roleId': roleId,
      'roleName': roleName,
      'assignedBy': assignedBy,
      'assignedByName': assignedByName,
      'assignedAt': assignedAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  static RoleAssignmentModel fromMap(Map<String, dynamic> map) {
    return RoleAssignmentModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      roleId: map['roleId'] ?? '',
      roleName: map['roleName'] ?? '',
      assignedBy: map['assignedBy'] ?? '',
      assignedByName: map['assignedByName'] ?? '',
      assignedAt: DateTime.parse(map['assignedAt']),
      expiresAt:
          map['expiresAt'] != null ? DateTime.parse(map['expiresAt']) : null,
      isActive: map['isActive'] ?? true,
    );
  }
}
