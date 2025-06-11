import 'package:injectable/injectable.dart';

@lazySingleton
class TokenService {
  Future<String?> getToken() async {
    return 'your_token_here';
  }
}
