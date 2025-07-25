import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../shared/shared.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              // AuthAuthenticated durumunda MainLayout'a yönlendirme AuthWrapper tarafından otomatik olarak yapılıyor
            },
            builder: (context, state) {
              final l10n = AppLocalizations.of(context);

              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 2),

                    // Header
                    AuthHeader(
                      title: l10n?.hello ?? 'Merhabalar',
                      subtitle: l10n?.subtitle ??
                          'Tempus varius a vitae interdum id\ntortor elementum tristique eleifend at.',
                    ),

                    const SizedBox(height: 48),

                    // Email Field
                    CustomTextField(
                      controller: _emailController,
                      hintText: l10n?.email ?? 'E-mail',
                      prefixIcon: SvgPicture.asset(
                        'assets/icons/mail.svg',
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.onSurface,
                          BlendMode.srcIn,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return l10n?.emailValidationError ??
                              'Please enter a valid email address';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value!)) {
                          return l10n?.emailValidationError ??
                              'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Password Field
                    CustomTextField(
                      controller: _passwordController,
                      hintText: l10n?.password ?? 'Password',
                      prefixIcon: SvgPicture.asset(
                        'assets/icons/password.svg',
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.onSurface,
                          BlendMode.srcIn,
                        ),
                      ),
                      isPassword: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return l10n?.passwordValidationError ??
                              'Password must be at least 6 characters';
                        }
                        if (value!.length < 6) {
                          return l10n?.passwordValidationError ??
                              'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement forgot password
                        },
                        child: Text(
                          l10n?.forgotPassword ?? 'Forgot Password',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Login Button
                    PrimaryButton(
                      text: l10n?.login ?? 'Login',
                      onPressed: () => _onLoginPressed(context),
                      isLoading: state is AuthLoading,
                    ),

                    const SizedBox(height: 48),

                    // Social Login Buttons
                    SocialLoginRow(
                      onGooglePressed: () {
                        // TODO: Google Login
                      },
                      onApplePressed: () {
                        // TODO: Apple Login
                      },
                      onFacebookPressed: () {
                        // TODO: Facebook Login
                      },
                    ),

                    const SizedBox(height: 32),

                    // Register Link
                    AuthNavigationLink(
                      text: l10n?.dontHaveAccount ?? 'Don\'t have an account? ',
                      linkText: l10n?.registerTextButton ?? 'Register',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      if (mounted) {
        context.read<AuthBloc>().add(
              LoginRequested(
                email: _emailController.text.trim(),
                password: _passwordController.text,
              ),
            );
      }
    }
  }
}
