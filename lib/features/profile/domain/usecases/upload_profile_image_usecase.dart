// lib/features/profile/domain/usecases/upload_profile_image_usecase.dart
import 'package:dartz/dartz.dart';
import 'dart:io';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class UploadProfileImageUseCase
    implements UseCase<String, UploadProfileImageParams> {
  final ProfileRepository repository;

  UploadProfileImageUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadProfileImageParams params) async {
    return await repository.uploadProfileImage(params.userId, params.image);
  }
}

class UploadProfileImageParams {
  final String userId;
  final File image;

  UploadProfileImageParams({required this.userId, required this.image});
}
