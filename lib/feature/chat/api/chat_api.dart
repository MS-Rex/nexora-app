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
  Future<ChatHistoryResponse> getChatHistory();

  @GET("api/mobile-api/chat/history/get/{session_id}")
  Future<List<ChatMessage>> getChatBySessionId(
    @Path("session_id") String sessionId,
  );
}

class ChatMessage {
  final String text;
  final bool isUser;
  final String? timestamp;

  ChatMessage({required this.text, required this.isUser, this.timestamp});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'] ?? '',
      isUser: json['isUser'] ?? false,
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'isUser': isUser, 'timestamp': timestamp};
  }
}
