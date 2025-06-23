import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TokenService {
  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  static const String _userFullNameKey = 'user_full_name';
  final _secureStorage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getUserEmail() async {
    return await _secureStorage.read(key: _userEmailKey);
  }

  Future<void> saveUserEmail(String email) async {
    await _secureStorage.write(key: _userEmailKey, value: email);
  }

  Future<void> deleteUserEmail() async {
    await _secureStorage.delete(key: _userEmailKey);
  }

  Future<String?> getUserFullName() async {
    return await _secureStorage.read(key: _userFullNameKey);
  }

  Future<void> saveUserFullName(String fullName) async {
    await _secureStorage.write(key: _userFullNameKey, value: fullName);
  }

  Future<void> deleteUserFullName() async {
    await _secureStorage.delete(key: _userFullNameKey);
  }

  /// Gets the first name from the stored full name
  Future<String?> getUserFirstName() async {
    final fullName = await getUserFullName();
    if (fullName != null && fullName.isNotEmpty) {
      return fullName.split(' ').first;
    }
    return null;
  }
}
