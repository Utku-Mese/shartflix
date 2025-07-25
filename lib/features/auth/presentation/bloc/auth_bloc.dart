import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../data/models/user_model.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/firebase_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@singleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final SecureStorageService _storageService;

  AuthBloc(
    this._loginUseCase,
    this._registerUseCase,
    this._storageService,
  ) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      final result = await _loginUseCase.call(event.email, event.password);

      if (!isClosed) {
        if (result.isOk) {
          final user = result.okOrNull!;

          // Store auth token if available in user model
          // await _storageService.write('auth_token', user.token);

          // Firebase Analytics - Login eventi
          await FirebaseService.logLogin('email');
          await FirebaseService.setUserProperties(
            userId: user.id,
            userType: 'regular',
          );

          if (!emit.isDone && !isClosed) {
            emit(AuthAuthenticated(user));
          }
        } else {
          final error = result.errOrNull!;

          // Firebase Crashlytics - Login hatası
          FirebaseService.recordError(
            exception: Exception('Login failed: $error'),
            reason: 'User login attempt failed',
          );

          if (!emit.isDone && !isClosed) {
            emit(AuthError(error));
          }
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(AuthError('Login failed: ${e.toString()}'));
      }
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      final result = await _registerUseCase.call(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );

      if (!isClosed) {
        if (result.isOk) {
          final user = result.okOrNull!;

          // Store auth token if available in user model
          // await _storageService.write('auth_token', user.token);

          // Firebase Analytics - Sign up eventi
          await FirebaseService.logSignUp('email');
          await FirebaseService.setUserProperties(
            userId: user.id,
            userType: 'regular',
          );

          if (!emit.isDone && !isClosed) {
            emit(AuthAuthenticated(user));
          }
        } else {
          final error = result.errOrNull!;

          // Firebase Crashlytics - Register hatası
          FirebaseService.recordError(
            exception: Exception('Registration failed: $error'),
            reason: 'User registration attempt failed',
          );

          if (!emit.isDone && !isClosed) {
            emit(AuthError(error));
          }
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(AuthError('Registration failed: ${e.toString()}'));
      }
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _storageService.clearAuthData();
      if (!isClosed) emit(AuthUnauthenticated());
    } catch (e) {
      if (!isClosed)
        emit(AuthUnauthenticated()); // Logout her durumda başarılı sayılsın
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    if (isClosed) return;

    try {
      // Check if token exists
      final hasToken = await _storageService.hasToken();

      if (hasToken) {
        // Try to get stored user data
        final userData = await _storageService.getUserData();

        if (userData != null) {
          try {
            final userJson = jsonDecode(userData) as Map<String, dynamic>;
            final userModel = UserModel.fromJson(userJson);
            final user = userModel.toEntity();

            if (!isClosed) emit(AuthAuthenticated(user));
          } catch (e) {
            await _storageService.clearAuthData();
            if (!isClosed) emit(AuthUnauthenticated());
          }
        } else {
          await _storageService.clearAuthData();
          if (!isClosed) emit(AuthUnauthenticated());
        }
      } else {
        if (!isClosed) emit(AuthUnauthenticated());
      }
    } catch (e) {
      await _storageService.clearAuthData();
      if (!isClosed) emit(AuthUnauthenticated());
    }
  }
}
