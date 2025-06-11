import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'models/login_request.dart';
part 'auth_api.g.dart';

@injectable
@RestApi(baseUrl: "https://yourapi.com/")
abstract class AuthAPI {
  @factoryMethod
  factory AuthAPI(Dio dio, {String baseUrl}) = _AuthAPI;
  @POST('/api/auth/login')
  Future<dynamic> login({@Body() required LoginRequest loginRequest});
  @POST('/api/auth/verify')
  Future<dynamic> verifyOtp({@Body() required LoginRequest loginRequest});
}
