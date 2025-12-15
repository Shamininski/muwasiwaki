// lib/features/membership/domain/usecases/apply_membership_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/family_member.dart';
import '../repositories/membership_repository.dart';

class ApplyMembershipUseCase implements UseCase<void, ApplyMembershipParams> {
  final MembershipRepository repository;

  ApplyMembershipUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ApplyMembershipParams params) async {
    return await repository.applyForMembership(
      applicantName: params.applicantName,
      email: params.email,
      phone: params.phone,
      district: params.district,
      profession: params.profession,
      dateOfEntry: params.dateOfEntry,
      familyMembers: params.familyMembers,
    );
  }
}

class ApplyMembershipParams {
  final String applicantName;
  final String email;
  final String phone;
  final String district;
  final String profession;
  final DateTime dateOfEntry;
  final List<FamilyMember> familyMembers;

  ApplyMembershipParams({
    required this.applicantName,
    required this.email,
    required this.phone,
    required this.district,
    required this.profession,
    required this.dateOfEntry,
    required this.familyMembers,
  });
}
