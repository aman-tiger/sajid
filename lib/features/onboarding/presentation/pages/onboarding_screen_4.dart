import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/onboarding_button.dart';

class OnboardingScreen4 extends StatelessWidget {
  final VoidCallback onComplete;

  const OnboardingScreen4({
    super.key,
    required this.onComplete,
  });

  Future<void> _requestReview() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    } else {
      debugPrint('In-app review not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryLight.withValues(alpha: 0.1),
            AppColors.surface,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingHorizontal,
          ),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Illustration
              SvgPicture.asset(
                'assets/illustrations/onboarding_4.svg',
                width: AppDimensions.illustrationLarge,
                height: AppDimensions.illustrationLarge,
              ),

              const SizedBox(height: AppDimensions.spaceXl),

              // Title
              Text(
                'Love the Game?',
                style: AppTextStyles.h1(),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.spaceMd),

              // Subtitle
              Text(
                'Help us spread the joy by leaving a review!\nYour feedback helps us create better experiences.',
                style: AppTextStyles.bodyLarge(color: AppColors.textGrey),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // Start Button
              OnboardingButton(
                text: 'Get Started',
                onPressed: () async {
                  await _requestReview();
                  onComplete();
                },
              ),

              const SizedBox(height: AppDimensions.spaceLg),
            ],
          ),
        ),
      ),
    );
  }
}
