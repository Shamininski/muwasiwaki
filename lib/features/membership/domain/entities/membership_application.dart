// lib/features/membership/domain/entities/membership_application.dart
import 'package:equatable/equatable.dart';
import 'family_member.dart';

enum ApplicationStatus { pending, approved, rejected }

class MembershipApplication extends Equatable {
  final String id;
  final String applicantName;
  final String email;
  final String phone;
  final String district;
  final String profession;
  final String reasonForJoining;
  final DateTime dateOfEntry;
  final List<FamilyMember> familyMembers;
  final ApplicationStatus status;
  final DateTime createdAt;
  final String? reviewedBy;
  final DateTime? reviewedAt;

  const MembershipApplication({
    required this.id,
    required this.applicantName,
    required this.email,
    required this.phone,
    required this.district,
    required this.profession,
    required this.reasonForJoining,
    required this.dateOfEntry,
    required this.familyMembers,
    required this.status,
    required this.createdAt,
    this.reviewedBy,
    this.reviewedAt,
  });

  @override
  List<Object?> get props => [
    id,
    applicantName,
    email,
    phone,
    district,
    profession,
    reasonForJoining,
    dateOfEntry,
    familyMembers,
    status,
    createdAt,
    reviewedBy,
    reviewedAt,
  ];
}
