import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexora/feature/auth/repository/auth_repository.dart';
import 'package:nexora/injector.dart';

import '../../../../core/config/routes/app_routes.dart';
import '../../../../core/common/logger/app_logger.dart';

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

    // Initialize connectivity service for testing
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      logger.i('🚀 [SPLASH] Initializing connectivity service for testing');
    });
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
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/splash_bg.png',
              height: ScreenUtil().screenHeight,
              width: ScreenUtil().screenWidth,
              fit: BoxFit.cover,
            ),
          ),
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
