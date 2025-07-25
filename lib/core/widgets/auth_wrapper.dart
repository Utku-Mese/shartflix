import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/splash/splash.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import 'main_layout.dart';
import '../di/injection.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _showSplash = true;

  void _onSplashComplete() {
    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>()..add(CheckAuthStatus()),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Always show splash first
          if (_showSplash) {
            return SplashPage(onComplete: _onSplashComplete);
          }

          // After splash, determine which page to show
          if (state is AuthAuthenticated) {
            return const MainLayout();
          } else if (state is AuthUnauthenticated) {
            return const LoginPage();
          } else if (state is AuthLoading) {
            return const LoginPage(); // Show login while loading
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
