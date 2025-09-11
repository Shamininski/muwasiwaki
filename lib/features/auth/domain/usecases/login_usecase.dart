// lib/features/auth/domain/usecases/login_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<AppUser, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }

  Future<Either<Failure, AppUser>> getCurrentUser() async {
    return await repository.getCurrentUser();
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
