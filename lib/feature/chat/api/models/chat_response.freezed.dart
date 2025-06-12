// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatResponse {

 String get response;@JsonKey(name: 'agent_name') String get agentName; String get intent;@JsonKey(name: 'agent_used') String get agentUsed; bool get success; String? get error; String get timestamp;@JsonKey(name: 'session_id') String get sessionId;
/// Create a copy of ChatResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatResponseCopyWith<ChatResponse> get copyWith => _$ChatResponseCopyWithImpl<ChatResponse>(this as ChatResponse, _$identity);

  /// Serializes this ChatResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatResponse&&(identical(other.response, response) || other.response == response)&&(identical(other.agentName, agentName) || other.agentName == agentName)&&(identical(other.intent, intent) || other.intent == intent)&&(identical(other.agentUsed, agentUsed) || other.agentUsed == agentUsed)&&(identical(other.success, success) || other.success == success)&&(identical(other.error, error) || other.error == error)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,response,agentName,intent,agentUsed,success,error,timestamp,sessionId);

@override
String toString() {
  return 'ChatResponse(response: $response, agentName: $agentName, intent: $intent, agentUsed: $agentUsed, success: $success, error: $error, timestamp: $timestamp, sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class $ChatResponseCopyWith<$Res>  {
  factory $ChatResponseCopyWith(ChatResponse value, $Res Function(ChatResponse) _then) = _$ChatResponseCopyWithImpl;
@useResult
$Res call({
 String response,@JsonKey(name: 'agent_name') String agentName, String intent,@JsonKey(name: 'agent_used') String agentUsed, bool success, String? error, String timestamp,@JsonKey(name: 'session_id') String sessionId
});




}
/// @nodoc
class _$ChatResponseCopyWithImpl<$Res>
    implements $ChatResponseCopyWith<$Res> {
  _$ChatResponseCopyWithImpl(this._self, this._then);

  final ChatResponse _self;
  final $Res Function(ChatResponse) _then;

/// Create a copy of ChatResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? response = null,Object? agentName = null,Object? intent = null,Object? agentUsed = null,Object? success = null,Object? error = freezed,Object? timestamp = null,Object? sessionId = null,}) {
  return _then(_self.copyWith(
response: null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as String,agentName: null == agentName ? _self.agentName : agentName // ignore: cast_nullable_to_non_nullable
as String,intent: null == intent ? _self.intent : intent // ignore: cast_nullable_to_non_nullable
as String,agentUsed: null == agentUsed ? _self.agentUsed : agentUsed // ignore: cast_nullable_to_non_nullable
as String,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ChatResponse implements ChatResponse {
  const _ChatResponse({required this.response, @JsonKey(name: 'agent_name') required this.agentName, required this.intent, @JsonKey(name: 'agent_used') required this.agentUsed, required this.success, this.error, required this.timestamp, @JsonKey(name: 'session_id') required this.sessionId});
  factory _ChatResponse.fromJson(Map<String, dynamic> json) => _$ChatResponseFromJson(json);

@override final  String response;
@override@JsonKey(name: 'agent_name') final  String agentName;
@override final  String intent;
@override@JsonKey(name: 'agent_used') final  String agentUsed;
@override final  bool success;
@override final  String? error;
@override final  String timestamp;
@override@JsonKey(name: 'session_id') final  String sessionId;

/// Create a copy of ChatResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatResponseCopyWith<_ChatResponse> get copyWith => __$ChatResponseCopyWithImpl<_ChatResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatResponse&&(identical(other.response, response) || other.response == response)&&(identical(other.agentName, agentName) || other.agentName == agentName)&&(identical(other.intent, intent) || other.intent == intent)&&(identical(other.agentUsed, agentUsed) || other.agentUsed == agentUsed)&&(identical(other.success, success) || other.success == success)&&(identical(other.error, error) || other.error == error)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,response,agentName,intent,agentUsed,success,error,timestamp,sessionId);

@override
String toString() {
  return 'ChatResponse(response: $response, agentName: $agentName, intent: $intent, agentUsed: $agentUsed, success: $success, error: $error, timestamp: $timestamp, sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class _$ChatResponseCopyWith<$Res> implements $ChatResponseCopyWith<$Res> {
  factory _$ChatResponseCopyWith(_ChatResponse value, $Res Function(_ChatResponse) _then) = __$ChatResponseCopyWithImpl;
@override @useResult
$Res call({
 String response,@JsonKey(name: 'agent_name') String agentName, String intent,@JsonKey(name: 'agent_used') String agentUsed, bool success, String? error, String timestamp,@JsonKey(name: 'session_id') String sessionId
});




}
/// @nodoc
class __$ChatResponseCopyWithImpl<$Res>
    implements _$ChatResponseCopyWith<$Res> {
  __$ChatResponseCopyWithImpl(this._self, this._then);

  final _ChatResponse _self;
  final $Res Function(_ChatResponse) _then;

/// Create a copy of ChatResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? response = null,Object? agentName = null,Object? intent = null,Object? agentUsed = null,Object? success = null,Object? error = freezed,Object? timestamp = null,Object? sessionId = null,}) {
  return _then(_ChatResponse(
response: null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as String,agentName: null == agentName ? _self.agentName : agentName // ignore: cast_nullable_to_non_nullable
as String,intent: null == intent ? _self.intent : intent // ignore: cast_nullable_to_non_nullable
as String,agentUsed: null == agentUsed ? _self.agentUsed : agentUsed // ignore: cast_nullable_to_non_nullable
as String,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
