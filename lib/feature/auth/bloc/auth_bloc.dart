import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../repository/auth_repository.dart';

// Events
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  LoginRequested(this.email);
}

class VerifyOtpRequested extends AuthEvent {
  final String email;
  final int code;
  VerifyOtpRequested(this.email, this.code);
}

class LogoutRequested extends AuthEvent {}

// States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final dynamic data;
  AuthSuccess(this.data);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class LogoutSuccess extends AuthState {}

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.login(event.email);
      emit(AuthSuccess(response));
    } catch (e) {
      // Extract the message from the exception
      final errorMessage =
          e.toString().contains('Exception: ')
              ? e.toString().split('Exception: ')[1]
              : e.toString();
      emit(AuthError(errorMessage));
    }
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.verifyOtp(event.email, event.code);
      emit(AuthSuccess(response));
    } catch (e) {
      // Extract the message from the exception
      final errorMessage =
          e.toString().contains('Exception: ')
              ? e.toString().split('Exception: ')[1]
              : e.toString();
      emit(AuthError(errorMessage));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      emit(LogoutSuccess());
    } catch (e) {
      final errorMessage =
          e.toString().contains('Exception: ')
              ? e.toString().split('Exception: ')[1]
              : e.toString();
      emit(AuthError(errorMessage));
    }
  }
}
