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
  final String weeklyProductId;

  const SubscriptionCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onTap,
    required this.weeklyProductId,
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
    
    final id = product.qonversionId.toLowerCase();
    final sId = (product.storeId ?? '').toLowerCase();
    final wId = weeklyProductId.toLowerCase();
    
    // Robust detection for IDs
    final unit = product.subscriptionPeriod?.unit;
    final isWeekly = unit == QSubscriptionPeriodUnit.week || 
                     id.contains('week') || sId.contains('week') || 
                     id == wId || sId == wId || id.contains('weekly_premium');
                     
    final hasTrial = product.trialPeriod != null || isWeekly;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.backgroundLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textGrey.withValues(alpha: 0.1),
                width: isSelected ? 2 : 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.textGrey.withValues(alpha: 0.5),
                      width: 2,
                    ),
                    color: isSelected ? AppColors.primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16.sp,
                        )
                      : null,
                ),

                SizedBox(width: 16.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getPlanName(t, isWeekly),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textLight,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        formattedPrice,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textGreyLight,
                        ),
                      ),
                      if (hasTrial) ...[
                        SizedBox(height: 4.h),
                        Text(
                          threeDaysFreeText ?? t.paywall_three_days_free,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

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
                      _getPricePeriod(t, isWeekly),
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

          if (showBestValue)
            Positioned(
              top: -12.h,
              right: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: AppColors.secondaryGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  bestValueText ?? t.paywall_best_value,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getPricePeriod(AppLocalizations t, bool isWeeklyFallback) {
    final unit = product.subscriptionPeriod?.unit;
    final duration = product.subscriptionPeriod?.unitCount ?? 1;

    if (unit == QSubscriptionPeriodUnit.week || isWeeklyFallback) {
      return duration == 1 ? t.price_per_week : t.price_per_weeks(duration.toString());
    } else if (unit == QSubscriptionPeriodUnit.month) {
      return duration == 1 ? t.price_per_month : t.price_per_months(duration.toString());
    } else if (unit == QSubscriptionPeriodUnit.year) {
      return duration == 1 ? t.price_per_year : t.price_per_years(duration.toString());
    }
    return isWeeklyFallback ? t.price_per_week : '';
  }

  String _getPlanName(AppLocalizations t, bool isWeeklyFallback) {
    final unit = product.subscriptionPeriod?.unit;
    final premiumLabel = premiumText ?? t.main_menu_premium;
    final id = product.qonversionId.toLowerCase();
    final sId = (product.storeId ?? '').toLowerCase();
    final wId = weeklyProductId.toLowerCase();

    if (unit == QSubscriptionPeriodUnit.week || isWeeklyFallback || id.contains('week') || sId.contains('week') || id == wId || sId == wId) {
      return '${weeklyPlanText ?? t.paywall_weekly_plan} $premiumLabel';
    }
    if (unit == QSubscriptionPeriodUnit.month || id.contains('month') || sId.contains('month')) {
      return '${monthlyPlanText ?? t.paywall_monthly_plan} $premiumLabel';
    }
    if (unit == QSubscriptionPeriodUnit.year || id.contains('year') || sId.contains('year') || id.contains('annual') || sId.contains('annual')) {
      return '${yearlyPlanText ?? t.paywall_yearly_plan} $premiumLabel';
    }
    return premiumLabel;
  }

  String _displayPrice(BuildContext context) {
    if (product.prettyPrice != null && product.prettyPrice!.trim().isNotEmpty) {
      return product.prettyPrice!.trim();
    }
    if (product.price != null) {
      try {
        final format = NumberFormat.simpleCurrency(
          locale: Localizations.localeOf(context).toString(),
          name: product.currencyCode ?? 'USD',
        );
        return format.format(product.price);
      } catch (_) {
        return product.currencyCode != null ? '${product.currencyCode} ${product.price!.toStringAsFixed(2)}' : product.price!.toStringAsFixed(2);
      }
    }
    return '';
  }
}
