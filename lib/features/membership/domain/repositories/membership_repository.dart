// lib/features/membership/domain/repositories/membership_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
// import '../../data/entities/family_member.dart';
import '../../domain/entities/family_member.dart';
import '../entities/membership_application.dart';
// import '../../data/entities/membership_application.dart';

abstract class MembershipRepository {
  Future<Either<Failure, void>> applyForMembership({
    required String applicantName,
    required String email,
    required String phone,
    required String district,
    required String profession,
    required String reasonForJoining,
    required DateTime dateOfEntry,
    required List<FamilyMember> familyMembers,
  });

  Future<Either<Failure, List<MembershipApplication>>> getApplications();

  Future<Either<Failure, void>> approveMembership({
    required String applicationId,
    required bool approved,
  });

  Future<Either<Failure, MembershipApplication?>> getApplicationById(String id);
}
