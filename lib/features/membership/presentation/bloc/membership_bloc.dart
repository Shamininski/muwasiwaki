// lib/features/membership/presentation/bloc/membership_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/membership_application.dart';
import '../../domain/entities/family_member.dart';
import '../../domain/usecases/apply_membership_usecase.dart';
import '../../domain/usecases/approve_membership_usecase.dart';
import '../../domain/usecases/get_applications_usecase.dart';

// Events
abstract class MembershipEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitApplicationEvent extends MembershipEvent {
  final String applicantName;
  final String email;
  final String phone;
  final String district;
  final String profession;
  final String reasonForJoining;
  final DateTime dateOfEntry;
  final List<FamilyMember> familyMembers;

  SubmitApplicationEvent({
    required this.applicantName,
    required this.email,
    required this.phone,
    required this.district,
    required this.profession,
    required this.reasonForJoining,
    required this.dateOfEntry,
    required this.familyMembers,
  });

  @override
  List<Object?> get props => [
        applicantName,
        email,
        phone,
        district,
        profession,
        reasonForJoining,
        dateOfEntry,
        familyMembers,
      ];
}

class LoadApplicationsEvent extends MembershipEvent {}

class RefreshApplicationsEvent extends MembershipEvent {}

class ApproveApplicationEvent extends MembershipEvent {
  final String applicationId;

  ApproveApplicationEvent(this.applicationId);

  @override
  List<Object?> get props => [applicationId];
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
    on<LoadApplicationsEvent>(_onLoadApplications);
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
      district: event.district,
      profession: event.profession,
      reasonForJoining: event.reasonForJoining,
      dateOfEntry: event.dateOfEntry,
      familyMembers: event.familyMembers,
    ));

    result.fold(
      (failure) => emit(MembershipError(message: failure.message)),
      (_) => emit(MembershipApplicationSuccess()),
    );
  }

  Future<void> _onLoadApplications(
    LoadApplicationsEvent event,
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
      approved: true,
    ));

    result.fold(
      (failure) => emit(MembershipError(message: failure.message)),
      (_) {
        emit(MembershipActionSuccess(
            message: 'Application approved successfully'));
        add(LoadApplicationsEvent()); // Refresh the list
      },
    );
  }

  Future<void> _onRejectApplication(
    RejectApplicationEvent event,
    Emitter<MembershipState> emit,
  ) async {
    final result = await approveMembershipUseCase(ApproveMembershipParams(
      applicationId: event.applicationId,
      approved: false,
    ));

    result.fold(
      (failure) => emit(MembershipError(message: failure.message)),
      (_) {
        emit(MembershipActionSuccess(message: 'Application rejected'));
        add(LoadApplicationsEvent()); // Refresh the list
      },
    );
  }
}
