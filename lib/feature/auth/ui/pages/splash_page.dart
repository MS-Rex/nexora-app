import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/routes/app_routes.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      AutoRouter.of(
        context,
      ).pushAndPopUntil(LoginRoute(), predicate: (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 124, 58, 237),
      body: Center(
        child: Image.asset(
          'assets/images/logo.png', // Add your logo image in the assets folder
          height: 150,
          width: 150,
        ),
      ),
    );
  }
}
