import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class TermsText extends StatelessWidget {
  final VoidCallback? onTermsPressed;

  const TermsText({
    super.key,
    this.onTermsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
          children: [
            const TextSpan(text: 'Kullanıcı '),
            WidgetSpan(
              child: GestureDetector(
                onTap: onTermsPressed,
                child: Text(
                  'sözleşmesini',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const TextSpan(
              text:
                  ' okudum ve kabul ediyorum. Bu\nsözleşmeyi okuyarak devam ediniz lütfen.',
            ),
          ],
        ),
      ),
    );
  }
}
