// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatRequest _$ChatRequestFromJson(Map<String, dynamic> json) => _ChatRequest(
  message: json['message'] as String,
  sessionId: json['session_id'] as String?,
);

Map<String, dynamic> _$ChatRequestToJson(_ChatRequest instance) =>
    <String, dynamic>{
      'message': instance.message,
      'session_id': instance.sessionId,
    };
