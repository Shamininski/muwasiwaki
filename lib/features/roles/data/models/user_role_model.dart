// lib/features/roles/data/models/user_role_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_role.dart';

class UserRoleModel extends UserRoleEntity {
  const UserRoleModel({
    required super.id,
    required super.name,
    required super.description,
    required super.permissions,
    required super.level,
    required super.isActive,
    required super.createdAt,
  });

  factory UserRoleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserRoleModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      permissions: List<String>.from(data['permissions'] ?? []),
      level: data['level'] ?? 0,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'permissions': permissions,
      'level': level,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserRoleEntity toEntity() {
    return UserRoleEntity(
      id: id,
      name: name,
      description: description,
      permissions: permissions,
      level: level,
      isActive: isActive,
      createdAt: createdAt,
    );
  }
}
