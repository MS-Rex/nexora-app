// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_routes.dart';

/// generated route for
/// [ChatHistoryPage]
class ChatHistoryRoute extends PageRouteInfo<void> {
  const ChatHistoryRoute({List<PageRouteInfo>? children})
    : super(ChatHistoryRoute.name, initialChildren: children);

  static const String name = 'ChatHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChatHistoryPage();
    },
  );
}

/// generated route for
/// [ChatViewPage]
class ChatViewRoute extends PageRouteInfo<void> {
  const ChatViewRoute({List<PageRouteInfo>? children})
    : super(ChatViewRoute.name, initialChildren: children);

  static const String name = 'ChatViewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChatViewPage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [OtpVerifyPage]
class OtpVerifyRoute extends PageRouteInfo<void> {
  const OtpVerifyRoute({List<PageRouteInfo>? children})
    : super(OtpVerifyRoute.name, initialChildren: children);

  static const String name = 'OtpVerifyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OtpVerifyPage();
    },
  );
}

/// generated route for
/// [SignUpPage]
class SignUpRoute extends PageRouteInfo<SignUpRouteArgs> {
  SignUpRoute({Key? key, List<PageRouteInfo>? children})
    : super(
        SignUpRoute.name,
        args: SignUpRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'SignUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignUpRouteArgs>(
        orElse: () => const SignUpRouteArgs(),
      );
      return SignUpPage(key: args.key);
    },
  );
}

class SignUpRouteArgs {
  const SignUpRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'SignUpRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SignUpRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}

/// generated route for
/// [VoiceChatScreen]
class VoiceChatRoute extends PageRouteInfo<void> {
  const VoiceChatRoute({List<PageRouteInfo>? children})
    : super(VoiceChatRoute.name, initialChildren: children);

  static const String name = 'VoiceChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const VoiceChatScreen();
    },
  );
}

/// generated route for
/// [VoiceChatScreenRefactored]
class VoiceChatRouteRefactored extends PageRouteInfo<void> {
  const VoiceChatRouteRefactored({List<PageRouteInfo>? children})
    : super(VoiceChatRouteRefactored.name, initialChildren: children);

  static const String name = 'VoiceChatRouteRefactored';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const VoiceChatScreenRefactored();
    },
  );
}
