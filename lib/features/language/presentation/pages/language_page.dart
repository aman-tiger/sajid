import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/services/amplitude_service.dart';
import '../../../settings/bloc/settings_bloc.dart';
import '../../../settings/bloc/settings_event.dart';
import '../../../settings/bloc/settings_state.dart';
import '../../../../l10n/app_localizations.dart';

class LanguageModel {
  final String code;
  final String flag;

  const LanguageModel({
    required this.code,
    required this.flag,
  });
}

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  static const List<LanguageModel> _languages = [
    LanguageModel(
      code: 'en',
      flag: '🇺🇸',
    ),
    LanguageModel(
      code: 'es',
      flag: '🇪🇸',
    ),
    LanguageModel(
      code: 'de',
      flag: '🇩🇪',
    ),
    LanguageModel(
      code: 'fr',
      flag: '🇫🇷',
    ),
    LanguageModel(
      code: 'ko',
      flag: '🇰🇷',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Log language screen view
    FirebaseService().logScreenView('language_selection');
    AmplitudeService().logScreenView('language_selection');
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoaded) {
              return _buildLanguageList(context, state.language);
            }
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
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
        t.language_title,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textLight,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildLanguageList(BuildContext context, String currentLanguage) {
    final t = AppLocalizations.of(context)!;
    return Column(
      children: [
        SizedBox(height: 16.h),

        // Description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            t.language_subtitle,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textGreyLight,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 24.h),

        // Language list
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: _languages.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final language = _languages[index];
              final isSelected = language.code == currentLanguage;
              final languageName = _getLanguageName(t, language.code);

              return _LanguageItem(
                language: language,
                languageName: languageName,
                isSelected: isSelected,
                onTap: () {
                  if (!isSelected) {
                    final oldLanguage = state.language;
                    context.read<SettingsBloc>().add(
                          ChangeLanguageEvent(language.code),
                        );
                    
                    // Log language change
                    FirebaseService().logEvent('language_changed', parameters: {
                      'old_language': oldLanguage,
                      'new_language': language.code,
                    });
                    AmplitudeService().logLanguageChanged(oldLanguage, language.code);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(t.language_changed_title)),
                    );
                  }
                },
              );
            },
          ),
        ),

        SizedBox(height: 24.h),
      ],
    );
  }

  String _getLanguageName(AppLocalizations t, String code) {
    switch (code) {
      case 'en':
        return t.language_english;
      case 'es':
        return t.language_spanish;
      case 'de':
        return t.language_german;
      case 'fr':
        return t.language_french;
      case 'ko':
        return t.language_korean;
      default:
        return t.language_english;
    }
  }
}

class _LanguageItem extends StatelessWidget {
  final LanguageModel language;
  final String languageName;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageItem({
    required this.language,
    required this.languageName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.2)
                : AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.textGrey.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              // Flag
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    language.flag,
                    style: TextStyle(fontSize: 28.sp),
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              // Language names
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      language.code.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textGreyLight,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              // Selection indicator
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 28.sp,
                )
              else
                Icon(
                  Icons.circle_outlined,
                  color: AppColors.textGrey,
                  size: 28.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
