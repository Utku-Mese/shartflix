import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/shared.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final l10n = AppLocalizations.of(context)!;

                    return Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header
                            AuthHeader(
                              title: l10n.welcome,
                              subtitle: l10n.subtitle,
                            ),

                            const SizedBox(height: 48),

                            // First Name Field
                            CustomTextField(
                              controller: _firstNameController,
                              hintText: l10n.fullName,
                              prefixIcon: SvgPicture.asset(
                                'assets/icons/person.svg',
                                color: AppColors.white,
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return l10n.fullNameRequired;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Email Field
                            CustomTextField(
                              controller: _emailController,
                              hintText: l10n.emailAddress,
                              prefixIcon: SvgPicture.asset(
                                'assets/icons/mail.svg',
                                color: AppColors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return l10n.emailRequired;
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value!)) {
                                  return l10n.emailInvalid;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Password Field
                            CustomTextField(
                              controller: _passwordController,
                              hintText: l10n.password,
                              prefixIcon: SvgPicture.asset(
                                'assets/icons/password.svg',
                                color: AppColors.white,
                              ),
                              isPassword: true,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return l10n.passwordValidationError;
                                }
                                if (value!.length < 6) {
                                  return l10n.passwordValidationError;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Confirm Password Field
                            CustomTextField(
                              controller: _confirmPasswordController,
                              hintText: l10n.confirmPassword,
                              prefixIcon: SvgPicture.asset(
                                'assets/icons/password.svg',
                                color: AppColors.white,
                              ),
                              isPassword: true,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return l10n.passwordsDoNotMatch;
                                }
                                if (value != _passwordController.text) {
                                  return l10n.passwordsDoNotMatch;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Terms
                            Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                  children: [
                                    WidgetSpan(
                                      child: InkWell(
                                        onTap: () {
                                          // TODO: Open terms and conditions
                                        },
                                        child: Text(
                                          'Kullanıcı sözleşmesini',
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 12,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: AppColors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const TextSpan(
                                        text:
                                            ' okudum ve kabul ediyorum. Bu\nsözleşmeyi okuyarak devam ediniz lütfen.'),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Register Button
                            PrimaryButton(
                              text: l10n.register,
                              onPressed: state is AuthLoading
                                  ? null
                                  : () => _onRegisterPressed(context),
                              isLoading: state is AuthLoading,
                            ),

                            const SizedBox(height: 36),

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

                            const SizedBox(height: 18),

                            // Login Link
                            AuthNavigationLink(
                              text: l10n.alreadyHaveAccount,
                              linkText: l10n.login,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onRegisterPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final fullName = _firstNameController.text.trim();
      final nameParts = fullName.split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : '';

      context.read<AuthBloc>().add(
            RegisterRequested(
              firstName: firstName,
              lastName: lastName,
              email: _emailController.text.trim(),
              password: _passwordController.text,
              confirmPassword: _confirmPasswordController.text,
            ),
          );
    }
  }
}
