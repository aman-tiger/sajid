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
import '../../features/onboarding/presentation/pages/onboarding_permissions_flow_page.dart';
import '../../l10n/app_localizations.dart';

class AppRouter {
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _hasSubscriptionKey = 'has_subscription';
  static const String _introPaywallSeenKey = 'intro_paywall_seen';

  static Future<bool> _checkOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  static Future<bool> _shouldShowIntroPaywall() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSubscription = prefs.getBool(_hasSubscriptionKey) ?? false;
    final introPaywallSeen = prefs.getBool(_introPaywallSeenKey) ?? false;
    return !hasSubscription && !introPaywallSeen;
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final onboardingCompleted = await _checkOnboardingCompleted();
      final shouldShowIntroPaywall = await _shouldShowIntroPaywall();

      if (state.matchedLocation == '/' && !onboardingCompleted) {
        return '/onboarding';
      }

      if (state.matchedLocation == '/' && shouldShowIntroPaywall) {
        return '/paywall?context=onboarding&source=onboarding';
      }

      if (state.matchedLocation == '/' && onboardingCompleted) {
        return '/main';
      }

      return null;
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
        path: '/onboarding-permissions',
        name: 'onboarding-permissions',
        builder: (context, state) => const OnboardingPermissionsFlowPage(),
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
        builder: (context, state) {
          final contextKey = state.uri.queryParameters['context'] ?? 'paywall';
          final source = state.uri.queryParameters['source'] ?? 'app';
          return PaywallPage(
            contextKey: contextKey,
            source: source,
          );
        },
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
