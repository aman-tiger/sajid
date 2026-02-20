import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class SubscriptionCard extends StatelessWidget {
  final QProduct product;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showBestValue;

  const SubscriptionCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onTap,
    this.showBestValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textGrey.withValues(alpha: 0.2),
                width: isSelected ? 3 : 2,
              ),
            ),
            child: Row(
              children: [
                // Radio button
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.textGrey,
                      width: 2,
                    ),
                    color: isSelected ? AppColors.primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: AppColors.textLight,
                          size: 16.sp,
                        )
                      : null,
                ),

                SizedBox(width: 16.w),

                // Plan details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getPlanName(t),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textLight,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        product.prettyPrice ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textGreyLight,
                        ),
                      ),
                      if (product.trialPeriod != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          t.paywall_trial_text(product.prettyPrice ?? ''),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      product.prettyPrice ?? '',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                    Text(
                      _getPricePeriod(t),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textGreyLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Best value badge
          if (showBestValue)
            Positioned(
              top: -12.h,
              right: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: AppColors.secondaryGradient,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  t.paywall_best_value,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getPricePeriod(AppLocalizations t) {
    final duration = product.subscriptionPeriod?.unitCount ?? 1;
    final unit = product.subscriptionPeriod?.unit;

    if (unit == QSubscriptionPeriodUnit.week) {
      return duration == 1
          ? t.price_per_week
          : t.price_per_weeks(duration.toString());
    } else if (unit == QSubscriptionPeriodUnit.month) {
      return duration == 1
          ? t.price_per_month
          : t.price_per_months(duration.toString());
    } else if (unit == QSubscriptionPeriodUnit.year) {
      return duration == 1
          ? t.price_per_year
          : t.price_per_years(duration.toString());
    }
    return '';
  }

  String _getPlanName(AppLocalizations t) {
    final unit = product.subscriptionPeriod?.unit;
    if (unit == QSubscriptionPeriodUnit.week) {
      return t.paywall_weekly_plan;
    }
    if (unit == QSubscriptionPeriodUnit.month) {
      return t.paywall_monthly_plan;
    }
    if (unit == QSubscriptionPeriodUnit.year) {
      return t.paywall_yearly_plan;
    }
    return product.storeTitle ?? product.qonversionId;
  }
}
