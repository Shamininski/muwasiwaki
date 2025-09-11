// lib/features/roles/domain/usecases/check_permission_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/roles_repository.dart';

class CheckPermissionUseCase implements UseCase<bool, CheckPermissionParams> {
  final RolesRepository repository;

  CheckPermissionUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckPermissionParams params) async {
    return await repository.checkPermission(params.userId, params.permission);
  }
}

class CheckPermissionParams {
  final String userId;
  final String permission;

  CheckPermissionParams({required this.userId, required this.permission});
}
