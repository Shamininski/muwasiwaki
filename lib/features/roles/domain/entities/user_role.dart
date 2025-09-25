// lib/features/roles/domain/entities/user_role.dart
import 'package:equatable/equatable.dart';

class UserRoleEntity extends Equatable {

  const UserRoleEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
    required this.level,
    required this.isActive,
    required this.createdAt,
  });
  final String id;
  final String name;
  final String description;
  final List<String> permissions;
  final int level; // Higher level = more authority
  final bool isActive;
  final DateTime createdAt;

  @override
  List<Object?> get props =>
      <Object?>[id, name, description, permissions, level, isActive, createdAt];
}
