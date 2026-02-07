import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/subscription_service.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  static const String _languageKey = 'app_language';
  static const String _darkModeKey = 'dark_mode';
  static const String _subscriptionKey = 'has_subscription';
  final SubscriptionService _subscriptionService;

  SettingsBloc({SubscriptionService? subscriptionService})
      : _subscriptionService = subscriptionService ?? SubscriptionService(),
        super(const SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<RestorePurchaseEvent>(_onRestorePurchase);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final language = prefs.getString(_languageKey) ?? 'en';
      final isDarkMode = prefs.getBool(_darkModeKey) ?? false;
      final hasSubscription = prefs.getBool(_subscriptionKey) ?? false;

      emit(SettingsLoaded(
        language: language,
        isDarkMode: isDarkMode,
        hasSubscription: hasSubscription,
      ));
    } catch (e) {
      emit(SettingsError('Failed to load settings: ${e.toString()}'));
    }
  }

  Future<void> _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      try {
        final currentState = state as SettingsLoaded;
        emit(const SettingsUpdating());

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_languageKey, event.languageCode);

        emit(currentState.copyWith(language: event.languageCode));
      } catch (e) {
        emit(SettingsError('Failed to change language: ${e.toString()}'));
      }
    }
  }

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      try {
        final currentState = state as SettingsLoaded;
        emit(const SettingsUpdating());

        final newDarkMode = !currentState.isDarkMode;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_darkModeKey, newDarkMode);

        emit(currentState.copyWith(isDarkMode: newDarkMode));
      } catch (e) {
        emit(SettingsError('Failed to toggle theme: ${e.toString()}'));
      }
    }
  }

  Future<void> _onRestorePurchase(
    RestorePurchaseEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      try {
        final currentState = state as SettingsLoaded;
        emit(const SettingsUpdating());

        final hasSubscription = await _subscriptionService.restorePurchases();
        emit(currentState.copyWith(hasSubscription: hasSubscription));
      } catch (e) {
        emit(SettingsError('Failed to restore purchase: ${e.toString()}'));
      }
    }
  }
}
