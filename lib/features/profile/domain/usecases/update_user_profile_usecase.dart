// lib/features/profile/domain/usecases/update_user_profile_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfileUseCase
    implements UseCase<UserProfile, UpdateUserProfileParams> {
  final ProfileRepository repository;

  UpdateUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(
      UpdateUserProfileParams params) async {
    return await repository.updateUserProfile(params.profile);
  }
}

class UpdateUserProfileParams {
  final UserProfile profile;

  UpdateUserProfileParams({required this.profile});
}
