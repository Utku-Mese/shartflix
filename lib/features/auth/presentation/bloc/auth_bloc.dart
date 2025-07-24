import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../../../core/services/secure_storage_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
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
    emit(AuthLoading());

    final result = await _loginUseCase.call(event.email, event.password);

    result.fold(
      (user) async {
        // Store auth token if available in user model
        // await _storageService.write('auth_token', user.token);
        emit(AuthAuthenticated(user));
      },
      (error) => emit(AuthError(error)),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _registerUseCase.call(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      password: event.password,
      confirmPassword: event.confirmPassword,
    );

    result.fold(
      (user) async {
        // Store auth token if available in user model
        // await _storageService.write('auth_token', user.token);
        emit(AuthAuthenticated(user));
      },
      (error) => emit(AuthError(error)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _storageService.delete('auth_token');
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final token = await _storageService.read('auth_token');
    if (token != null) {
      // TODO: Validate token and get user info
      // For now, just emit unauthenticated
      emit(AuthUnauthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
