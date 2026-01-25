import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceXs),
          width: index == currentPage ? 32.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: index == currentPage
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          ),
        ),
      ),
    );
  }
}
