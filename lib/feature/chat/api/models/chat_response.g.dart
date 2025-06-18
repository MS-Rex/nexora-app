// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatResponse _$ChatResponseFromJson(Map<String, dynamic> json) => ChatResponse(
  response: json['message'] as String,
  agentName: json['agent_name'] as String? ?? '',
  intent: json['intent'] as String? ?? '',
  agentUsed: json['agent_used'] as String? ?? '',
  success: json['success'] as bool? ?? true,
  error: json['error'] as String?,
  timestamp: json['timestamp'] as String? ?? '',
  sessionId: json['session_id'] as String? ?? '',
);

Map<String, dynamic> _$ChatResponseToJson(ChatResponse instance) =>
    <String, dynamic>{
      'message': instance.response,
      'agent_name': instance.agentName,
      'intent': instance.intent,
      'agent_used': instance.agentUsed,
      'success': instance.success,
      'error': instance.error,
      'timestamp': instance.timestamp,
      'session_id': instance.sessionId,
    };
