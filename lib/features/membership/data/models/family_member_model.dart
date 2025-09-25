// lib/features/membership/data/models/family_member_model.dart
import '../../domain/entities/family_member.dart';

class FamilyMemberModel extends FamilyMember {
  const FamilyMemberModel({
    required super.name,
    required super.dateOfBirth,
    required super.relationship,
  });

  factory FamilyMemberModel.fromEntity(FamilyMember entity) {
    return FamilyMemberModel(
      name: entity.name,
      dateOfBirth: entity.dateOfBirth,
      relationship: entity.relationship,
    );
  }

  factory FamilyMemberModel.fromMap(Map<String, dynamic> map) {
    return FamilyMemberModel(
      name: map['name'] ?? '',
      dateOfBirth: _parseDateTime(map['dateOfBirth']),
      relationship: map['relationship'] ?? '',
    );
  }

  static DateTime _parseDateTime(dynamic dateTime) {
    if (dateTime is String) {
      return DateTime.parse(dateTime);
    } else if (dateTime is DateTime) {
      return dateTime;
    } else {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'relationship': relationship,
    };
  }

  FamilyMember toEntity() {
    return FamilyMember(
      name: name,
      dateOfBirth: dateOfBirth,
      relationship: relationship,
    );
  }

  FamilyMemberModel copyWith({
    String? name,
    DateTime? dateOfBirth,
    String? relationship,
  }) {
    return FamilyMemberModel(
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      relationship: relationship ?? this.relationship,
    );
  }

  @override
  String toString() {
    return 'FamilyMemberModel(name: $name, relationship: $relationship, age: $age)';
  }
}
