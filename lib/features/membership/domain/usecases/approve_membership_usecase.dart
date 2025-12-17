// lib/features/membership/domain/usecases/approve_membership_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/membership_repository.dart';

class ApproveMembershipUseCase
    implements UseCase<void, ApproveMembershipParams> {
  final MembershipRepository repository;

  ApproveMembershipUseCase(this.repository);

// &&&&&&&&&&&&&&&&&&&&&&&&&&&  Added on 17 Dec 2025 &&&&&&&&&&&&&&&&&&&&&&&&&
  @override
  Future<Either<Failure, void>> call(ApproveMembershipParams params) async {
    return await repository.approveMembership(
        params.applicationId, params.reviewerId);
  }
}

// &&&&&&&&&&&&&&&&&&&&& CommentedOut on 17 DEC 2025 - 7subRegions &&&&&&&&&&&&&&&&&&&&
//   @override
//   Future<Either<Failure, void>> call(ApproveMembershipParams params) async {
//     return await repository.approveMembership(
//       applicationId: params.applicationId,
//       approved: params.approved,
//     );
//   }
// }

class ApproveMembershipParams {
  final String applicationId;
  final String reviewerId;

  ApproveMembershipParams({
    required this.applicationId,
    required this.reviewerId,
  });
}
