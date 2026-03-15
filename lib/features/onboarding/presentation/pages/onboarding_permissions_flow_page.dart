import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../l10n/app_localizations.dart';

class OnboardingPermissionsFlowPage extends StatefulWidget {
  const OnboardingPermissionsFlowPage({super.key});

  @override
  State<OnboardingPermissionsFlowPage> createState() =>
      _OnboardingPermissionsFlowPageState();
}

class _OnboardingPermissionsFlowPageState
    extends State<OnboardingPermissionsFlowPage> {
  bool _isSubmitting = false;
  late final List<_PermissionStep> _steps = _buildSteps();
  int _currentStepIndex = 0;

  List<_PermissionStep> _buildSteps() {
    final steps = <_PermissionStep>[];
    if (Platform.isIOS) {
      steps.add(_PermissionStep.att);
    }
    steps.add(_PermissionStep.push);
    return steps;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final step = _steps[_currentStepIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isSubmitting ? null : _skipStep,
                  child: Text(
                    t.button_skip,
                    style: TextStyle(
                      color: AppColors.textGreyLight,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                step.icon,
                size: 88.sp,
                color: AppColors.primary,
              ),
              SizedBox(height: 28.h),
              Text(
                step.title(t),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                step.subtitle(t),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textGreyLight,
                  fontSize: 16.sp,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : () => _handleStep(step),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.textLight,
                            ),
                          ),
                        )
                      : Text(
                          step.buttonLabel(t),
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleStep(_PermissionStep step) async {
    setState(() => _isSubmitting = true);
    try {
      switch (step) {
        case _PermissionStep.att:
          await AppTrackingTransparency.requestTrackingAuthorization();
          break;
        case _PermissionStep.push:
          await FirebaseMessaging.instance.requestPermission(
            alert: true,
            badge: true,
            sound: true,
          );
          break;
      }
      await _advance();
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _skipStep() async {
    await _advance();
  }

  Future<void> _advance() async {
    if (_currentStepIndex < _steps.length - 1) {
      setState(() {
        _currentStepIndex += 1;
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro_paywall_seen', false);
    await AnalyticsService().logOnboardingCompleted();
    await AnalyticsService().markOnboardingCompletedForPush();
    await AnalyticsService().setPushAudienceSegment('no_subscription');

    if (!mounted) {
      return;
    }

    context.go('/paywall?context=onboarding&source=onboarding');
  }
}

enum _PermissionStep {
  att,
  push;

  IconData get icon {
    switch (this) {
      case _PermissionStep.att:
        return Icons.shield_outlined;
      case _PermissionStep.push:
        return Icons.notifications_active_outlined;
    }
  }

  String Function(AppLocalizations) get title {
    switch (this) {
      case _PermissionStep.att:
        return (t) => t.onboarding_att_title;
      case _PermissionStep.push:
        return (t) => t.onboarding_push_title;
    }
  }

  String Function(AppLocalizations) get subtitle {
    switch (this) {
      case _PermissionStep.att:
        return (t) => t.onboarding_att_subtitle;
      case _PermissionStep.push:
        return (t) => t.onboarding_push_subtitle;
    }
  }

  String Function(AppLocalizations) get buttonLabel {
    switch (this) {
      case _PermissionStep.att:
        return (t) => t.onboarding_att_button;
      case _PermissionStep.push:
        return (t) => t.onboarding_push_button;
    }
  }
}
