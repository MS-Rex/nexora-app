part of 'chat_bloc.dart';

@freezed
abstract class ChatEvent with _$ChatEvent {
  const factory ChatEvent.sendMessage(String message, {String? sessionId}) =
      _SendMessage;
  const factory ChatEvent.loadChatHistory(String sessionId) = _LoadChatHistory;
}
