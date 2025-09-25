// lib/features/roles/domain/usecases/get_user_roles_usecase.dart (Updated with documentation)
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_role.dart';
import '../repositories/roles_repository.dart';

/// Use case for retrieving all user roles from the repository.
///
/// This use case encapsulates the business logic for fetching user roles
/// and implements the [UseCaseNoParams] interface since no parameters
/// are required for this operation.
///
/// Returns a list of [UserRoleEntity] objects wrapped in an [Either]
/// containing either a [Failure] on error or the list of roles on success.
///
/// Example usage:
/// ```dart
/// final getUserRolesUseCase = GetUserRolesUseCase(rolesRepository);
/// final result = await getUserRolesUseCase();
/// result.fold(
///   (failure) => handleError(failure.message),
///   (roles) => displayRoles(roles),
/// );
/// ```
class GetUserRolesUseCase implements UseCaseNoParams<List<UserRoleEntity>> {
  /// The roles repository instance used to fetch role data.
  final RolesRepository repository;

  /// Creates a new instance of [GetUserRolesUseCase].
  ///
  /// Requires a [RolesRepository] instance to perform data operations.
  GetUserRolesUseCase(this.repository);

  /// Executes the use case to retrieve all user roles.
  ///
  /// This method delegates the role fetching operation to the repository
  /// and returns the result wrapped in an [Either] type for error handling.
  ///
  /// Returns:
  /// - [Left<Failure>] if the operation fails
  /// - [Right<List<UserRoleEntity>>] if the operation succeeds
  @override
  Future<Either<Failure, List<UserRoleEntity>>> call() async {
    return await repository.getUserRoles();
  }
}
