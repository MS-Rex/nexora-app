import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../feature/auth/ui/pages/login_page.dart';
import '../../../feature/auth/ui/pages/otp_verify_page.dart';
import '../../../feature/auth/ui/pages/signup_page.dart';
import '../../../feature/auth/ui/pages/splash_page.dart';
import '../../../feature/chat/ui/pages/chat_history_page.dart';
import '../../../feature/chat/ui/pages/chat_screen.dart';
import '../../../feature/chat/ui/pages/voice_chat_screen.dart';
import '../../../feature/chat/ui/pages/voice_chat_screen_refactored.dart';

part 'app_routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: OtpVerifyRoute.page),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: ChatViewRoute.page),
    AutoRoute(page: VoiceChatRoute.page),
    AutoRoute(page: VoiceChatRouteRefactored.page),
    AutoRoute(page: ChatHistoryRoute.page),
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
