import 'package:injectable/injectable.dart';
import '../api/chat_api.dart';
import '../api/models/chat_request.dart';
import '../api/models/chat_response.dart';
import '../api/models/chat_history.dart';

abstract class ChatRepository {
  Future<ChatResponse> sendMessage(String message, {String? sessionId});
  Future<List<ChatHistory>> getChatHistory();
  Future<List<ChatMessage>> getChatBySessionId(String sessionId);
}

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatApi _chatApi;

  ChatRepositoryImpl(this._chatApi);

  @override
  Future<ChatResponse> sendMessage(String message, {String? sessionId}) async {
    final response = await _chatApi.sendMessage(
      ChatRequest(message: message, sessionId: sessionId ?? ""),
    );
    return response;
  }

  @override
  Future<List<ChatHistory>> getChatHistory() async {
    final response = await _chatApi.getChatHistory();
    return response;
  }

  @override
  Future<List<ChatMessage>> getChatBySessionId(String sessionId) async {
    return await _chatApi.getChatBySessionId(sessionId);
  }
}
