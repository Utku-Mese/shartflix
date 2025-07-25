import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final EdgeInsets padding;
  final TextStyle? textStyle;

  const SectionHeader({
    super.key,
    required this.title,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        title,
        style: textStyle ??
            TextStyle(
              color: AppColors.textPrimary,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
