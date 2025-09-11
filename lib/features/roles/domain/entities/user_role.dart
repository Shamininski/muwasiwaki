// lib/features/roles/domain/entities/user_role.dart
import 'package:equatable/equatable.dart';

class UserRoleEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> permissions;
  final int level; // Higher level = more authority
  final bool isActive;
  final DateTime createdAt;

  const UserRoleEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
    required this.level,
    required this.isActive,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, name, description, permissions, level, isActive, createdAt];
}
