import 'package:injectable/injectable.dart';
import '../../../core/common/storage/token_service.dart';
import '../../../core/common/logger/app_logger.dart';
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
      // Also save the user email for avatar generation
      await _tokenService.saveUserEmail(email);

      // Save the user's full name if available in the response
      if (response.containsKey('user') &&
          response['user'] is Map<String, dynamic>) {
        final user = response['user'] as Map<String, dynamic>;
        if (user.containsKey('full_name') && user['full_name'] is String) {
          await _tokenService.saveUserFullName(user['full_name']);
        }
      }
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
      logger.e('Logout API error: $e', e);
    } finally {
      // Always delete the token and user data locally
      await _tokenService.deleteToken();
      await _tokenService.deleteUserEmail();
      await _tokenService.deleteUserFullName();
    }
  }
}
