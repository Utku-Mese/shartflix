import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/logger_service.dart';

class SplashController {
  static const Duration _splashDuration = Duration(seconds: 3);
  static const Duration _animationDuration = Duration(milliseconds: 2000);

  static Future<void> startSplashSequence({
    required BuildContext context,
    required AnimationController animationController,
    VoidCallback? onComplete,
  }) async {
    final logger = getIt<LoggerService>();

    // Start animation
    animationController.forward();

    try {
      // Wait for splash duration
      await Future.delayed(_splashDuration);

      logger.info('Splash sequence completed');

      // Call completion callback if provided
      onComplete?.call();
    } catch (e, stackTrace) {
      logger.error('Error during splash sequence', e, stackTrace);
      // Even on error, call completion callback
      onComplete?.call();
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
