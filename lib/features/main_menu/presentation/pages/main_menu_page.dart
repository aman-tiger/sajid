import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/categories.dart';
import '../../../../core/bloc/subscription/subscription_bloc.dart';
import '../../../../core/bloc/subscription/subscription_event.dart';
import '../../../../core/bloc/subscription/subscription_state.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/services/amplitude_service.dart';
import '../widgets/category_card.dart';
import '../../../../l10n/app_localizations.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Log screen view when page loads
    FirebaseService().logScreenView('main_menu');
    AmplitudeService().logScreenView('main_menu');
    
    return BlocProvider(
      create: (context) => SubscriptionBloc(
        subscriptionService: SubscriptionService(),
      )..add(const CheckSubscriptionStatusEvent()),
      child: const _MainMenuPageContent(),
    );
  }
}

class _MainMenuPageContent extends StatefulWidget {
  const _MainMenuPageContent();

  @override
  State<_MainMenuPageContent> createState() => _MainMenuPageContentState();
}

class _MainMenuPageContentState extends State<_MainMenuPageContent> {
  int _currentIndex = 0;

  void _onCategoryTap(BuildContext context, String categoryId, bool isFree, bool isSubscribed) {
    // Log category selection event
    FirebaseService().logEvent('category_selected', parameters: {
      'category_id': categoryId,
      'is_free': isFree,
      'is_subscribed': isSubscribed,
    });
    AmplitudeService().logCategorySelected(categoryId, !isFree);
    
    if (isFree || isSubscribed) {
      // Navigate to game screen
      context.push('/game/$categoryId');
    } else {
      // Log paywall view
      FirebaseService().logEvent('paywall_viewed', parameters: {
        'source': 'category_selection',
        'category_id': categoryId,
      });
      AmplitudeService().logPaywallViewed('category_selection');
      
      // Navigate to paywall
      context.push('/paywall');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        final isSubscribed = state is SubscriptionActive;
        final t = AppLocalizations.of(context)!;

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
                onPressed: () => context.push('/settings'),
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
                t.main_menu_title,
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
                t.main_menu_subtitle,
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
                    isSubscribed: isSubscribed,
                    onTap: () => _onCategoryTap(context, category.id, category.isFree, isSubscribed),
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
            if (!isSubscribed)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingHorizontal,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeightLarge,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/paywall'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.textLight,
                    ),
                    icon: const Icon(Icons.star_rounded),
                    label: Text(
                      t.main_menu_buy_subscription,
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
      },
    );
  }
}
