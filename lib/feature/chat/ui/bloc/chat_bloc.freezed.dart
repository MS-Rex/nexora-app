// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatEvent {

 String get message;
/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatEventCopyWith<ChatEvent> get copyWith => _$ChatEventCopyWithImpl<ChatEvent>(this as ChatEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatEvent&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatEvent(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChatEventCopyWith<$Res>  {
  factory $ChatEventCopyWith(ChatEvent value, $Res Function(ChatEvent) _then) = _$ChatEventCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ChatEventCopyWithImpl<$Res>
    implements $ChatEventCopyWith<$Res> {
  _$ChatEventCopyWithImpl(this._self, this._then);

  final ChatEvent _self;
  final $Res Function(ChatEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _SendMessage implements ChatEvent {
  const _SendMessage(this.message);
  

@override final  String message;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendMessageCopyWith<_SendMessage> get copyWith => __$SendMessageCopyWithImpl<_SendMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendMessage&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatEvent.sendMessage(message: $message)';
}


}

/// @nodoc
abstract mixin class _$SendMessageCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory _$SendMessageCopyWith(_SendMessage value, $Res Function(_SendMessage) _then) = __$SendMessageCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$SendMessageCopyWithImpl<$Res>
    implements _$SendMessageCopyWith<$Res> {
  __$SendMessageCopyWithImpl(this._self, this._then);

  final _SendMessage _self;
  final $Res Function(_SendMessage) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_SendMessage(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ChatState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatState()';
}


}

/// @nodoc
class $ChatStateCopyWith<$Res>  {
$ChatStateCopyWith(ChatState _, $Res Function(ChatState) __);
}


/// @nodoc


class _Initial implements ChatState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatState.initial()';
}


}




/// @nodoc


class _Loading implements ChatState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatState.loading()';
}


}




/// @nodoc


class _Success implements ChatState {
  const _Success(this.reply);
  

 final  String reply;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.reply, reply) || other.reply == reply));
}


@override
int get hashCode => Object.hash(runtimeType,reply);

@override
String toString() {
  return 'ChatState.success(reply: $reply)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 String reply
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reply = null,}) {
  return _then(_Success(
null == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Failure implements ChatState {
  const _Failure(this.error);
  

 final  String error;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailureCopyWith<_Failure> get copyWith => __$FailureCopyWithImpl<_Failure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'ChatState.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory _$FailureCopyWith(_Failure value, $Res Function(_Failure) _then) = __$FailureCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$FailureCopyWithImpl<$Res>
    implements _$FailureCopyWith<$Res> {
  __$FailureCopyWithImpl(this._self, this._then);

  final _Failure _self;
  final $Res Function(_Failure) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_Failure(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
