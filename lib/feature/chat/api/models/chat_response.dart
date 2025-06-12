import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_response.freezed.dart';
part 'chat_response.g.dart';

@freezed
abstract class ChatResponse with _$ChatResponse {
  const factory ChatResponse({
    required String response,
    @JsonKey(name: 'agent_name') required String agentName,
    required String intent,
    @JsonKey(name: 'agent_used') required String agentUsed,
    required bool success,
    String? error,
    required String timestamp,
    @JsonKey(name: 'session_id') required String sessionId,
  }) = _ChatResponse;

  factory ChatResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseFromJson(json);
}
