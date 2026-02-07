import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/bloc/subscription/subscription_bloc.dart';
import '../../../../core/bloc/subscription/subscription_event.dart';
import '../../../../core/bloc/subscription/subscription_state.dart';
import '../../../../core/services/subscription_service.dart';
import '../widgets/feature_list.dart';
import '../widgets/subscription_card.dart';
import '../../../../l10n/app_localizations.dart';

class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  QOfferings? _offerings;
  QProduct? _selectedProduct;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      final subscriptionService = SubscriptionService();
      final offerings = await subscriptionService.getOfferings();

      setState(() {
        _offerings = offerings;
        _isLoading = false;

        // Auto-select the first product if available
        if (offerings?.main?.products.isNotEmpty ?? false) {
          _selectedProduct = offerings!.main!.products.first;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubscriptionBloc(
        subscriptionService: SubscriptionService(),
      ),
      child: BlocListener<SubscriptionBloc, SubscriptionState>(
        listener: (context, state) {
          if (state is SubscriptionPurchaseSuccess) {
            _showSuccessDialog();
          } else if (state is SubscriptionError) {
            _showErrorDialog(state.message);
          } else if (state is SubscriptionRestoreSuccess) {
            if (state.hadPurchases) {
              _showRestoreSuccessDialog();
            } else {
              _showNoRestoreDialog();
            }
          }
        },
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: _isLoading ? _buildLoading() : _buildPaywallContent(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.close,
          color: AppColors.textLight,
          size: 24.sp,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildLoading() {
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 24.h),
          Text(
            t.paywall_loading,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textGreyLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaywallContent() {
    final t = AppLocalizations.of(context)!;
    if (_offerings == null || _offerings!.main == null) {
      return _buildError();
    }

    final products = _offerings!.main!.products;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              t.paywall_title,
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12.h),

            Text(
              t.paywall_subtitle,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textGreyLight,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 32.h),

            // Features
            const FeatureList(),

            SizedBox(height: 32.h),

            // Subscription plans
            Text(
              t.paywall_choose_plan,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),

            SizedBox(height: 16.h),

            ...products.asMap().entries.map((entry) {
              final index = entry.key;
              final product = entry.value;
              final isYearly = product.subscriptionPeriod?.unit ==
                  QSubscriptionPeriodUnit.year;

              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: SubscriptionCard(
                  product: product,
                  isSelected: _selectedProduct?.qonversionId ==
                      product.qonversionId,
                  onTap: () => setState(() => _selectedProduct = product),
                  showBestValue: isYearly,
                ),
              );
            }),

            SizedBox(height: 24.h),

            // Trial text (if available)
            if (_selectedProduct?.trialPeriod != null)
              Text(
                t.paywall_trial_text(
                  _selectedProduct?.prettyPrice ?? '',
                ),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGreyLight,
                ),
                textAlign: TextAlign.center,
              ),

            SizedBox(height: 16.h),

            // Subscribe button
            BlocBuilder<SubscriptionBloc, SubscriptionState>(
              builder: (context, state) {
                final isPurchasing = state is SubscriptionPurchasing;

                return SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: isPurchasing || _selectedProduct == null
                        ? null
                        : () => _handlePurchase(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor:
                          AppColors.primary.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: isPurchasing
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
                            _selectedProduct?.trialPeriod != null
                                ? t.paywall_start_trial
                                : t.paywall_subscribe,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textLight,
                            ),
                          ),
                  ),
                );
              },
            ),

            SizedBox(height: 24.h),

            // Restore purchases
            TextButton(
              onPressed: () => _handleRestore(context),
              child: Text(
                t.paywall_restore,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Terms and privacy
            Text(
              t.paywall_cancel_anytime,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textGrey,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // TODO: Open Terms & Conditions
                  },
                  child: Text(
                    t.paywall_terms,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textGrey,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Text(
                  ' • ',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textGrey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Open Privacy Policy
                  },
                  child: Text(
                    t.paywall_privacy,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textGrey,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: AppColors.error,
            ),
            SizedBox(height: 24.h),
            Text(
              t.paywall_error,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: () {
                setState(() => _isLoading = true);
                _loadOfferings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(
                t.common_retry,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePurchase(BuildContext context) {
    if (_selectedProduct != null) {
      context.read<SubscriptionBloc>().add(
            PurchaseSubscriptionEvent(_selectedProduct!),
          );
    }
  }

  void _handleRestore(BuildContext context) {
    context.read<SubscriptionBloc>().add(const RestorePurchaseEvent());
  }

  void _showSuccessDialog() {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Column(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 64.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              t.common_success,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
        content: Text(
          t.subscription_purchase_success,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textGreyLight,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close paywall
            },
            child: Text(
              t.button_start_game,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 28.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              t.common_error,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textGreyLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              t.button_ok,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRestoreSuccessDialog() {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Column(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 64.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              t.common_success,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
        content: Text(
          t.subscription_restore_success,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textGreyLight,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close paywall
            },
            child: Text(
              t.common_done,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNoRestoreDialog() {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.info,
              size: 28.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              t.common_info,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
        content: Text(
          t.subscription_restore_error,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textGreyLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              t.button_ok,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
