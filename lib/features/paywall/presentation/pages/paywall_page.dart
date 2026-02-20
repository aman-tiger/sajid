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
  List<QProduct> _displayProducts = <QProduct>[];
  QProduct? _selectedProduct;
  bool _isLoading = true;
  PaywallRemoteSettings _settings = const PaywallRemoteSettings();

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      final subscriptionService = SubscriptionService();
      final offerings = await subscriptionService.getOfferings();
      final payload = await subscriptionService.getPaywallRemoteConfig();
      final settings = PaywallRemoteSettings.fromPayload(payload);
      final filteredProducts = _filterProducts(
        offerings?.main?.products ?? <QProduct>[],
        settings,
      );

      setState(() {
        _offerings = offerings;
        _settings = settings;
        _displayProducts = filteredProducts;
        _isLoading = false;

        // Auto-select the first product if available
        if (filteredProducts.isNotEmpty) {
          _selectedProduct = filteredProducts.first;
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
          } else if (state is SubscriptionPurchaseCancelled) {
            _showErrorDialog(AppLocalizations.of(context)!.subscription_purchase_cancelled);
          } else if (state is SubscriptionPurchasePending) {
            _showErrorDialog('Purchase is pending approval. Please check again shortly.');
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
      leading: _settings.showCloseButton
          ? IconButton(
              icon: Icon(
                Icons.close,
                color: AppColors.textLight,
                size: 24.sp,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
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
    if (_offerings == null || _offerings!.main == null || _displayProducts.isEmpty) {
      return _buildError();
    }

    final products = _displayProducts;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              _settings.title ?? t.paywall_title,
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12.h),

            Text(
              _settings.subtitle ?? t.paywall_subtitle,
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
            if (products.length > 1) ...[
              Text(
                t.paywall_choose_plan,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
              SizedBox(height: 16.h),
            ],

            ...products.asMap().entries.map((entry) {
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
                          AppColors.primary.withValues(alpha: 0.5),
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
                                ? (_settings.startTrialText ??
                                    t.paywall_start_trial)
                                : (_settings.subscribeText ??
                                    t.paywall_subscribe),
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
    if (!mounted) return;
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
              if (!mounted) return;
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
    if (!mounted) return;
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
    if (!mounted) return;
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
              if (!mounted) return;
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
    if (!mounted) return;
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

  List<QProduct> _filterProducts(
    List<QProduct> products,
    PaywallRemoteSettings settings,
  ) {
    if (products.isEmpty) {
      return <QProduct>[];
    }

    if (!settings.showOnlyWeekly) {
      return products;
    }

    final weeklyById = products.where((product) {
      final id = settings.weeklyProductId.toLowerCase();
      return product.qonversionId.toLowerCase() == id ||
          (product.storeId?.toLowerCase() == id);
    }).toList();

    if (weeklyById.isNotEmpty) {
      return weeklyById;
    }

    final weeklyByPeriod = products.where((product) {
      return product.subscriptionPeriod?.unit == QSubscriptionPeriodUnit.week;
    }).toList();

    if (weeklyByPeriod.isNotEmpty) {
      return weeklyByPeriod;
    }

    return <QProduct>[products.first];
  }
}

class PaywallRemoteSettings {
  final bool showCloseButton;
  final bool showOnlyWeekly;
  final String weeklyProductId;
  final String? title;
  final String? subtitle;
  final String? startTrialText;
  final String? subscribeText;

  const PaywallRemoteSettings({
    this.showCloseButton = true,
    this.showOnlyWeekly = true,
    this.weeklyProductId = 'weekly_premium',
    this.title,
    this.subtitle,
    this.startTrialText,
    this.subscribeText,
  });

  factory PaywallRemoteSettings.fromPayload(Map<String, dynamic> payload) {
    bool readBool(String key, bool defaultValue) {
      final value = payload[key];
      if (value is bool) return value;
      if (value is String) {
        return value.toLowerCase() == 'true';
      }
      if (value is num) {
        return value != 0;
      }
      return defaultValue;
    }

    String? readString(String key) {
      final value = payload[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
      return null;
    }

    return PaywallRemoteSettings(
      showCloseButton: readBool('show_close_button', true),
      showOnlyWeekly: readBool('show_only_weekly', true),
      weeklyProductId: readString('weekly_product_id') ?? 'weekly_premium',
      title: readString('title'),
      subtitle: readString('subtitle'),
      startTrialText: readString('start_trial_text'),
      subscribeText: readString('subscribe_text'),
    );
  }
}
