// lib/features/membership/data/entities/family_member.dart
// Note: This should be in domain/entities, not data/entities
// Correcting the path - this file should be moved to domain/entities/family_member.dart

import 'package:equatable/equatable.dart';

class FamilyMember extends Equatable {
  final String name;
  final DateTime dateOfBirth;
  final String relationship; // 'wife', 'husband', 'child', 'son', 'daughter'

  const FamilyMember({
    required this.name,
    required this.dateOfBirth,
    required this.relationship,
  });

  @override
  List<Object?> get props => [name, dateOfBirth, relationship];

  // Helper methods
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  bool get isChild =>
      relationship.toLowerCase() == 'child' ||
      relationship.toLowerCase() == 'son' ||
      relationship.toLowerCase() == 'daughter';

  bool get isSpouse =>
      relationship.toLowerCase() == 'wife' ||
      relationship.toLowerCase() == 'husband';

  String get relationshipDisplay {
    switch (relationship.toLowerCase()) {
      case 'wife':
        return 'Wife';
      case 'husband':
        return 'Husband';
      case 'child':
        return 'Child';
      case 'son':
        return 'Son';
      case 'daughter':
        return 'Daughter';
      default:
        return relationship;
    }
  }

  FamilyMember copyWith({
    String? name,
    DateTime? dateOfBirth,
    String? relationship,
  }) {
    return FamilyMember(
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      relationship: relationship ?? this.relationship,
    );
  }
}
