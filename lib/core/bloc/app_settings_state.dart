import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../services/theme_service.dart';

abstract class AppSettingsState extends Equatable {
  const AppSettingsState();

  @override
  List<Object?> get props => [];
}

class AppSettingsInitial extends AppSettingsState {}

class AppSettingsLoading extends AppSettingsState {}

class AppSettingsLoaded extends AppSettingsState {
  final AppThemeMode themeMode;
  final Locale locale;

  const AppSettingsLoaded({
    required this.themeMode,
    required this.locale,
  });

  @override
  List<Object?> get props => [themeMode, locale];

  AppSettingsLoaded copyWith({
    AppThemeMode? themeMode,
    Locale? locale,
  }) {
    return AppSettingsLoaded(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}
