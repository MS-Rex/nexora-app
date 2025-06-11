import 'package:injectable/injectable.dart';
import '../api/chat_api.dart';
import '../api/models/chat_request.dart';

abstract class ChatRepository {
  Future<String> sendMessage(String message);
}

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatApi _chatApi;

  ChatRepositoryImpl(this._chatApi);

  @override
  Future<String> sendMessage(String message) async {
    final response = await _chatApi.sendMessage(ChatRequest(message: message));
    return response.reply;
  }
}
