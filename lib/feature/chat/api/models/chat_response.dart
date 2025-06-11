import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_response.freezed.dart';
part 'chat_response.g.dart';

@freezed
abstract class ChatResponse with _$ChatResponse {
  const factory ChatResponse({required String reply}) = _ChatResponse;

  factory ChatResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseFromJson(json);
}
