import 'package:json_annotation/json_annotation.dart';

part 'chat_response.g.dart';

@JsonSerializable()
class ChatResponse {
  @JsonKey(name: 'message')
  final String response;

  @JsonKey(name: 'agent_name', defaultValue: '')
  final String agentName;

  @JsonKey(defaultValue: '')
  final String intent;

  @JsonKey(name: 'agent_used', defaultValue: '')
  final String agentUsed;

  @JsonKey(defaultValue: true)
  final bool success;

  final String? error;

  @JsonKey(defaultValue: '')
  final String timestamp;

  @JsonKey(name: 'session_id', defaultValue: '')
  final String sessionId;

  ChatResponse({
    required this.response,
    this.agentName = '',
    this.intent = '',
    this.agentUsed = '',
    this.success = true,
    this.error,
    this.timestamp = '',
    this.sessionId = '',
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ChatResponseToJson(this);
}
