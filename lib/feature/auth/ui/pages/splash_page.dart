import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nexora/feature/auth/repository/auth_repository.dart';
import 'package:nexora/injector.dart';

import '../../../../core/config/routes/app_routes.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthRepository _authRepository = getIt<AuthRepository>();

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final hasToken = await _authRepository.hasToken();

    if (hasToken) {
      // User has a token, navigate to chat screen
      AutoRouter.of(
        context,
      ).pushAndPopUntil(ChatViewRoute(), predicate: (route) => false);
    } else {
      // No token, navigate to login screen
      AutoRouter.of(
        context,
      ).pushAndPopUntil(LoginRoute(), predicate: (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 124, 58, 237),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/logo.png',
              height: 150,
              width: 150,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: const Text(
                'v1.0.0',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
