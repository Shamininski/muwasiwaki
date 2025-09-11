// lib/features/auth/domain/entities/user.dart
import 'package:equatable/equatable.dart';
import '../../../../shared/enums/user_role.dart';

class AppUser extends Equatable {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, name, role, createdAt];
}
