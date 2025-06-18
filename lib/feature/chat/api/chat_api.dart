import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'models/chat_request.dart';
import 'models/chat_response.dart';
import 'models/chat_history.dart';
part 'chat_api.g.dart';

@injectable
@RestApi()
abstract class ChatApi {
  @factoryMethod
  factory ChatApi(Dio dio, {String baseUrl}) = _ChatApi;

  @POST("api/mobile-api/message/send")
  Future<ChatResponse> sendMessage(@Body() ChatRequest request);

  @GET("api/mobile-api/chat/history")
  Future<List<ChatHistory>> getChatHistory();

  @GET("api/mobile-api/chat/history/get/{session_id}")
  Future<List<ChatMessage>> getChatBySessionId(
    @Path("session_id") String sessionId,
  );
}

class ChatMessage {
  final String text;
  final bool isUser;
  final String? timestamp;
  final String? id;
  final String? agentName;
  final String? agentUsed;
  final String? intent;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.timestamp,
    this.id,
    this.agentName,
    this.agentUsed,
    this.intent,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['content'] ?? '',
      isUser: json['role'] == 'user',
      timestamp: json['created_at'],
      id: json['id'],
      agentName: json['agent_name'],
      agentUsed: json['agent_used'],
      intent: json['intent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': text,
      'role': isUser ? 'user' : 'assistant',
      'created_at': timestamp,
      'id': id,
      'agent_name': agentName,
      'agent_used': agentUsed,
      'intent': intent,
    };
  }
}
