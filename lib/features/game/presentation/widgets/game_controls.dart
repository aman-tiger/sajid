import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class GameControls extends StatelessWidget {
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onShuffle;
  final VoidCallback? onShare;
  final bool hasPrevious;
  final bool hasNext;

  const GameControls({
    super.key,
    this.onPrevious,
    this.onNext,
    this.onShuffle,
    this.onShare,
    this.hasPrevious = true,
    this.hasNext = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Previous button
          _ControlButton(
            icon: Icons.arrow_back_ios,
            onTap: hasPrevious ? onPrevious : null,
            label: t.game_button_previous,
          ),

          // Shuffle button
          _ControlButton(
            icon: Icons.shuffle,
            onTap: onShuffle,
            label: t.game_button_shuffle,
            color: AppColors.accent,
          ),

          // Share button
          _ControlButton(
            icon: Icons.share,
            onTap: onShare,
            label: t.game_button_share,
            color: AppColors.secondary,
          ),

          // Next button
          _ControlButton(
            icon: Icons.arrow_forward_ios,
            onTap: hasNext ? onNext : null,
            label: t.game_button_next,
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String label;
  final Color? color;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    final buttonColor = color ?? AppColors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: isEnabled
              ? buttonColor.withOpacity(0.2)
              : AppColors.textGrey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: Icon(
                icon,
                color: isEnabled ? buttonColor : AppColors.textGrey,
                size: 24.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: isEnabled
                ? AppColors.textLight.withOpacity(0.7)
                : AppColors.textGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
