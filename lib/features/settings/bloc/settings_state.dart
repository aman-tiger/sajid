import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoaded extends SettingsState {
  final String language;
  final bool isDarkMode;
  final bool hasSubscription;

  const SettingsLoaded({
    required this.language,
    this.isDarkMode = false,
    this.hasSubscription = false,
  });

  SettingsLoaded copyWith({
    String? language,
    bool? isDarkMode,
    bool? hasSubscription,
  }) {
    return SettingsLoaded(
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      hasSubscription: hasSubscription ?? this.hasSubscription,
    );
  }

  @override
  List<Object?> get props => [language, isDarkMode, hasSubscription];
}

class SettingsUpdating extends SettingsState {
  const SettingsUpdating();
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
