import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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
  // Use Sentry binding to fix the warning
  SentryWidgetsFlutterBinding.ensureInitialized();

  // Step 1: Log Bundle ID clearly
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  debugPrint('----------------------------------------------');
  debugPrint('🔍 BUNDLE ID: ${packageInfo.packageName}');
  debugPrint('----------------------------------------------');

  await _initializeAppsflyer();

  await SentryService.initialize(() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    try {
      await Firebase.initializeApp();
      debugPrint('✅ Firebase initialized');
    } catch (e) {
      debugPrint('❌ Firebase failed: $e');
    }

    await FirebaseService().initialize();
    await AmplitudeService().initialize();

    // Qonversion Initialization
    final String qKey = AppSecrets.qonversionProjectKey.trim();
    if (qKey.isNotEmpty) {
      try {
        final config = QonversionConfigBuilder(
          qKey,
          QLaunchMode.subscriptionManagement,
        ).build();
        Qonversion.initialize(config);
        debugPrint('🚀 Qonversion initialize called');
        
        // Wait a bit and try to fetch user info to validate credentials
        Future.delayed(const Duration(seconds: 2), () async {
          await _validateQonversion();
        });
      } catch (e) {
        debugPrint('❌ Qonversion Init Error: $e');
      }
    }

    await AnalyticsService().logAppOpened();
    runApp(const MyApp());
  });
}

Future<void> _validateQonversion() async {
  try {
    final qUser = await Qonversion.getSharedInstance().userInfo();
    debugPrint('✅ Qonversion CONNECTED: ${qUser.qonversionId}');
    
    // Stitch with AppsFlyer if available
    if (appsflyerSdk != null) {
      final afId = await appsflyerSdk!.getAppsFlyerUID();
      Qonversion.getSharedInstance().setUserProperty(
        QUserPropertyKey.appsFlyerUserId,
        afId ?? '',
      );
      appsflyerSdk!.setCustomerUserId(qUser.qonversionId);
    }
  } catch (e) {
    debugPrint('❌ Qonversion Server Error: $e');
    if (e.toString().contains('InvalidCredentials')) {
      debugPrint('🚨 ERROR: Qonversion has REJECTED this Key/BundleID combination.');
      debugPrint('👉 Please ask the client to verify the Project Key and if the App is added to Qonversion Dashboard.');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
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
                    'Never Have I Ever',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme(),
                darkTheme: AppTheme.darkTheme(),
                themeMode: ThemeMode.light,
                locale: state is SettingsLoaded
                    ? _localeFromCode(state.language)
                    : null,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: AppRouter.router,
              );
            },
          ),
        );
      },
    );
  }

  Locale _localeFromCode(String code) {
    if (code == 'pt_BR') return const Locale('pt', 'BR');
    return Locale(code);
  }
}

Future<void> _initializeAppsflyer() async {
  final devKey = AppSecrets.appsflyerDevKey.trim();
  final appId = AppSecrets.appsflyerAppId.trim();
  if (devKey.isEmpty || appId.isEmpty) return;

  try {
    final options = AppsFlyerOptions(
      afDevKey: devKey,
      appId: appId,
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
    debugPrint('❌ AppsFlyer failed: $e');
  }
}
