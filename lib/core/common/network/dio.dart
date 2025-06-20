import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'auth_interceptor.dart';

@module
abstract class DioProvider {
  @lazySingleton
  Dio dio(AuthInterceptor authInterceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://nexora.msanjana.com/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 200),
        contentType: 'application/json',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        followRedirects: false,
        validateStatus: (status) => status! < 500,
      ),
    );

    dio.interceptors.add(authInterceptor);
    return dio;
  }
}
