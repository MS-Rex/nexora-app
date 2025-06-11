import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_request.freezed.dart';
part 'chat_request.g.dart';

@freezed
abstract class ChatRequest with _$ChatRequest {
  const factory ChatRequest({required String message}) = _ChatRequest;

  factory ChatRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatRequestFromJson(json);
}
