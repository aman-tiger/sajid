import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class SubscriptionCard extends StatelessWidget {
  final QProduct product;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showBestValue;
  final String? weeklyPlanText;
  final String? monthlyPlanText;
  final String? yearlyPlanText;
  final String? premiumText;
  final String? threeDaysFreeText;
  final String? bestValueText;

  const SubscriptionCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onTap,
    this.showBestValue = false,
    this.weeklyPlanText,
    this.monthlyPlanText,
    this.yearlyPlanText,
    this.premiumText,
    this.threeDaysFreeText,
    this.bestValueText,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final formattedPrice = _displayPrice(context);

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
                        formattedPrice,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textGreyLight,
                        ),
                      ),
                      if (product.trialPeriod != null || (threeDaysFreeText != null && threeDaysFreeText!.isNotEmpty)) ...[
                        SizedBox(height: 4.h),
                        Text(
                          threeDaysFreeText ?? t.paywall_three_days_free,
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
                      formattedPrice,
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
                  bestValueText ?? t.paywall_best_value,
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
    final unit = _resolveUnit();

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
    final unit = _resolveUnit();
    final premiumLabel = premiumText ?? t.main_menu_premium;
    if (unit == QSubscriptionPeriodUnit.week) {
      return '${weeklyPlanText ?? t.paywall_weekly_plan} $premiumLabel';
    }
    if (unit == QSubscriptionPeriodUnit.month) {
      return '${monthlyPlanText ?? t.paywall_monthly_plan} $premiumLabel';
    }
    if (unit == QSubscriptionPeriodUnit.year) {
      return '${yearlyPlanText ?? t.paywall_yearly_plan} $premiumLabel';
    }
    return premiumLabel;
  }

  QSubscriptionPeriodUnit? _resolveUnit() {
    final unit = product.subscriptionPeriod?.unit;
    if (unit != null) {
      return unit;
    }

    final identifier =
        '${product.qonversionId} ${product.storeId ?? ''}'.toLowerCase();
    if (identifier.contains('week')) {
      return QSubscriptionPeriodUnit.week;
    }
    if (identifier.contains('month')) {
      return QSubscriptionPeriodUnit.month;
    }
    if (identifier.contains('year') || identifier.contains('annual')) {
      return QSubscriptionPeriodUnit.year;
    }
    return null;
  }

  String _displayPrice(BuildContext context) {
    if (product.prettyPrice != null && product.prettyPrice!.trim().isNotEmpty) {
      return product.prettyPrice!.trim();
    }
    if (product.price != null) {
      try {
        final locale = Localizations.localeOf(context).toString();
        final format = NumberFormat.simpleCurrency(
          locale: locale,
          name: product.currencyCode ?? 'USD',
        );
        return format.format(product.price);
      } catch (_) {
        final value = product.price!.toStringAsFixed(2);
        if (product.currencyCode != null && product.currencyCode!.isNotEmpty) {
          return '${product.currencyCode} $value';
        }
        return value;
      }
    }
    return '';
  }
}
