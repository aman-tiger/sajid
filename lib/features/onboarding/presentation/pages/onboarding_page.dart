import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../widgets/page_indicator.dart';
import 'onboarding_screen_1.dart';
import 'onboarding_screen_2.dart';
import 'onboarding_screen_3.dart';
import 'onboarding_screen_4.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (!mounted) return;

    // Navigate to main menu
    context.go('/main');
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Page View
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                OnboardingScreen1(onNext: _nextPage),
                OnboardingScreen2(onNext: _nextPage),
                OnboardingScreen3(onNext: _nextPage),
                OnboardingScreen4(onComplete: _completeOnboarding),
              ],
            ),
          ),

          // Page Indicator
          Padding(
            padding: const EdgeInsets.only(
              bottom: AppDimensions.paddingLg,
            ),
            child: PageIndicator(
              currentPage: _currentPage,
              pageCount: 4,
            ),
          ),
        ],
      ),
    );
  }
}
