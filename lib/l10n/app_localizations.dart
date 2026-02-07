import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ko'),
  ];

  /// No description provided for @onboarding_1_title.
  ///
  /// In en, this message translates to:
  /// **'Ready for an Epic Night?'**
  String get onboarding_1_title;

  /// No description provided for @onboarding_1_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Dive into the ultimate game experience!'**
  String get onboarding_1_subtitle;

  /// No description provided for @onboarding_2_title.
  ///
  /// In en, this message translates to:
  /// **'6 Epic Game Packs'**
  String get onboarding_2_title;

  /// No description provided for @onboarding_2_subtitle.
  ///
  /// In en, this message translates to:
  /// **'From classic to spicy - find your perfect vibe!'**
  String get onboarding_2_subtitle;

  /// No description provided for @onboarding_3_title.
  ///
  /// In en, this message translates to:
  /// **'1,500 Questions'**
  String get onboarding_3_title;

  /// No description provided for @onboarding_3_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Endless fun with friends awaits!'**
  String get onboarding_3_subtitle;

  /// No description provided for @onboarding_4_title.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Experience'**
  String get onboarding_4_title;

  /// No description provided for @onboarding_4_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us make the game even better!'**
  String get onboarding_4_subtitle;

  /// No description provided for @button_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get button_continue;

  /// No description provided for @button_start_game.
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get button_start_game;

  /// No description provided for @button_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get button_skip;

  /// No description provided for @button_get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get button_get_started;

  /// No description provided for @button_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get button_back;

  /// No description provided for @button_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get button_next;

  /// No description provided for @button_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get button_save;

  /// No description provided for @button_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get button_cancel;

  /// No description provided for @button_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get button_ok;

  /// No description provided for @button_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get button_close;

  /// No description provided for @button_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get button_share;

  /// No description provided for @button_rate_now.
  ///
  /// In en, this message translates to:
  /// **'Rate Now'**
  String get button_rate_now;

  /// No description provided for @button_maybe_later.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get button_maybe_later;

  /// No description provided for @common_and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get common_and;

  /// No description provided for @main_menu_title.
  ///
  /// In en, this message translates to:
  /// **'Never Have I Ever'**
  String get main_menu_title;

  /// No description provided for @main_menu_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Pack'**
  String get main_menu_subtitle;

  /// No description provided for @main_menu_buy_subscription.
  ///
  /// In en, this message translates to:
  /// **'Unlock All Packs'**
  String get main_menu_buy_subscription;

  /// No description provided for @main_menu_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get main_menu_settings;

  /// No description provided for @main_menu_free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get main_menu_free;

  /// No description provided for @main_menu_premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get main_menu_premium;

  /// No description provided for @category_classic_name.
  ///
  /// In en, this message translates to:
  /// **'Classic Pack'**
  String get category_classic_name;

  /// No description provided for @category_classic_desc.
  ///
  /// In en, this message translates to:
  /// **'The perfect starter to kick off any gathering!'**
  String get category_classic_desc;

  /// No description provided for @category_party_name.
  ///
  /// In en, this message translates to:
  /// **'Party Pack'**
  String get category_party_name;

  /// No description provided for @category_party_desc.
  ///
  /// In en, this message translates to:
  /// **'Energize your celebration with exciting challenges!'**
  String get category_party_desc;

  /// No description provided for @category_girls_name.
  ///
  /// In en, this message translates to:
  /// **'Girls 18+'**
  String get category_girls_name;

  /// No description provided for @category_girls_desc.
  ///
  /// In en, this message translates to:
  /// **'Bold and daring questions for a girls night out!'**
  String get category_girls_desc;

  /// No description provided for @category_couples_name.
  ///
  /// In en, this message translates to:
  /// **'Couples Pack'**
  String get category_couples_name;

  /// No description provided for @category_couples_desc.
  ///
  /// In en, this message translates to:
  /// **'Connect with your partner like never before!'**
  String get category_couples_desc;

  /// No description provided for @category_hot_name.
  ///
  /// In en, this message translates to:
  /// **'Hot Questions 18+'**
  String get category_hot_name;

  /// No description provided for @category_hot_desc.
  ///
  /// In en, this message translates to:
  /// **'Turn up the heat with spicy questions!'**
  String get category_hot_desc;

  /// No description provided for @category_guys_name.
  ///
  /// In en, this message translates to:
  /// **'Guys Pack'**
  String get category_guys_name;

  /// No description provided for @category_guys_desc.
  ///
  /// In en, this message translates to:
  /// **'Epic challenges designed for the bros!'**
  String get category_guys_desc;

  /// No description provided for @game_never_have_i_ever.
  ///
  /// In en, this message translates to:
  /// **'Never Have I Ever...'**
  String get game_never_have_i_ever;

  /// No description provided for @game_swipe_hint.
  ///
  /// In en, this message translates to:
  /// **'Swipe to navigate'**
  String get game_swipe_hint;

  /// No description provided for @game_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading questions...'**
  String get game_loading;

  /// No description provided for @game_error_title.
  ///
  /// In en, this message translates to:
  /// **'Oops!'**
  String get game_error_title;

  /// No description provided for @game_error_no_questions.
  ///
  /// In en, this message translates to:
  /// **'No questions available for this category'**
  String get game_error_no_questions;

  /// No description provided for @game_error_failed_load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load questions'**
  String get game_error_failed_load;

  /// No description provided for @game_button_previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get game_button_previous;

  /// No description provided for @game_button_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get game_button_next;

  /// No description provided for @game_button_shuffle.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get game_button_shuffle;

  /// No description provided for @game_button_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get game_button_share;

  /// No description provided for @game_share_text.
  ///
  /// In en, this message translates to:
  /// **'Never Have I Ever... {question}\n\nDownload Never Have I Ever app and play with friends!'**
  String game_share_text(String question);

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @settings_section_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settings_section_account;

  /// No description provided for @settings_section_app.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get settings_section_app;

  /// No description provided for @settings_section_support.
  ///
  /// In en, this message translates to:
  /// **'Support & Feedback'**
  String get settings_section_support;

  /// No description provided for @settings_section_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settings_section_about;

  /// No description provided for @settings_premium_member.
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get settings_premium_member;

  /// No description provided for @settings_free_plan.
  ///
  /// In en, this message translates to:
  /// **'Free Plan'**
  String get settings_free_plan;

  /// No description provided for @settings_premium_desc.
  ///
  /// In en, this message translates to:
  /// **'Enjoy unlimited access to all packs!'**
  String get settings_premium_desc;

  /// No description provided for @settings_free_desc.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to unlock all premium content'**
  String get settings_free_desc;

  /// No description provided for @settings_restore_purchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get settings_restore_purchases;

  /// No description provided for @settings_restore_purchases_desc.
  ///
  /// In en, this message translates to:
  /// **'Restore your previous purchases'**
  String get settings_restore_purchases_desc;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_language_desc.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get settings_language_desc;

  /// No description provided for @settings_dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settings_dark_mode;

  /// No description provided for @settings_how_to_play.
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get settings_how_to_play;

  /// No description provided for @settings_how_to_play_desc.
  ///
  /// In en, this message translates to:
  /// **'Learn how to play the game'**
  String get settings_how_to_play_desc;

  /// No description provided for @settings_share_app.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get settings_share_app;

  /// No description provided for @settings_share_app_desc.
  ///
  /// In en, this message translates to:
  /// **'Share with friends'**
  String get settings_share_app_desc;

  /// No description provided for @settings_rate_us.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get settings_rate_us;

  /// No description provided for @settings_rate_us_desc.
  ///
  /// In en, this message translates to:
  /// **'Rate us on the store'**
  String get settings_rate_us_desc;

  /// No description provided for @settings_app_version.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get settings_app_version;

  /// No description provided for @settings_terms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get settings_terms;

  /// No description provided for @settings_privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settings_privacy;

  /// No description provided for @settings_restore_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get settings_restore_dialog_title;

  /// No description provided for @settings_restore_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'Your purchases will be restored when Phase 3 is implemented.'**
  String get settings_restore_dialog_message;

  /// No description provided for @settings_share_message.
  ///
  /// In en, this message translates to:
  /// **'Check out Never Have I Ever! The ultimate party game app. Download now!'**
  String get settings_share_message;

  /// No description provided for @settings_share_subject.
  ///
  /// In en, this message translates to:
  /// **'Never Have I Ever - Fun Party Game'**
  String get settings_share_subject;

  /// No description provided for @how_to_play_title.
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get how_to_play_title;

  /// No description provided for @how_to_play_header_title.
  ///
  /// In en, this message translates to:
  /// **'Never Have I Ever'**
  String get how_to_play_header_title;

  /// No description provided for @how_to_play_header_subtitle.
  ///
  /// In en, this message translates to:
  /// **'The Ultimate Party Game'**
  String get how_to_play_header_subtitle;

  /// No description provided for @how_to_play_step_1_title.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Pack'**
  String get how_to_play_step_1_title;

  /// No description provided for @how_to_play_step_1_desc.
  ///
  /// In en, this message translates to:
  /// **'Select from 6 exciting categories that match your party vibe.'**
  String get how_to_play_step_1_desc;

  /// No description provided for @how_to_play_step_2_title.
  ///
  /// In en, this message translates to:
  /// **'Read the Question'**
  String get how_to_play_step_2_title;

  /// No description provided for @how_to_play_step_2_desc.
  ///
  /// In en, this message translates to:
  /// **'Each player takes turns reading \"Never Have I Ever...\" questions aloud.'**
  String get how_to_play_step_2_desc;

  /// No description provided for @how_to_play_step_3_title.
  ///
  /// In en, this message translates to:
  /// **'Truth or Action'**
  String get how_to_play_step_3_title;

  /// No description provided for @how_to_play_step_3_desc.
  ///
  /// In en, this message translates to:
  /// **'Players who HAVE done it must admit it or complete a fun challenge!'**
  String get how_to_play_step_3_desc;

  /// No description provided for @how_to_play_step_4_title.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get how_to_play_step_4_title;

  /// No description provided for @how_to_play_step_4_desc.
  ///
  /// In en, this message translates to:
  /// **'Swipe or tap to move to the next question and keep the fun going!'**
  String get how_to_play_step_4_desc;

  /// No description provided for @how_to_play_step_5_title.
  ///
  /// In en, this message translates to:
  /// **'Have Fun!'**
  String get how_to_play_step_5_title;

  /// No description provided for @how_to_play_step_5_desc.
  ///
  /// In en, this message translates to:
  /// **'Enjoy hilarious moments and get to know your friends better!'**
  String get how_to_play_step_5_desc;

  /// No description provided for @how_to_play_step_label.
  ///
  /// In en, this message translates to:
  /// **'Step {number}'**
  String how_to_play_step_label(String number);

  /// No description provided for @how_to_play_pro_tips.
  ///
  /// In en, this message translates to:
  /// **'Pro Tips'**
  String get how_to_play_pro_tips;

  /// No description provided for @how_to_play_tip_1.
  ///
  /// In en, this message translates to:
  /// **'Use the shuffle button to randomize questions'**
  String get how_to_play_tip_1;

  /// No description provided for @how_to_play_tip_2.
  ///
  /// In en, this message translates to:
  /// **'Share your favorite questions with friends'**
  String get how_to_play_tip_2;

  /// No description provided for @how_to_play_tip_3.
  ///
  /// In en, this message translates to:
  /// **'Premium packs unlock 1,500+ exclusive questions'**
  String get how_to_play_tip_3;

  /// No description provided for @how_to_play_tip_4.
  ///
  /// In en, this message translates to:
  /// **'Best played with 3+ players for maximum fun!'**
  String get how_to_play_tip_4;

  /// No description provided for @onboarding_terms_prefix.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our '**
  String get onboarding_terms_prefix;

  /// No description provided for @onboarding_terms_of_use.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get onboarding_terms_of_use;

  /// No description provided for @language_title.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language_title;

  /// No description provided for @language_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get language_subtitle;

  /// No description provided for @language_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_english;

  /// No description provided for @language_spanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get language_spanish;

  /// No description provided for @language_german.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get language_german;

  /// No description provided for @language_french.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get language_french;

  /// No description provided for @language_korean.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get language_korean;

  /// No description provided for @language_changed_title.
  ///
  /// In en, this message translates to:
  /// **'Language Changed'**
  String get language_changed_title;

  /// No description provided for @language_changed_message.
  ///
  /// In en, this message translates to:
  /// **'Language has been changed to {language}. The app will be fully translated in the final version.'**
  String language_changed_message(String language);

  /// No description provided for @paywall_title.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get paywall_title;

  /// No description provided for @paywall_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Get unlimited access to all game packs'**
  String get paywall_subtitle;

  /// No description provided for @paywall_choose_plan.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Plan'**
  String get paywall_choose_plan;

  /// No description provided for @paywall_feature_1.
  ///
  /// In en, this message translates to:
  /// **'🎉 Unlock All 5 Premium Packs'**
  String get paywall_feature_1;

  /// No description provided for @paywall_feature_2.
  ///
  /// In en, this message translates to:
  /// **'🔥 1,500 Exclusive Questions'**
  String get paywall_feature_2;

  /// No description provided for @paywall_feature_3.
  ///
  /// In en, this message translates to:
  /// **'🌍 5 Languages Available'**
  String get paywall_feature_3;

  /// No description provided for @paywall_feature_4.
  ///
  /// In en, this message translates to:
  /// **'🚀 Regular Content Updates'**
  String get paywall_feature_4;

  /// No description provided for @paywall_weekly_plan.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get paywall_weekly_plan;

  /// No description provided for @paywall_monthly_plan.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get paywall_monthly_plan;

  /// No description provided for @paywall_yearly_plan.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get paywall_yearly_plan;

  /// No description provided for @paywall_best_value.
  ///
  /// In en, this message translates to:
  /// **'Best Value'**
  String get paywall_best_value;

  /// No description provided for @paywall_trial_text.
  ///
  /// In en, this message translates to:
  /// **'3 days free, then {price}/week'**
  String paywall_trial_text(String price);

  /// No description provided for @price_per_week.
  ///
  /// In en, this message translates to:
  /// **'per week'**
  String get price_per_week;

  /// No description provided for @price_per_weeks.
  ///
  /// In en, this message translates to:
  /// **'per {count} weeks'**
  String price_per_weeks(String count);

  /// No description provided for @price_per_month.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get price_per_month;

  /// No description provided for @price_per_months.
  ///
  /// In en, this message translates to:
  /// **'per {count} months'**
  String price_per_months(String count);

  /// No description provided for @price_per_year.
  ///
  /// In en, this message translates to:
  /// **'per year'**
  String get price_per_year;

  /// No description provided for @price_per_years.
  ///
  /// In en, this message translates to:
  /// **'per {count} years'**
  String price_per_years(String count);

  /// No description provided for @paywall_start_trial.
  ///
  /// In en, this message translates to:
  /// **'Start Free Trial'**
  String get paywall_start_trial;

  /// No description provided for @paywall_subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get paywall_subscribe;

  /// No description provided for @paywall_restore.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get paywall_restore;

  /// No description provided for @paywall_terms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get paywall_terms;

  /// No description provided for @paywall_privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get paywall_privacy;

  /// No description provided for @paywall_cancel_anytime.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime. Terms apply.'**
  String get paywall_cancel_anytime;

  /// No description provided for @paywall_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading subscription plans...'**
  String get paywall_loading;

  /// No description provided for @paywall_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to load subscription plans. Please try again.'**
  String get paywall_error;

  /// No description provided for @subscription_active.
  ///
  /// In en, this message translates to:
  /// **'You have an active subscription'**
  String get subscription_active;

  /// No description provided for @subscription_expired.
  ///
  /// In en, this message translates to:
  /// **'Your subscription has expired'**
  String get subscription_expired;

  /// No description provided for @subscription_purchase_success.
  ///
  /// In en, this message translates to:
  /// **'Purchase successful! Enjoy premium content.'**
  String get subscription_purchase_success;

  /// No description provided for @subscription_purchase_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Purchase cancelled'**
  String get subscription_purchase_cancelled;

  /// No description provided for @subscription_purchase_error.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get subscription_purchase_error;

  /// No description provided for @subscription_restore_success.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored successfully!'**
  String get subscription_restore_success;

  /// No description provided for @subscription_restore_error.
  ///
  /// In en, this message translates to:
  /// **'No purchases found to restore.'**
  String get subscription_restore_error;

  /// No description provided for @subscription_checking.
  ///
  /// In en, this message translates to:
  /// **'Checking subscription status...'**
  String get subscription_checking;

  /// No description provided for @error_generic.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get error_generic;

  /// No description provided for @error_network.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get error_network;

  /// No description provided for @error_loading_questions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load questions: {error}'**
  String error_loading_questions(String error);

  /// No description provided for @error_loading_settings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load settings: {error}'**
  String error_loading_settings(String error);

  /// No description provided for @common_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get common_loading;

  /// No description provided for @common_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// No description provided for @common_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get common_done;

  /// No description provided for @common_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get common_error;

  /// No description provided for @common_success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get common_success;

  /// No description provided for @common_warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get common_warning;

  /// No description provided for @common_info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get common_info;

  /// No description provided for @error_page_not_found.
  ///
  /// In en, this message translates to:
  /// **'Page not found: {path}'**
  String error_page_not_found(String path);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
