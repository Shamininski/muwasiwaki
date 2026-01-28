// lib/features/auth/presentation/bloc/auth_bloc.dart
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muwasiwaki/core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => <Object?>[];
}

class CheckAuthEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  LoginEvent({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object?> get props => <Object?>[email, password];
}

class RegisterEvent extends AuthEvent {
  RegisterEvent({
    required this.email,
    required this.password,
    required this.name,
  });
  final String email;
  final String password;
  final String name;

  @override
  List<Object?> get props => <Object?>[email, password, name];
}

class LogoutEvent extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => <Object?>[];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  AuthAuthenticated({required this.user});
  final AppUser user;

  @override
  List<Object?> get props => <Object?>[user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  AuthError({required this.message});
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<CheckAuthEvent>(_onCheckAuth);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
  }
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  void _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    try {
      final Either<Failure, AppUser> result = await loginUseCase
          .getCurrentUser()
          .timeout(const Duration(seconds: 5));
      result.fold(
        (Failure failure) => emit(AuthUnauthenticated()),
        (AppUser user) => emit(AuthAuthenticated(user: user)),
      );
    } catch (e) {
      debugPrint('Check auth timeout: $e');
      emit(AuthUnauthenticated());
    }
  }

  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final Either<Failure, AppUser> result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (Failure failure) => emit(AuthError(message: failure.message)),
      (AppUser user) => emit(AuthAuthenticated(user: user)),
    );
  }

  void _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await registerUseCase(RegisterParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ));

      result.fold(
        (failure) {
          debugPrint('Registration failure: ${failure.message}');
          emit(AuthError(message: failure.message));
        },
        (user) {
          debugPrint('Registration success: ${user.email}');
          emit(AuthAuthenticated(user: user));
        },
      );
    } catch (e) {
      debugPrint('Registration exception: $e');
      emit(AuthError(message: 'Registration failed: $e'));
    }
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await logoutUseCase();
    emit(AuthUnauthenticated());
  }
}
