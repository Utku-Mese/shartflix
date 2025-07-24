import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'social_button.dart';

class SocialLoginRow extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onFacebookPressed;

  const SocialLoginRow({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialButton(
          onPressed: onGooglePressed ?? () {},
          icon: SvgPicture.asset('assets/icons/google.svg'),
        ),
        const SizedBox(width: 8.44),
        SocialButton(
          onPressed: onApplePressed ?? () {},
          icon: SvgPicture.asset('assets/icons/apple.svg'),
        ),
        const SizedBox(width: 8.44),
        SocialButton(
          onPressed: onFacebookPressed ?? () {},
          icon: SvgPicture.asset('assets/icons/facebook.svg'),
        ),
      ],
    );
  }
}
