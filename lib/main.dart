import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexora/injector.dart';
import 'core/config/routes/app_routes.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/localization_service.dart';
import 'core/common/logger/app_logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  if (!getIt.isRegistered<String>()) {
    getIt.registerSingleton<String>(baseUrl);
  }
  configureDependencies();

  // Initialize localization service
  final localizationService = getIt<LocalizationService>();
  await localizationService.init();

  // debugProfileBuildsEnabled = true; // Deprecated - use DevTools instead
  await SentryFlutter.init((options) {
    options.dsn = dotenv.env['SENTRY_DSN'] ?? '';
    options.tracesSampleRate = 1.0;
    options.profilesSampleRate = 1.0;
  }, appRunner: () => runApp(SentryWidget(child: const MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final appRouter = AppRouter();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final LocalizationService _localizationService;

  @override
  void initState() {
    super.initState();
    _localizationService = getIt<LocalizationService>();

    // Initialize connectivity service after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      logger.i('🚀 Initializing connectivity service');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_localizationService.isInitialized) {
      return MaterialApp(
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return ListenableBuilder(
      listenable: _localizationService,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Nexora',
          debugShowCheckedModeBanner: false,
          locale: _localizationService.currentLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6366F1),
              primary: const Color(0xFF6366F1),
            ),
            textTheme: GoogleFonts.interTextTheme(),
            useMaterial3: true,
          ),
          routerConfig: MyApp.appRouter.config(),
        );
      },
    );
  }
}
