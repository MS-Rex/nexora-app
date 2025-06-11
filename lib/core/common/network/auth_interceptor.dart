import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../storage/token_service.dart';

@lazySingleton
class AuthInterceptor extends Interceptor {
  final TokenService tokenService;

  AuthInterceptor(this.tokenService);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenService.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}
