// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verify_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OtpVerifyRequest _$OtpVerifyRequestFromJson(Map<String, dynamic> json) =>
    _OtpVerifyRequest(
      email: json['email'] as String,
      code: (json['code'] as num).toInt(),
    );

Map<String, dynamic> _$OtpVerifyRequestToJson(_OtpVerifyRequest instance) =>
    <String, dynamic>{'email': instance.email, 'code': instance.code};
