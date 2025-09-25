// lib/features/roles/domain/usecases/revoke_role_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/roles_repository.dart';

class RevokeRoleUseCase implements UseCase<void, RevokeRoleParams> {

  RevokeRoleUseCase(this.repository);
  final RolesRepository repository;

  @override
  Future<Either<Failure, void>> call(RevokeRoleParams params) async {
    return await repository.revokeRole(
      userId: params.userId,
      roleId: params.roleId,
    );
  }
}

class RevokeRoleParams {

  RevokeRoleParams({required this.userId, required this.roleId});
  final String userId;
  final String roleId;
}
