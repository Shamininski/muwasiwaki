// lib/features/membership/domain/entities/membership_application.dart
import 'package:equatable/equatable.dart';
import 'family_member.dart';

enum ApplicationStatus { pending, approved, rejected }

class MembershipApplication extends Equatable {
  const MembershipApplication({
    required this.id,
    required this.applicantName,
    required this.email,
    required this.phone,
    required this.subregion,
    required this.profession,
    this.nidaNumber,
    required this.dateOfEntry,
    required this.familyMembers,
    required this.status,
    required this.createdAt,
    this.reviewedBy,
    this.reviewedAt,
  });
  final String id;
  final String applicantName;
  final String email;
  final String phone;
  final String subregion;
  final String profession;
  final String? nidaNumber; // Add NIDA tracking
  final DateTime dateOfEntry;
  final List<FamilyMember> familyMembers;
  final ApplicationStatus status;
  final DateTime createdAt;
  final String? reviewedBy;
  final DateTime? reviewedAt;

  @override
  List<Object?> get props => <Object?>[
        id,
        applicantName,
        email,
        phone,
        subregion,
        profession,
        nidaNumber,
        dateOfEntry,
        familyMembers,
        status,
        createdAt,
        reviewedBy,
        reviewedAt,
      ];
}
