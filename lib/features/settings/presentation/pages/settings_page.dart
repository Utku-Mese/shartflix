import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/bloc/app_settings_bloc.dart';
import '../../../../core/bloc/app_settings_event.dart';
import '../../../../core/bloc/app_settings_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _appVersion = '';
  bool _isDarkTheme = true; // Default to dark theme
  String _selectedLanguage = 'tr'; // Default to Turkish

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
    _loadSettings();
  }

  Future<void> _loadAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  Future<void> _loadSettings() async {
    // Settings BLoC'tan otomatik gelecek
  }

  Future<void> _saveTheme(bool isDark) async {
    final appSettingsBloc = context.read<AppSettingsBloc>();
    appSettingsBloc.add(ChangeTheme(isDark));

    setState(() {
      _isDarkTheme = isDark;
    });
  }

  Future<void> _saveLanguage(String language) async {
    final appSettingsBloc = context.read<AppSettingsBloc>();
    appSettingsBloc.add(ChangeLanguage(language));

    setState(() {
      _selectedLanguage = language;
    });
  }

  Future<void> _logout() async {
    final l10n = AppLocalizations.of(context)!;
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          l10n.logoutConfirmTitle,
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          l10n.logoutConfirmMessage,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.logout,
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // AuthBloc üzerinden logout işlemini gerçekleştir
      final authBloc = getIt<AuthBloc>();
      authBloc.add(LogoutRequested());

      if (mounted) {
        // AuthWrapper otomatik olarak LoginPage'e yönlendirecek
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, state) {
        // Update local state based on BLoC state
        if (state is AppSettingsLoaded) {
          _isDarkTheme = state.themeMode.name == 'dark';
          _selectedLanguage = state.locale.languageCode;
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(l10n.settings),
            centerTitle: true,
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textPrimary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Theme Section
              _buildSectionHeader(l10n.appearance),
              _buildThemeCard(l10n),

              const SizedBox(height: 24),

              // Language Section
              _buildSectionHeader(l10n.language),
              _buildLanguageCard(l10n),

              const SizedBox(height: 24),

              // App Info Section
              _buildSectionHeader(l10n.applicationInfo),
              _buildAppInfoCard(l10n),

              const SizedBox(height: 24),

              // Account Section
              _buildSectionHeader(l10n.account),
              _buildLogoutCard(l10n),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildThemeCard(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.light_mode,
              color: AppColors.textPrimary,
            ),
            title: Text(
              l10n.lightTheme,
              style: TextStyle(color: AppColors.textPrimary),
            ),
            trailing: Radio<bool>(
              value: false,
              groupValue: _isDarkTheme,
              onChanged: (value) => _saveTheme(value!),
              activeColor: AppColors.primary,
            ),
            onTap: () => _saveTheme(false),
          ),
          Divider(
            color: AppColors.borderColor,
            height: 1,
            indent: 56,
          ),
          ListTile(
            leading: Icon(
              Icons.dark_mode,
              color: AppColors.textPrimary,
            ),
            title: Text(
              l10n.darkTheme,
              style: TextStyle(color: AppColors.textPrimary),
            ),
            trailing: Radio<bool>(
              value: true,
              groupValue: _isDarkTheme,
              onChanged: (value) => _saveTheme(value!),
              activeColor: AppColors.primary,
            ),
            onTap: () => _saveTheme(true),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Text(
              '🇹🇷',
              style: TextStyle(fontSize: 24),
            ),
            title: Text(
              l10n.turkish,
              style: TextStyle(color: AppColors.textPrimary),
            ),
            trailing: Radio<String>(
              value: 'tr',
              groupValue: _selectedLanguage,
              onChanged: (value) => _saveLanguage(value!),
              activeColor: AppColors.primary,
            ),
            onTap: () => _saveLanguage('tr'),
          ),
          Divider(
            color: AppColors.borderColor,
            height: 1,
            indent: 56,
          ),
          ListTile(
            leading: const Text(
              '🇺🇸',
              style: TextStyle(fontSize: 24),
            ),
            title: Text(
              l10n.english,
              style: TextStyle(color: AppColors.textPrimary),
            ),
            trailing: Radio<String>(
              value: 'en',
              groupValue: _selectedLanguage,
              onChanged: (value) => _saveLanguage(value!),
              activeColor: AppColors.primary,
            ),
            onTap: () => _saveLanguage('en'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoCard(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: AppColors.textPrimary,
            ),
            title: Text(
              l10n.version,
              style: TextStyle(color: AppColors.textPrimary),
            ),
            trailing: Text(
              _appVersion.isEmpty ? '1.0.0' : _appVersion,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Divider(
            color: AppColors.borderColor,
            height: 1,
            indent: 56,
          ),
          ListTile(
            leading: Icon(
              Icons.privacy_tip_outlined,
              color: AppColors.textPrimary,
            ),
            title: Text(
              l10n.privacyPolicy,
              style: TextStyle(color: AppColors.textPrimary),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
            onTap: () {
              // TODO: Navigate to privacy policy
            },
          ),
          Divider(
            color: AppColors.borderColor,
            height: 1,
            indent: 56,
          ),
          ListTile(
            leading: Icon(
              Icons.description_outlined,
              color: AppColors.textPrimary,
            ),
            title: Text(
              l10n.termsOfService,
              style: TextStyle(color: AppColors.textPrimary),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
            onTap: () {
              // TODO: Navigate to terms of service
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutCard(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          Icons.logout,
          color: AppColors.error,
        ),
        title: Text(
          l10n.logout,
          style: TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppColors.error,
          size: 16,
        ),
        onTap: _logout,
      ),
    );
  }
}
