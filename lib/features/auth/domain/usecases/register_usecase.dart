// lib/features/auth/domain/usecases/register_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<AppUser, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(RegisterParams params) async {
    return await repository.register(
        params.email, params.password, params.name);
  }
}

class RegisterParams {
  final String email;
  final String password;
  final String name;

  RegisterParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
