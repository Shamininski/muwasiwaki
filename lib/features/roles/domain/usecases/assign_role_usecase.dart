// lib/features/roles/domain/usecases/assign_role_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/roles_repository.dart';

class AssignRoleUseCase implements UseCase<void, AssignRoleParams> {

  AssignRoleUseCase(this.repository);
  final RolesRepository repository;

  @override
  Future<Either<Failure, void>> call(AssignRoleParams params) async {
    return await repository.assignRole(
      userId: params.userId,
      roleId: params.roleId,
      expiresAt: params.expiresAt,
    );
  }
}

class AssignRoleParams {

  AssignRoleParams({
    required this.userId,
    required this.roleId,
    this.expiresAt,
  });
  final String userId;
  final String roleId;
  final DateTime? expiresAt;
}
