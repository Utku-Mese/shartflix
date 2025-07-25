import 'package:equatable/equatable.dart';

abstract class AppSettingsEvent extends Equatable {
  const AppSettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAppSettings extends AppSettingsEvent {
  const LoadAppSettings();
}

class ChangeTheme extends AppSettingsEvent {
  final bool isDark;

  const ChangeTheme(this.isDark);

  @override
  List<Object?> get props => [isDark];
}

class ChangeLanguage extends AppSettingsEvent {
  final String languageCode;

  const ChangeLanguage(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}
