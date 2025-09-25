// lib/features/profile/domain/usecases/get_user_profile_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class GetUserProfileUseCase
    implements UseCase<UserProfile, GetUserProfileParams> {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(GetUserProfileParams params) async {
    return await repository.getUserProfile(params.userId);
  }
}

class GetUserProfileParams {
  final String userId;

  GetUserProfileParams({required this.userId});
}
