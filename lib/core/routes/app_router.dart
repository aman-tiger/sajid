import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/main_menu/presentation/pages/main_menu_page.dart';

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
      // TODO: Add more routes
      // GoRoute(
      //   path: '/game/:categoryId',
      //   name: 'game',
      //   builder: (context, state) {
      //     final categoryId = state.pathParameters['categoryId']!;
      //     return GamePage(categoryId: categoryId);
      //   },
      // ),
      // GoRoute(
      //   path: '/paywall',
      //   name: 'paywall',
      //   builder: (context, state) => const PaywallPage(),
      // ),
      // GoRoute(
      //   path: '/settings',
      //   name: 'settings',
      //   builder: (context, state) => const SettingsPage(),
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );
}
