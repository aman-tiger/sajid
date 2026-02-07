import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class HowToPlayPage extends StatelessWidget {
  const HowToPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: _buildContent(context),
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
        t.how_to_play_title,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textLight,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildContent(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return ListView(
      padding: EdgeInsets.all(24.w),
      children: [
        // Header
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            children: [
              Icon(
                Icons.help_outline,
                size: 64.sp,
                color: AppColors.textLight,
              ),
              SizedBox(height: 16.h),
              Text(
                t.how_to_play_header_title,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                t.how_to_play_header_subtitle,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textLight.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        SizedBox(height: 32.h),

        // Step 1
        _buildStep(
          number: '1',
          title: t.how_to_play_step_1_title,
          description: t.how_to_play_step_1_desc,
          icon: Icons.category,
          color: AppColors.categoryClassic,
          stepLabel: t.how_to_play_step_label,
        ),

        SizedBox(height: 24.h),

        // Step 2
        _buildStep(
          number: '2',
          title: t.how_to_play_step_2_title,
          description: t.how_to_play_step_2_desc,
          icon: Icons.question_answer,
          color: AppColors.categoryParty,
          stepLabel: t.how_to_play_step_label,
        ),

        SizedBox(height: 24.h),

        // Step 3
        _buildStep(
          number: '3',
          title: t.how_to_play_step_3_title,
          description: t.how_to_play_step_3_desc,
          icon: Icons.gavel,
          color: AppColors.categoryGirls,
          stepLabel: t.how_to_play_step_label,
        ),

        SizedBox(height: 24.h),

        // Step 4
        _buildStep(
          number: '4',
          title: t.how_to_play_step_4_title,
          description: t.how_to_play_step_4_desc,
          icon: Icons.swipe,
          color: AppColors.categoryCouples,
          stepLabel: t.how_to_play_step_label,
        ),

        SizedBox(height: 24.h),

        // Step 5
        _buildStep(
          number: '5',
          title: t.how_to_play_step_5_title,
          description: t.how_to_play_step_5_desc,
          icon: Icons.celebration,
          color: AppColors.categoryHot,
          stepLabel: t.how_to_play_step_label,
        ),

        SizedBox(height: 32.h),

        // Pro Tips
        _buildProTips(t),

        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String Function(String) stepLabel,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number badge
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: AppColors.textLight,
                  size: 24.sp,
                ),
              ],
            ),
          ),

          SizedBox(width: 16.w),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        stepLabel(number),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textGreyLight,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProTips(AppLocalizations t) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withOpacity(0.2),
            AppColors.accent.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.accent,
                size: 28.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                t.how_to_play_pro_tips,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildTip(t.how_to_play_tip_1),
          _buildTip(t.how_to_play_tip_2),
          _buildTip(t.how_to_play_tip_3),
          _buildTip(t.how_to_play_tip_4),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.accent,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textLight,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
