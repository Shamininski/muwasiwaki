// lib/features/membership/domain/usecases/approve_membership_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/membership_repository.dart';

class ApproveMembershipUseCase
    implements UseCase<void, ApproveMembershipParams> {
  final MembershipRepository repository;

  ApproveMembershipUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ApproveMembershipParams params) async {
    return await repository.approveMembership(
      applicationId: params.applicationId,
      approved: params.approved,
    );
  }
}

class ApproveMembershipParams {
  final String applicationId;
  final bool approved;

  ApproveMembershipParams({
    required this.applicationId,
    required this.approved,
  });
}
