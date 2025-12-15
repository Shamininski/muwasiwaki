// lib/features/roles/data/models/user_role_model.dart (Updated with extension)
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

  factory UserRoleModel.fromEntity(UserRoleEntity entity) {
    return UserRoleModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      permissions: entity.permissions,
      level: entity.level,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
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

// Extension for local storage Map conversion
extension UserRoleModelLocalStorage on UserRoleModel {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'permissions': permissions,
      'level': level,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static UserRoleModel fromMap(Map<String, dynamic> map) {
    return UserRoleModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      permissions: List<String>.from(map['permissions'] ?? []),
      level: map['level'] ?? 0,
      isActive: map['isActive'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
