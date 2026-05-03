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
  // Fix Sentry warning by using its specialized binding
  SentryWidgetsFlutterBinding.ensureInitialized();

  // Log Bundle ID to verify mismatch
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  debugPrint('----------------------------------------------');
  debugPrint('🔍 CURRENT APP BUNDLE ID: ${packageInfo.packageName}');
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
        debugPrint('🚀 Qonversion initialized');
        
        // Validation check after a short delay
        Future.delayed(const Duration(seconds: 2), () async {
          try {
            final qUser = await Qonversion.getSharedInstance().userInfo();
            debugPrint('✅ Qonversion Connected! ID: ${qUser.qonversionId}');
          } catch (e) {
            debugPrint('❌ Qonversion Validation Failed: $e');
            if (e.toString().contains('InvalidCredentials')) {
               debugPrint('🚨 ALERT: Qonversion key is REJECTED. This means the Bundle ID above does not match Qonversion Dashboard.');
            }
          }
        });
        
        await _stitchQonversionAndAppsflyer();
      } catch (e) {
        debugPrint('❌ Qonversion error: $e');
      }
    }

    await AnalyticsService().logAppOpened();
    runApp(const MyApp());
  });
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

Future<void> _stitchQonversionAndAppsflyer() async {
  try {
    final sdk = appsflyerSdk;
    if (sdk != null) {
      final afId = await sdk.getAppsFlyerUID();
      Qonversion.getSharedInstance().setUserProperty(
        QUserPropertyKey.appsFlyerUserId,
        afId ?? '',
      );
    }
  } catch (e) {
    debugPrint('❌ Stitch failed: $e');
  }
}
