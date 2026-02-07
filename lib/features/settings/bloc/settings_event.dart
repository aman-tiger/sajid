import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

class ChangeLanguageEvent extends SettingsEvent {
  final String languageCode;

  const ChangeLanguageEvent(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class ToggleThemeEvent extends SettingsEvent {
  const ToggleThemeEvent();
}

class RestorePurchaseEvent extends SettingsEvent {
  const RestorePurchaseEvent();
}
