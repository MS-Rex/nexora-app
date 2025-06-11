import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'auth_interceptor.dart';

@module
abstract class DioProvider {
  @lazySingleton
  Dio dio(AuthInterceptor authInterceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(authInterceptor);
    return dio;
  }
}
