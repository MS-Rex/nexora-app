import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'models/login_request.dart';
import 'models/otp_verify_request.dart';
part 'auth_api.g.dart';

@injectable
@RestApi()
abstract class AuthAPI {
  @factoryMethod
  factory AuthAPI(Dio dio, {String baseUrl}) = _AuthAPI;

  @POST('api/mobile-api/login/request')
  Future<dynamic> login({@Body() required LoginRequest loginRequest});

  @POST('api/mobile-api/verify-otp')
  Future<dynamic> verifyOtp({@Body() required OtpVerifyRequest verifyRequest});

  @POST('api/mobile-api/logout')
  Future<dynamic> logout();
}
