// lib/features/roles/domain/repositories/roles_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_role.dart';
import '../repositories/roles_repository.dart';

class GetUserRolesUseCase implements UseCaseNoParams<List<UserRoleEntity>> {
  final RolesRepository repository;

  GetUserRolesUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserRoleEntity>>> call() async {
    return await repository.getUserRoles();
  }
}
