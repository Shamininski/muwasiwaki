// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> login(String email, String password);
  Future<Either<Failure, AppUser>> register(
      String email, String password, String name);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AppUser>> getCurrentUser();
}
