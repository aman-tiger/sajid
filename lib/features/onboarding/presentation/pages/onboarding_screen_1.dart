import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/onboarding_button.dart';
import '../../../../l10n/app_localizations.dart';

class OnboardingScreen1 extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingScreen1({
    super.key,
    required this.onNext,
  });

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      debugPrint('Notification permission granted');
    } else if (status.isDenied) {
      debugPrint('Notification permission denied');
    } else if (status.isPermanentlyDenied) {
      debugPrint('Notification permission permanently denied');
      await openAppSettings();
    }
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
                'assets/illustrations/onboarding_1.svg',
                width: AppDimensions.illustrationLarge,
                height: AppDimensions.illustrationLarge,
              ),

              const SizedBox(height: AppDimensions.spaceXl),

              // Title
              Text(
                t.onboarding_1_title,
                style: AppTextStyles.h1(),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.spaceMd),

              // Subtitle
              Text(
                t.onboarding_1_subtitle,
                style: AppTextStyles.bodyLarge(color: AppColors.textGrey),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // Continue Button
              OnboardingButton(
                text: t.button_continue,
                onPressed: () async {
                  await _requestNotificationPermission();
                  onNext();
                },
              ),

              const SizedBox(height: AppDimensions.spaceMd),

              // Terms and Privacy
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    t.onboarding_terms_prefix,
                    style: AppTextStyles.caption(),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Navigate to Terms of Use
                    },
                    child: Text(
                      t.onboarding_terms_of_use,
                      style: AppTextStyles.caption(color: AppColors.primary),
                    ),
                  ),
                  Text(
                    ' ${t.common_and} ',
                    style: AppTextStyles.caption(),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Navigate to Privacy Policy
                    },
                    child: Text(
                      t.settings_privacy,
                      style: AppTextStyles.caption(color: AppColors.primary),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spaceLg),
            ],
          ),
        ),
      ),
    );
  }
}
