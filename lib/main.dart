import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'firebase_options.dart';
import 'core/config/env_config.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'core/services/firebase_service.dart';
import 'core/services/amplitude_service.dart';
import 'core/services/sentry_service.dart';
import 'features/settings/bloc/settings_bloc.dart';
import 'features/settings/bloc/settings_event.dart';
import 'features/settings/bloc/settings_state.dart';
import 'l10n/app_localizations.dart';

void main() async {
  // Initialize Sentry and wrap the app
  await SentryService.initialize(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Load environment variables
    await EnvConfig.initialize();
    
    // Validate environment configuration
    EnvConfig.validateConfig();

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Firebase services (Analytics, Crashlytics, FCM)
    await FirebaseService().initialize();

    // Initialize Amplitude
    await AmplitudeService().initialize();

    // Initialize Qonversion SDK
    final config = QonversionConfigBuilder(
      EnvConfig.qonversionProjectKey,
      QLaunchMode.subscriptionManagement,
    ).build();
    Qonversion.initialize(config);

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
                    AppLocalizations.of(context)!.main_menu_title,
                debugShowCheckedModeBanner: false,

                // Theme
                theme: AppTheme.lightTheme(),
                darkTheme: AppTheme.darkTheme(),
                themeMode: ThemeMode.light,

                // Localization
                locale: state is SettingsLoaded
                    ? Locale(state.language)
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
}
