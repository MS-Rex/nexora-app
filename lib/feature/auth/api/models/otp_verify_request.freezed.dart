// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_verify_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OtpVerifyRequest {

 String get email; int get code;
/// Create a copy of OtpVerifyRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpVerifyRequestCopyWith<OtpVerifyRequest> get copyWith => _$OtpVerifyRequestCopyWithImpl<OtpVerifyRequest>(this as OtpVerifyRequest, _$identity);

  /// Serializes this OtpVerifyRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpVerifyRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,code);

@override
String toString() {
  return 'OtpVerifyRequest(email: $email, code: $code)';
}


}

/// @nodoc
abstract mixin class $OtpVerifyRequestCopyWith<$Res>  {
  factory $OtpVerifyRequestCopyWith(OtpVerifyRequest value, $Res Function(OtpVerifyRequest) _then) = _$OtpVerifyRequestCopyWithImpl;
@useResult
$Res call({
 String email, int code
});




}
/// @nodoc
class _$OtpVerifyRequestCopyWithImpl<$Res>
    implements $OtpVerifyRequestCopyWith<$Res> {
  _$OtpVerifyRequestCopyWithImpl(this._self, this._then);

  final OtpVerifyRequest _self;
  final $Res Function(OtpVerifyRequest) _then;

/// Create a copy of OtpVerifyRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? code = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _OtpVerifyRequest implements OtpVerifyRequest {
  const _OtpVerifyRequest({required this.email, required this.code});
  factory _OtpVerifyRequest.fromJson(Map<String, dynamic> json) => _$OtpVerifyRequestFromJson(json);

@override final  String email;
@override final  int code;

/// Create a copy of OtpVerifyRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpVerifyRequestCopyWith<_OtpVerifyRequest> get copyWith => __$OtpVerifyRequestCopyWithImpl<_OtpVerifyRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OtpVerifyRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpVerifyRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,code);

@override
String toString() {
  return 'OtpVerifyRequest(email: $email, code: $code)';
}


}

/// @nodoc
abstract mixin class _$OtpVerifyRequestCopyWith<$Res> implements $OtpVerifyRequestCopyWith<$Res> {
  factory _$OtpVerifyRequestCopyWith(_OtpVerifyRequest value, $Res Function(_OtpVerifyRequest) _then) = __$OtpVerifyRequestCopyWithImpl;
@override @useResult
$Res call({
 String email, int code
});




}
/// @nodoc
class __$OtpVerifyRequestCopyWithImpl<$Res>
    implements _$OtpVerifyRequestCopyWith<$Res> {
  __$OtpVerifyRequestCopyWithImpl(this._self, this._then);

  final _OtpVerifyRequest _self;
  final $Res Function(_OtpVerifyRequest) _then;

/// Create a copy of OtpVerifyRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? code = null,}) {
  return _then(_OtpVerifyRequest(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
