import 'dart:async';
import 'package:flutter/material.dart';

class AppEvent {}

class ThemeChangedEvent extends AppEvent {
  final bool isDark;
  ThemeChangedEvent(this.isDark);
}

class LanguageChangedEvent extends AppEvent {
  final Locale locale;
  LanguageChangedEvent(this.locale);
}

class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();

  final StreamController<AppEvent> _controller =
      StreamController<AppEvent>.broadcast();

  Stream<T> on<T extends AppEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  void fire(AppEvent event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}
