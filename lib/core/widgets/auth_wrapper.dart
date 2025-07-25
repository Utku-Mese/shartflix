import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/splash/splash.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import 'main_layout.dart';
import '../di/injection.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>()..add(CheckAuthStatus()),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial) {
            return const SplashPage();
          } else if (state is AuthAuthenticated) {
            return const MainLayout();
          } else if (state is AuthUnauthenticated) {
            return const LoginPage();
          } else if (state is AuthLoading) {
            return const SplashPage();
          } else if (state is AuthError) {
            return const LoginPage();
          }

          // Default fallback
          return const LoginPage();
        },
      ),
    );
  }
}
