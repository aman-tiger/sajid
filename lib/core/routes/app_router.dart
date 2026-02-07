import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/main_menu/presentation/pages/main_menu_page.dart';
import '../../features/game/presentation/pages/game_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/how_to_play/presentation/pages/how_to_play_page.dart';
import '../../features/language/presentation/pages/language_page.dart';
import '../../features/paywall/presentation/pages/paywall_page.dart';
import '../../l10n/app_localizations.dart';

class AppRouter {
  static Future<bool> _checkOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_completed') ?? false;
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final onboardingCompleted = await _checkOnboardingCompleted();

      // If user is on root and onboarding not completed, go to onboarding
      if (state.matchedLocation == '/' && !onboardingCompleted) {
        return '/onboarding';
      }

      // If user is on root and onboarding completed, go to main
      if (state.matchedLocation == '/' && onboardingCompleted) {
        return '/main';
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const CircularProgressIndicator(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (context, state) => const MainMenuPage(),
      ),
      GoRoute(
        path: '/game/:categoryId',
        name: 'game',
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          return GamePage(categoryId: categoryId);
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/how-to-play',
        name: 'how-to-play',
        builder: (context, state) => const HowToPlayPage(),
      ),
      GoRoute(
        path: '/language',
        name: 'language',
        builder: (context, state) => const LanguagePage(),
      ),
      GoRoute(
        path: '/paywall',
        name: 'paywall',
        builder: (context, state) => const PaywallPage(),
      ),
    ],
    errorBuilder: (context, state) {
      final t = AppLocalizations.of(context)!;
      return Scaffold(
        body: Center(
          child: Text(t.error_page_not_found(state.uri.path)),
        ),
      );
    },
  );
}
