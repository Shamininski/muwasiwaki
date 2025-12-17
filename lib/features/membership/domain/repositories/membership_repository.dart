// lib/features/membership/domain/repositories/membership_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/family_member.dart';
import '../entities/membership_application.dart';

abstract class MembershipRepository {
  Future<Either<Failure, void>> applyForMembership({
    required String applicantName,
    required String email,
    required String phone,
    required String subregion,
    required String profession,
    required DateTime dateOfEntry,
    required List<FamilyMember> familyMembers,
  });

  Future<Either<Failure, List<MembershipApplication>>> getPendingApplications();

  Future<Either<Failure, void>> approveMembership(
      String applicationId, String reviewerId);

  Future<Either<Failure, void>> rejectMembership(
      String applicationId, String reviewerId);

  // &&&&&&&&&&&&&&&& Commented out on 17th Dec 2025 while rectifying 7 subregions &&&&&&&&&&&&&&

  // Future<Either<Failure, List<MembershipApplication>>> getApplications();

  // Future<Either<Failure, void>> approveMembership({
  //   required String applicationId,
  //   required bool approved,
  // });

  // Future<Either<Failure, MembershipApplication?>> getApplicationById(String id);
}
