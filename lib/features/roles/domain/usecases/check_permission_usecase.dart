// lib/features/roles/domain/usecases/check_permission_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/roles_repository.dart';

class CheckPermissionUseCase implements UseCase<bool, CheckPermissionParams> {

  CheckPermissionUseCase(this.repository);
  final RolesRepository repository;

  @override
  Future<Either<Failure, bool>> call(CheckPermissionParams params) async {
    return await repository.checkPermission(params.userId, params.permission);
  }
}

class CheckPermissionParams {

  CheckPermissionParams({required this.userId, required this.permission});
  final String userId;
  final String permission;
}
