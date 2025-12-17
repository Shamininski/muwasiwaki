// lib/core/injection/injection_container.dart (Updated)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Auth Feature
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
// Membership Feature
import '../../features/membership/data/datasources/membership_remote_datasource.dart';
import '../../features/membership/data/repositories/membership_repository_impl.dart';
import '../../features/membership/domain/repositories/membership_repository.dart';
import '../../features/membership/domain/usecases/apply_membership_usecase.dart';
import '../../features/membership/domain/usecases/approve_membership_usecase.dart';
import '../../features/membership/domain/usecases/get_applications_usecase.dart';
import '../../features/membership/presentation/bloc/membership_bloc.dart';
// News Feature
import '../../features/news/data/datasources/news_remote_datasource.dart';
import '../../features/news/data/repositories/news_repository_impl.dart';
import '../../features/news/domain/repositories/news_repository.dart';
import '../../features/news/domain/usecases/create_news_usecase.dart';
import '../../features/news/domain/usecases/get_news_usecase.dart';
import '../../features/news/presentation/bloc/news_bloc.dart';
// Profile Feature
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_user_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_user_profile_usecase.dart';
import '../../features/profile/domain/usecases/upload_profile_image_usecase.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
// Roles Feature
import '../../features/roles/data/datasources/roles_remote_datasource.dart';
import '../../features/roles/data/repositories/roles_repository_impl.dart';
import '../../features/roles/domain/repositories/roles_repository.dart';
import '../../features/roles/domain/usecases/assign_role_usecase.dart';
import '../../features/roles/domain/usecases/check_permission_usecase.dart';
import '../../features/roles/domain/usecases/get_user_roles_usecase.dart';
import '../../features/roles/domain/usecases/revoke_role_usecase.dart';
import '../../features/roles/presentation/bloc/roles_bloc.dart';
// Core Services
import '../services/local_storage_service.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // External Dependencies
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);

  // Core Services
  sl.registerLazySingleton<LocalStorageService>(
    () => LocalStorageServiceImpl(sl()),
  );

  // Auth Feature
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        logoutUseCase: sl(),
      ));

  // News Feature
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetNewsUseCase(sl()));
  sl.registerLazySingleton(() => CreateNewsUseCase(sl()));
  sl.registerFactory(() => NewsBloc(
        getNewsUseCase: sl(),
        createNewsUseCase: sl(),
      ));

  // Membership Feature
  sl.registerLazySingleton<MembershipRemoteDataSource>(
    () => MembershipRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<MembershipRepository>(
    () => MembershipRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => ApplyMembershipUseCase(sl()));
  sl.registerLazySingleton(() => ApproveMembershipUseCase(sl()));
  sl.registerLazySingleton(() => GetApplicationsUseCase(sl()));
  sl.registerFactory(() => MembershipBloc(
        applyMembershipUseCase: sl(),
        approveMembershipUseCase: sl(),
        getApplicationsUseCase: sl(),
      ));

  // Profile Feature
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => UploadProfileImageUseCase(sl()));
  sl.registerFactory(() => ProfileBloc(
        getUserProfileUseCase: sl(),
        updateUserProfileUseCase: sl(),
        uploadProfileImageUseCase: sl(),
      ));

  // Roles Feature
  sl.registerLazySingleton<RolesRemoteDataSource>(
    () => RolesRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<RolesRepository>(
    () => RolesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetUserRolesUseCase(sl()));
  sl.registerLazySingleton(() => CheckPermissionUseCase(sl()));
  sl.registerLazySingleton(() => AssignRoleUseCase(sl()));
  sl.registerLazySingleton(() => RevokeRoleUseCase(sl()));
  sl.registerFactory(() => RolesBloc(
        getUserRolesUseCase: sl(),
        checkPermissionUseCase: sl(),
        assignRoleUseCase: sl(),
        revokeRoleUseCase: sl(),
      ));
}
