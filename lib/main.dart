import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexora/injector.dart';
import 'core/config/routes/app_routes.dart';
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
  debugProfileBuildsEnabled = true;
  await SentryFlutter.init((options) {
    options.dsn = dotenv.env['SENTRY_DSN'] ?? '';
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 1.0;
    // The sampling rate for profiling is relative to tracesSampleRate
    // Setting to 1.0 will profile 100% of sampled transactions:
    options.profilesSampleRate = 1.0;
  }, appRunner: () => runApp(SentryWidget(child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nexora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          primary: const Color(0xFF6366F1),
        ),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
      routerConfig: appRouter.config(),
    );
  }
}
