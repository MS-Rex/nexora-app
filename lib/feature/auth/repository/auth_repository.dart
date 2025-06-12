import 'package:injectable/injectable.dart';
import '../../../core/common/storage/token_service.dart';
import '../api/auth_api.dart';
import '../api/models/login_request.dart';
import '../api/models/otp_verify_request.dart';

abstract class AuthRepository {
  Future<dynamic> login(String email);
  Future<dynamic> verifyOtp(String email, int code);
  Future<bool> hasToken();
  Future<void> logout();
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthAPI _authApi;
  final TokenService _tokenService;

  AuthRepositoryImpl(this._authApi, this._tokenService);

  @override
  Future<dynamic> login(String email) async {
    final response = await _authApi.login(
      loginRequest: LoginRequest(email: email),
    );

    // Check if the response contains an error message
    if (response is Map<String, dynamic> && response.containsKey('error')) {
      throw Exception(response['error']);
    }

    return response;
  }

  @override
  Future<dynamic> verifyOtp(String email, int code) async {
    final response = await _authApi.verifyOtp(
      verifyRequest: OtpVerifyRequest(email: email, code: code),
    );

    // Check if the response contains an error message
    if (response is Map<String, dynamic> && response.containsKey('error')) {
      throw Exception(response['error']);
    }

    // Save the token if available in the response
    if (response is Map<String, dynamic> && response.containsKey('token')) {
      await _tokenService.saveToken(response['token']);
    }

    return response;
  }

  @override
  Future<bool> hasToken() async {
    return await _tokenService.hasToken();
  }

  @override
  Future<void> logout() async {
    try {
      // Call logout API endpoint first
      await _authApi.logout();
    } catch (e) {
      // If API call fails, still proceed with token deletion
      print('Logout API error: $e');
    } finally {
      // Always delete the token locally
      await _tokenService.deleteToken();
    }
  }
}
