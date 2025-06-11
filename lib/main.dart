import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexora/injector.dart';
import 'core/config/routes/app_routes.dart';

void main() async {
  // debugPrintGestureArenaDiagnostics = true;
  configureDependencies();
  debugProfileBuildsEnabled = true;
  runApp(const MyApp());
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
