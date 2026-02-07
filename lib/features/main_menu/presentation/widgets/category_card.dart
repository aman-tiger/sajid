import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/categories.dart';
import '../../../../core/models/category_model.dart';
import '../../../../l10n/app_localizations.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final bool isSubscribed;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isSubscribed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final bool isLocked = !category.isFree && !isSubscribed;
    final localizedName = AppCategories.localizedName(t, category.id);
    final localizedDescription = AppCategories.localizedDescription(
      t,
      category.id,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.categoryCardWidth,
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceSm,
          vertical: AppDimensions.spaceMd,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(
            AppDimensions.categoryCardBorderRadius,
          ),
          boxShadow: [
            BoxShadow(
              color: category.color.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Top section with gradient background
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        category.color,
                        category.color.withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(
                        AppDimensions.categoryCardBorderRadius,
                      ),
                      topRight: Radius.circular(
                        AppDimensions.categoryCardBorderRadius,
                      ),
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      category.iconPath,
                      width: 120,
                      height: 120,
                    ),
                  ),
                ),

                // Bottom section with text
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category name
                        Text(
                          localizedName,
                          style: AppTextStyles.cardTitle(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: AppDimensions.spaceSm),

                        // Description
                        Text(
                          localizedDescription,
                          style: AppTextStyles.cardDescription(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Lock overlay for premium categories
            if (isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.categoryCardBorderRadius,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingMd),
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_rounded,
                            size: 48,
                            color: AppColors.locked,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceMd),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingLg,
                            vertical: AppDimensions.paddingSm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMd,
                            ),
                          ),
                          child: Text(
                            t.main_menu_premium,
                            style: AppTextStyles.button(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Free badge for free categories
            if (category.isFree)
              Positioned(
                top: AppDimensions.paddingMd,
                right: AppDimensions.paddingMd,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMd,
                    vertical: AppDimensions.paddingSm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Text(
                    t.main_menu_free,
                    style: AppTextStyles.caption(color: AppColors.textLight),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
