import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_links.dart';
import '../widgets/onboarding_button.dart';
import '../../../../l10n/app_localizations.dart';

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
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS &&
        AppLinks.iosAppStoreId.isNotEmpty) {
      await inAppReview.openStoreListing(appStoreId: AppLinks.iosAppStoreId);
      return;
    }

    await inAppReview.openStoreListing();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
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
                t.onboarding_4_title,
                style: AppTextStyles.h1(),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.spaceMd),

              // Subtitle
              Text(
                t.onboarding_4_subtitle,
                style: AppTextStyles.bodyLarge(color: AppColors.textGrey),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // Start Button
              OnboardingButton(
                text: t.button_get_started,
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
