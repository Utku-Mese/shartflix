import 'package:flutter/material.dart';
import '../controllers/splash_controller.dart';
import '../widgets/splash_logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSplashSequence();
  }

  void _setupAnimations() {
    _animationController =
        SplashController.createAnimationController(vsync: this);
    _fadeAnimation = SplashController.createFadeAnimation(_animationController);
    _scaleAnimation =
        SplashController.createScaleAnimation(_animationController);
  }

  void _startSplashSequence() {
    SplashController.startSplashSequence(
      context: context,
      animationController: _animationController,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return SplashLogo(
              fadeAnimation: _fadeAnimation,
              scaleAnimation: _scaleAnimation,
            );
          },
        ),
      ),
    );
  }
}
