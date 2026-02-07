import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class FeatureList extends StatelessWidget {
  const FeatureList({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      children: [
        _buildFeature(
          icon: '🎉',
          text: t.paywall_feature_1,
        ),
        SizedBox(height: 16.h),
        _buildFeature(
          icon: '🔥',
          text: t.paywall_feature_2,
        ),
        SizedBox(height: 16.h),
        _buildFeature(
          icon: '🌍',
          text: t.paywall_feature_3,
        ),
        SizedBox(height: 16.h),
        _buildFeature(
          icon: '🚀',
          text: t.paywall_feature_4,
        ),
      ],
    );
  }

  Widget _buildFeature({required String icon, required String text}) {
    return Row(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Text(
              icon,
              style: TextStyle(fontSize: 24.sp),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
        ),
        Icon(
          Icons.check_circle,
          color: AppColors.success,
          size: 24.sp,
        ),
      ],
    );
  }
}
