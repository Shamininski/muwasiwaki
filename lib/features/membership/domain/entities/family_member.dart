// lib/features/membership/domain/entities/family_member.dart
import 'package:equatable/equatable.dart';

class FamilyMember extends Equatable {
  final String name;
  final DateTime dateOfBirth;
  final String relationship; // 'wife', 'husband', 'child'

  const FamilyMember({
    required this.name,
    required this.dateOfBirth,
    required this.relationship,
  });

  @override
  List<Object?> get props => [name, dateOfBirth, relationship];
}
