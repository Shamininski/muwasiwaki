import 'package:equatable/equatable.dart';

class Permission extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category; // news, membership, admin, etc.
  final bool isActive;

  const Permission({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, name, description, category, isActive];
}
