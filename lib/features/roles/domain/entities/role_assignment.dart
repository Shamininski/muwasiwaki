// lib/features/roles/domain/entities/role_assignment.dart
import 'package:equatable/equatable.dart';

class RoleAssignment extends Equatable {
  final String id;
  final String userId;
  final String roleId;
  final String roleName;
  final String assignedBy;
  final String assignedByName;
  final DateTime assignedAt;
  final DateTime? expiresAt;
  final bool isActive;

  const RoleAssignment({
    required this.id,
    required this.userId,
    required this.roleId,
    required this.roleName,
    required this.assignedBy,
    required this.assignedByName,
    required this.assignedAt,
    this.expiresAt,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        roleId,
        roleName,
        assignedBy,
        assignedByName,
        assignedAt,
        expiresAt,
        isActive,
      ];
}
