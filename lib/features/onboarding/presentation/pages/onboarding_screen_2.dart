import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/onboarding_button.dart';

class OnboardingScreen2 extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingScreen2({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.accentLight.withValues(alpha: 0.1),
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
                'assets/illustrations/onboarding_2.svg',
                width: AppDimensions.illustrationLarge,
                height: AppDimensions.illustrationLarge,
              ),

              const SizedBox(height: AppDimensions.spaceXl),

              // Title
              Text(
                'Pick Your Perfect Pack!',
                style: AppTextStyles.h1(),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.spaceMd),

              // Subtitle
              Text(
                'Exciting, daring, or wild? The choice is yours!\nExplore 6 unique categories packed with hundreds of questions.',
                style: AppTextStyles.bodyLarge(color: AppColors.textGrey),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // Continue Button
              OnboardingButton(
                text: 'Continue',
                onPressed: onNext,
              ),

              const SizedBox(height: AppDimensions.spaceLg),
            ],
          ),
        ),
      ),
    );
  }
}
