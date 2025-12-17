// lib/features/membership/domain/usecases/get_applications_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/membership_application.dart';
import '../repositories/membership_repository.dart';

class GetApplicationsUseCase
    implements UseCaseNoParams<List<MembershipApplication>> {
  final MembershipRepository repository;

  GetApplicationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<MembershipApplication>>> call() async {
    return await repository.getPendingApplications();
  }
}
