import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_links.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/services/share_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/settings_bloc.dart';
import '../../bloc/settings_event.dart';
import '../../bloc/settings_state.dart';
import '../widgets/settings_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsPageContent();
  }
}

class _SettingsPageContent extends StatefulWidget {
  const _SettingsPageContent();

  @override
  State<_SettingsPageContent> createState() => _SettingsPageContentState();
}

class _SettingsPageContentState extends State<_SettingsPageContent> {
  @override
  void initState() {
    super.initState();
    AnalyticsService().logSettingsOpened();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoaded) {
              return _buildSettings(context, state);
            } else if (state is SettingsError) {
              return _buildError(state.message);
            }
            return _buildLoading();
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppColors.textLight,
          size: 20.sp,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        t.settings_title,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textLight,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.error,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSettings(BuildContext context, SettingsLoaded state) {
    final t = AppLocalizations.of(context)!;
    return ListView(
      children: [
        SizedBox(height: 16.h),

        // Account Section
        _buildSectionHeader(t.settings_section_account),
        _buildSubscriptionStatus(
          context,
          state.hasSubscription,
          onTap: state.hasSubscription
              ? null
              : () => context.push('/paywall?context=paywall&source=settings'),
        ),
        if (!state.hasSubscription)
          SettingsItem(
            icon: Icons.workspace_premium,
            title: t.settings_restore_purchases,
            subtitle: t.settings_restore_purchases_desc,
            iconColor: AppColors.accent,
            onTap: () {
              context.read<SettingsBloc>().add(const RestorePurchaseEvent());
              _showRestoreDialog(context);
            },
          ),

        SizedBox(height: 24.h),

        // App Settings Section
        _buildSectionHeader(t.settings_section_app),
        SettingsItem(
          icon: Icons.language,
          title: t.settings_language,
          subtitle: _getLanguageName(context, state.language),
          iconColor: AppColors.primary,
          onTap: () => context.push('/language'),
        ),

        SizedBox(height: 24.h),

        // Support & Feedback Section
        _buildSectionHeader(t.settings_section_support),
        SettingsItem(
          icon: Icons.help_outline,
          title: t.settings_how_to_play,
          subtitle: t.settings_how_to_play_desc,
          iconColor: AppColors.info,
          onTap: () => context.push('/how-to-play'),
        ),
        SettingsItem(
          icon: Icons.support_agent,
          title: _localizedContactSupportTitle(state.language),
          subtitle: 'support@flyprox.com',
          iconColor: AppColors.primary,
          onTap: _contactSupport,
        ),
        SettingsItem(
          icon: Icons.share,
          title: t.settings_share_app,
          subtitle: t.settings_share_app_desc,
          iconColor: AppColors.secondary,
          onTap: () => _shareApp(context),
        ),
        SettingsItem(
          icon: Icons.star_outline,
          title: t.settings_rate_us,
          subtitle: t.settings_rate_us_desc,
          iconColor: AppColors.warning,
          onTap: () => _requestReview(),
        ),

        SizedBox(height: 24.h),

        // About Section
        _buildSectionHeader(t.settings_section_about),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            final version = snapshot.data?.version ?? '1.0.0';
            return SettingsItem(
              icon: Icons.info_outline,
              title: t.settings_app_version,
              subtitle: version,
              iconColor: AppColors.textGrey,
            );
          },
        ),
        SettingsItem(
          icon: Icons.description,
          title: t.settings_terms,
          iconColor: AppColors.textGrey,
          onTap: () => _openExternalLink(AppLinks.termsOfUseUrl),
        ),
        SettingsItem(
          icon: Icons.privacy_tip,
          title: t.settings_privacy,
          iconColor: AppColors.textGrey,
          onTap: () => _openExternalLink(
            AppLinks.privacyPolicyUrlForLocale(Localizations.localeOf(context)),
          ),
        ),

        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textGreyLight,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSubscriptionStatus(
    BuildContext context,
    bool hasSubscription, {
    VoidCallback? onTap,
  }) {
    final t = AppLocalizations.of(context)!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: hasSubscription
                ? AppColors.primaryGradient
                : LinearGradient(
                    colors: [
                      AppColors.textGrey.withOpacity(0.2),
                      AppColors.textGrey.withOpacity(0.1),
                    ],
                  ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Icon(
                hasSubscription ? Icons.verified : Icons.lock_outline,
                color: AppColors.textLight,
                size: 32.sp,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasSubscription
                          ? t.settings_premium_member
                          : t.settings_free_plan,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      hasSubscription
                          ? t.settings_premium_desc
                          : t.settings_free_desc,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textLight.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              if (!hasSubscription) ...[
                SizedBox(width: 12.w),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textLight.withOpacity(0.8),
                  size: 16.sp,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getLanguageName(BuildContext context, String code) {
    final t = AppLocalizations.of(context)!;
    switch (code) {
      case 'en':
        return t.language_english;
      case 'es':
        return t.language_spanish;
      case 'de':
        return t.language_german;
      case 'fr':
        return t.language_french;
      case 'it':
        return t.language_italian;
      case 'ja':
        return t.language_japanese;
      case 'ko':
        return t.language_korean;
      case 'nb':
        return t.language_norwegian;
      case 'nl':
        return t.language_dutch;
      case 'pt_BR':
        return t.language_portuguese_brazil;
      case 'ru':
        return t.language_russian;
      case 'sv':
        return t.language_swedish;
      default:
        return t.language_english;
    }
  }

  Future<void> _shareApp(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    final androidUrl = AppLinks.androidStoreUrl;
    final iosUrl = AppLinks.iosStoreUrl;

    final shareMessage = StringBuffer()
      ..writeln(t.settings_share_message)
      ..writeln()
      ..writeln(androidUrl);

    if (iosUrl.isNotEmpty) {
      shareMessage.writeln(iosUrl);
    }

    final shared = await ShareService.shareText(
      context,
      shareMessage.toString().trim(),
      subject: t.settings_share_subject,
    );

    if (shared) {
      await AnalyticsService().logShareAction('app');
      return;
    }

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t.common_error,
          style: TextStyle(color: AppColors.textLight, fontSize: 14.sp),
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }

  Future<void> _requestReview() async {
    final InAppReview inAppReview = InAppReview.instance;
    await AnalyticsService().logReviewRequested('settings');

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

  Future<void> _openExternalLink(String url) async {
    final t = AppLocalizations.of(context)!;
    final uri = Uri.tryParse(url);
    if (uri == null) {
      _showLinkError(t);
      return;
    }

    final openedExternally = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (openedExternally) {
      return;
    }

    final openedInApp = await launchUrl(
      uri,
      mode: LaunchMode.inAppBrowserView,
    );
    if (!openedInApp && mounted) {
      _showLinkError(t);
    }
  }

  Future<void> _contactSupport() async {
    final subject = Uri.encodeComponent(
      'Support Request - Never Have I Ever: Adult IHNE',
    );
    final uri = Uri.parse('mailto:support@flyprox.com?subject=$subject');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _localizedContactSupportTitle(String languageCode) {
    switch (languageCode) {
      case 'de':
        return 'Support kontaktieren';
      case 'es':
        return 'Contactar soporte';
      case 'fr':
        return 'Contacter le support';
      case 'it':
        return 'Contatta il supporto';
      case 'ja':
        return 'サポートに連絡';
      case 'ko':
        return '지원팀 문의';
      case 'nb':
        return 'Kontakt support';
      case 'nl':
        return 'Contact opnemen met support';
      case 'pt':
      case 'pt_BR':
        return 'Falar com o suporte';
      case 'ru':
        return 'Связаться с поддержкой';
      case 'sv':
        return 'Kontakta support';
      case 'en':
      default:
        return 'Contact Support';
    }
  }

  void _showLinkError(AppLocalizations t) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.common_error)),
    );
  }

  void _showRestoreDialog(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          t.settings_restore_dialog_title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
        ),
        content: Text(
          t.subscription_checking,
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
