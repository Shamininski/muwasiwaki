// lib/features/membership/presentation/bloc/membership_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/membership_application.dart';
import '../../domain/entities/family_member.dart';
import '../../domain/usecases/apply_membership_usecase.dart';
import '../../domain/usecases/approve_membership_usecase.dart';
import '../../domain/usecases/get_applications_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Events
abstract class MembershipEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitApplicationEvent extends MembershipEvent {
  final String applicantName;
  final String email;
  final String phone;
  final String subregion;
  final String profession;
  final String? nidaNumber;
  final DateTime dateOfEntry;
  final List<FamilyMember> familyMembers;

  SubmitApplicationEvent({
    required this.applicantName,
    required this.email,
    required this.phone,
    required this.subregion,
    required this.profession,
    this.nidaNumber,
    required this.dateOfEntry,
    required this.familyMembers,
  });

  @override
  List<Object?> get props => [
        applicantName,
        email,
        phone,
        subregion,
        profession,
        nidaNumber,
        dateOfEntry,
        familyMembers,
      ];
}

class LoadPendingApplicationsEvent extends MembershipEvent {}

class RefreshApplicationsEvent extends MembershipEvent {}

class ApproveApplicationEvent extends MembershipEvent {
  final String applicationId;
  final String reviewerId;

  ApproveApplicationEvent({
    required this.applicationId,
    required this.reviewerId,
  });

  @override
  List<Object?> get props => [applicationId, reviewerId];
}

class RejectApplicationEvent extends MembershipEvent {
  final String applicationId;

  RejectApplicationEvent(this.applicationId);

  @override
  List<Object?> get props => [applicationId];
}

// States
abstract class MembershipState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MembershipInitial extends MembershipState {}

class MembershipLoading extends MembershipState {}

class MembershipApplicationSuccess extends MembershipState {
  final String message;

  MembershipApplicationSuccess({
    this.message = 'Application submitted successfully',
  });

  @override
  List<Object?> get props => [message];
}

class ApplicationsLoaded extends MembershipState {
  final List<MembershipApplication> applications;

  ApplicationsLoaded({required this.applications});

  @override
  List<Object?> get props => [applications];
}

class MembershipActionSuccess extends MembershipState {
  final String message;

  MembershipActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class MembershipError extends MembershipState {
  final String message;

  MembershipError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class MembershipBloc extends Bloc<MembershipEvent, MembershipState> {
  final ApplyMembershipUseCase applyMembershipUseCase;
  final ApproveMembershipUseCase approveMembershipUseCase;
  final GetApplicationsUseCase getApplicationsUseCase;

  MembershipBloc({
    required this.applyMembershipUseCase,
    required this.approveMembershipUseCase,
    required this.getApplicationsUseCase,
  }) : super(MembershipInitial()) {
    on<SubmitApplicationEvent>(_onSubmitApplication);
    on<LoadPendingApplicationsEvent>(_onLoadPendingApplications);
    on<RefreshApplicationsEvent>(_onRefreshApplications);
    on<ApproveApplicationEvent>(_onApproveApplication);
    on<RejectApplicationEvent>(_onRejectApplication);
  }

  Future<void> _onSubmitApplication(
    SubmitApplicationEvent event,
    Emitter<MembershipState> emit,
  ) async {
    emit(MembershipLoading());

    final result = await applyMembershipUseCase(ApplyMembershipParams(
      applicantName: event.applicantName,
      email: event.email,
      phone: event.phone,
      subregion: event.subregion,
      profession: event.profession,
      nidaNumber: event.nidaNumber,
      dateOfEntry: event.dateOfEntry,
      familyMembers: event.familyMembers,
    ));

    result.fold(
      (failure) => emit(MembershipError(message: failure.message)),
      (_) => emit(MembershipApplicationSuccess()),
    );
  }

  Future<void> _onLoadPendingApplications(
    LoadPendingApplicationsEvent event,
    Emitter<MembershipState> emit,
  ) async {
    if (state is! ApplicationsLoaded) {
      emit(MembershipLoading());
    }

    final result = await getApplicationsUseCase();
    result.fold(
      (failure) => emit(MembershipError(message: failure.message)),
      (applications) => emit(ApplicationsLoaded(applications: applications)),
    );
  }

  Future<void> _onRefreshApplications(
    RefreshApplicationsEvent event,
    Emitter<MembershipState> emit,
  ) async {
    final result = await getApplicationsUseCase();
    result.fold(
      (failure) => emit(MembershipError(message: failure.message)),
      (applications) => emit(ApplicationsLoaded(applications: applications)),
    );
  }

  Future<void> _onApproveApplication(
    ApproveApplicationEvent event,
    Emitter<MembershipState> emit,
  ) async {
    final result = await approveMembershipUseCase(ApproveMembershipParams(
      applicationId: event.applicationId,
      reviewerId: event.reviewerId,
    ));

    result.fold(
      (failure) => emit(MembershipError(message: failure.message)),
      (_) {
        emit(MembershipActionSuccess(
            message: 'Application approved successfully'));
        add(LoadPendingApplicationsEvent()); // Refresh the list
      },
    );
  }

// The following code snippet was added on 17 Dec 2025 with help from CoPilot to remove the reviewerId from the RejectApplicationEvent
  Future<void> _onRejectApplication(
    RejectApplicationEvent event,
    Emitter<MembershipState> emit,
  ) async {
    final reviewerId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final result = await approveMembershipUseCase(ApproveMembershipParams(
      applicationId: event.applicationId,
      reviewerId: reviewerId, // provide reviewerId for rejection
    ));

    result.fold(
      (failure) => emit(MembershipError(message: failure.message)),
      (_) {
        emit(MembershipActionSuccess(message: 'Application rejected'));
        add(LoadPendingApplicationsEvent()); // Refresh the list
      },
    );
  }
}
