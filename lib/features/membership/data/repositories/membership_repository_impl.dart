// lib/features/membership/data/repositories/membership_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/membership_application.dart';
import '../../domain/entities/family_member.dart';
import '../../domain/repositories/membership_repository.dart';
import '../datasources/membership_remote_datasource.dart';

class MembershipRepositoryImpl implements MembershipRepository {
  final MembershipRemoteDataSource remoteDataSource;

  MembershipRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, MembershipApplication>> applyForMembership({
    required String applicantName,
    required String email,
    required String phone,
    required String subregion,
    required String profession,
    required DateTime dateOfEntry,
    required List<FamilyMember> familyMembers,
  }) async {
    try {
      final application = await remoteDataSource.applyForMembership(
        applicantName: applicantName,
        email: email,
        phone: phone,
        subregion: subregion,
        profession: profession,
        dateOfEntry: dateOfEntry,
        familyMembers: familyMembers,
      );
      return Right(application.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MembershipApplication>>>
      getPendingApplications() async {
    try {
      final applications = await remoteDataSource.getPendingApplications();
      return Right(applications.map((app) => app.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> approveMembership(
      String applicationId, String reviewerId) async {
    try {
      await remoteDataSource.approveMembership(applicationId, reviewerId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rejectMembership(
      String applicationId, String reviewerId) async {
    try {
      await remoteDataSource.rejectMembership(applicationId, reviewerId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../../domain/entities/membership_application.dart';
// import '../../domain/entities/family_member.dart';
// import '../../domain/repositories/membership_repository.dart';
// import '../datasources/membership_remote_datasource.dart';

// class MembershipRepositoryImpl implements MembershipRepository {
//   final MembershipRemoteDataSource remoteDataSource;

//   MembershipRepositoryImpl(this.remoteDataSource);

//   @override
//   Future<Either<Failure, void>> applyForMembership({
//     required String applicantName,
//     required String email,
//     required String phone,
//     required String subregion,
//     required String profession,
//     required DateTime dateOfEntry,
//     required List<FamilyMember> familyMembers,
//   }) async {
//     try {
//       await remoteDataSource.applyForMembership(
//         applicantName: applicantName,
//         email: email,
//         phone: phone,
//         subregion: subregion,
//         profession: profession,
//         dateOfEntry: dateOfEntry,
//         familyMembers: familyMembers,
//       );
//       return const Right(null);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, List<MembershipApplication>>> getApplications() async {
//     try {
//       final applicationModels = await remoteDataSource.getApplications();
//       final applications =
//           applicationModels.map((model) => model.toEntity()).toList();
//       return Right(applications);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> approveMembership({
//     required String applicationId,
//     required bool approved,
//   }) async {
//     try {
//       await remoteDataSource.approveMembership(
//         applicationId: applicationId,
//         approved: approved,
//       );
//       return const Right(null);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, MembershipApplication?>> getApplicationById(
//       String id) async {
//     try {
//       final applicationModel = await remoteDataSource.getApplicationById(id);
//       return Right(applicationModel?.toEntity());
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
// }
