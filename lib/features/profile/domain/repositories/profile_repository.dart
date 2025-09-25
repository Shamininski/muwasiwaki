// lib/features/profile/domain/repositories/profile_repository.dart
import 'package:dartz/dartz.dart';
import 'dart:io';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> getUserProfile(String userId);
  Future<Either<Failure, UserProfile>> updateUserProfile(UserProfile profile);
  Future<Either<Failure, String>> uploadProfileImage(String userId, File image);
  Future<Either<Failure, void>> deleteProfileImage(String userId);
}
