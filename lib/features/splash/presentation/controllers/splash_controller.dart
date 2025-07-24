import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/logger_service.dart';

class SplashController {
  static const Duration _splashDuration = Duration(seconds: 5);
  static const Duration _animationDuration = Duration(milliseconds: 2000);

  static Future<void> startSplashSequence({
    required BuildContext context,
    required AnimationController animationController,
  }) async {
    final logger = getIt<LoggerService>();

    // Start animation
    animationController.forward();

    try {
      // Wait for splash duration
      await Future.delayed(_splashDuration);

      logger.info('Splash sequence completed');

      // Navigate to login page
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e, stackTrace) {
      logger.error('Error during splash sequence', e, stackTrace);
    }
  }

  static AnimationController createAnimationController({
    required TickerProvider vsync,
  }) {
    return AnimationController(
      duration: _animationDuration,
      vsync: vsync,
    );
  }

  static Animation<double> createFadeAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));
  }

  static Animation<double> createScaleAnimation(
      AnimationController controller) {
    return Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));
  }
}
