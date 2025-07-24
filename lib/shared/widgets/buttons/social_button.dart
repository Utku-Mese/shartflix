import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SocialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final double size;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;

  const SocialButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size = 60,
    this.borderRadius = 16,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.grey900,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? AppColors.grey700,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(child: icon),
        ),
      ),
    );
  }
}
