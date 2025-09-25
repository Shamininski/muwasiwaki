// lib/features/profile/presentation/bloc/profile_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../../domain/usecases/upload_profile_image_usecase.dart';

// Events
abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserProfileEvent extends ProfileEvent {
  final String userId;

  LoadUserProfileEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UpdateUserProfileEvent extends ProfileEvent {
  final UserProfile profile;

  UpdateUserProfileEvent({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class UploadProfileImageEvent extends ProfileEvent {
  final String userId;
  final File image;

  UploadProfileImageEvent({required this.userId, required this.image});

  @override
  List<Object?> get props => [userId, image];
}

class RefreshProfileEvent extends ProfileEvent {
  final String userId;

  RefreshProfileEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

// States
abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  ProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdated extends ProfileState {
  final UserProfile profile;
  final String message;

  ProfileUpdated({
    required this.profile,
    this.message = 'Profile updated successfully',
  });

  @override
  List<Object?> get props => [profile, message];
}

class ProfileImageUploaded extends ProfileState {
  final String imageUrl;
  final String message;

  ProfileImageUploaded({
    required this.imageUrl,
    this.message = 'Profile image uploaded successfully',
  });

  @override
  List<Object?> get props => [imageUrl, message];
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final UploadProfileImageUseCase uploadProfileImageUseCase;

  ProfileBloc({
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
    required this.uploadProfileImageUseCase,
  }) : super(ProfileInitial()) {
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<UploadProfileImageEvent>(_onUploadProfileImage);
    on<RefreshProfileEvent>(_onRefreshProfile);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! ProfileLoaded) {
      emit(ProfileLoading());
    }

    final result = await getUserProfileUseCase(
      GetUserProfileParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await updateUserProfileUseCase(
      UpdateUserProfileParams(profile: event.profile),
    );

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (profile) => emit(ProfileUpdated(profile: profile)),
    );
  }

  Future<void> _onUploadProfileImage(
    UploadProfileImageEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await uploadProfileImageUseCase(
      UploadProfileImageParams(userId: event.userId, image: event.image),
    );

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (imageUrl) {
        emit(ProfileImageUploaded(imageUrl: imageUrl));
        // Reload profile to get updated data
        add(LoadUserProfileEvent(userId: event.userId));
      },
    );
  }

  Future<void> _onRefreshProfile(
    RefreshProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await getUserProfileUseCase(
      GetUserProfileParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }
}
