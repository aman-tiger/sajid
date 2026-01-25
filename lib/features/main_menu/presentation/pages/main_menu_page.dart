import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/categories.dart';
import '../widgets/category_card.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  int _currentIndex = 0;
  final bool _isSubscribed = false; // TODO: Replace with actual subscription status

  void _onCategoryTap(String categoryId, bool isFree) {
    if (isFree || _isSubscribed) {
      // Navigate to game screen
      debugPrint('Navigate to game with category: $categoryId');
      // TODO: Navigate to question screen
    } else {
      // Navigate to paywall
      debugPrint('Navigate to paywall');
      // TODO: Navigate to paywall
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.textDark,
            ),
            onPressed: () {
              debugPrint('Navigate to settings');
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.spaceMd),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingHorizontal,
              ),
              child: Text(
                'Choose Your Adventure',
                style: AppTextStyles.h2(),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: AppDimensions.spaceSm),

            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingHorizontal,
              ),
              child: Text(
                'Select a pack and start the fun!',
                style: AppTextStyles.bodyMedium(color: AppColors.textGrey),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: AppDimensions.spaceXl),

            // Category Carousel
            Expanded(
              child: CarouselSlider.builder(
                itemCount: AppCategories.all.length,
                itemBuilder: (context, index, realIndex) {
                  final category = AppCategories.all[index];
                  return CategoryCard(
                    category: category,
                    isSubscribed: _isSubscribed,
                    onTap: () => _onCategoryTap(category.id, category.isFree),
                  );
                },
                options: CarouselOptions(
                  height: 450,
                  viewportFraction: 0.8,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.2,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.spaceMd),

            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                AppCategories.all.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceXs,
                  ),
                  width: index == _currentIndex ? 24.0 : 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: index == _currentIndex
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusRound,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.spaceLg),

            // Buy Subscription Button (only show if not subscribed)
            if (!_isSubscribed)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingHorizontal,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeightLarge,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      debugPrint('Navigate to paywall');
                      // TODO: Navigate to paywall
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.textLight,
                    ),
                    icon: const Icon(Icons.star_rounded),
                    label: Text(
                      'Unlock All Packs',
                      style: AppTextStyles.button(),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: AppDimensions.spaceLg),
          ],
        ),
      ),
    );
  }
}
