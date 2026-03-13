import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'core/services/firebase_service.dart';
import 'core/services/amplitude_service.dart';
import 'core/services/analytics_service.dart';
import 'core/services/sentry_service.dart';
import 'core/services/subscription_service.dart';
import 'core/config/app_secrets.dart';
import 'features/settings/bloc/settings_bloc.dart';
import 'features/settings/bloc/settings_event.dart';
import 'features/settings/bloc/settings_state.dart';
import 'l10n/app_localizations.dart';

AppsflyerSdk? appsflyerSdk;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeAppsflyer();

  // Initialize Sentry and wrap the app
  await SentryService.initialize(() async {
    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Initialize Firebase (expects google-services files provided by CI/local setup).
    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint('Firebase initialize failed: $e');
    }

    // Initialize Firebase services (Analytics, Crashlytics, FCM)
    await FirebaseService().initialize();

    // Initialize Amplitude
    await AmplitudeService().initialize();

    // Initialize Qonversion SDK
    if (AppSecrets.qonversionProjectKey.isNotEmpty) {
      final config = QonversionConfigBuilder(
        AppSecrets.qonversionProjectKey,
        QLaunchMode.subscriptionManagement,
      ).build();
      Qonversion.initialize(config);
      await _stitchQonversionAndAppsflyer();
    } else {
      debugPrint('Qonversion key missing. Set QONVERSION_PROJECT_KEY.');
    }

    await AnalyticsService().logAppOpened();
    await _syncPushAudienceSegment();

    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 11 Pro size as base
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => SettingsBloc()..add(const LoadSettingsEvent()),
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return MaterialApp.router(
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context)?.main_menu_title ??
                    'Never Have I Ever: Adult IHNE',
                debugShowCheckedModeBanner: false,

                // Theme
                theme: AppTheme.lightTheme(),
                darkTheme: AppTheme.darkTheme(),
                themeMode: ThemeMode.light,

                // Localization
                locale: state is SettingsLoaded
                    ? _localeFromCode(state.language)
                    : null,
                localizationsDelegates:
                    AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,

                // Routing
                routerConfig: AppRouter.router,
              );
            },
          ),
        );
      },
    );
  }

  Locale _localeFromCode(String code) {
    if (code == 'pt_BR') {
      return const Locale('pt', 'BR');
    }
    return Locale(code);
  }
}

Future<void> _initializeAppsflyer() async {
  if (AppSecrets.appsflyerDevKey.isEmpty || AppSecrets.appsflyerAppId.isEmpty) {
    debugPrint('AppsFlyer keys missing. Set APPSFLYER_DEV_KEY and APPSFLYER_APP_ID.');
    return;
  }

  try {
    await AppTrackingTransparency.requestTrackingAuthorization();

    final options = AppsFlyerOptions(
      afDevKey: AppSecrets.appsflyerDevKey,
      appId: AppSecrets.appsflyerAppId,
      showDebug: false,
      timeToWaitForATTUserAuthorization: 60,
    );

    appsflyerSdk = AppsflyerSdk(options);
    await appsflyerSdk!.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
  } catch (e) {
    debugPrint('AppsFlyer init failed: $e');
  }
}

Future<void> _stitchQonversionAndAppsflyer() async {
  final sdk = appsflyerSdk;
  if (sdk == null) {
    return;
  }

  try {
    final afId = await sdk.getAppsFlyerUID();
    Qonversion.getSharedInstance().setUserProperty(
      QUserPropertyKey.appsFlyerUserId,
      afId ?? '',
    );

    final qonversionUser = await Qonversion.getSharedInstance().userInfo();
    sdk.setCustomerUserId(qonversionUser.qonversionId);
  } catch (e) {
    debugPrint('AppsFlyer/Qonversion stitch failed: $e');
  }
}

Future<void> _syncPushAudienceSegment() async {
  try {
    final segment = await SubscriptionService().resolvePushSegment();
    final analytics = AnalyticsService();
    await analytics.setPushAudienceSegment(segment);
    if (segment == 'active_subscription') {
      await analytics.markSubscriptionActivatedForPush();
    } else if (segment == 'churned') {
      await analytics.markSubscriptionExpiredForPush();
    }
  } catch (e) {
    debugPrint('Push segment sync failed: $e');
  }
}
