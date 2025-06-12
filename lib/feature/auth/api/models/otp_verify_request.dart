import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_verify_request.freezed.dart';
part 'otp_verify_request.g.dart';

@freezed
abstract class OtpVerifyRequest with _$OtpVerifyRequest {
  const factory OtpVerifyRequest({required String email, required int code}) =
      _OtpVerifyRequest;

  factory OtpVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyRequestFromJson(json);
}
