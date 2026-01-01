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
      subregion: params.subregion,
      profession: params.profession,
      nidaNumber: params.nidaNumber,
      dateOfEntry: params.dateOfEntry,
      familyMembers: params.familyMembers,
    );
  }
}

class ApplyMembershipParams {
  final String applicantName;
  final String email;
  final String phone;
  final String subregion;
  final String profession;
  final String? nidaNumber;
  final DateTime dateOfEntry;
  final List<FamilyMember> familyMembers;

  ApplyMembershipParams({
    required this.applicantName,
    required this.email,
    required this.phone,
    required this.subregion,
    required this.profession,
    this.nidaNumber,
    required this.dateOfEntry,
    required this.familyMembers,
  });
}
