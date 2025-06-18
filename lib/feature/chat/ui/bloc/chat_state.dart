part of 'chat_bloc.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = _Initial;
  const factory ChatState.loading() = _Loading;
  const factory ChatState.success(String reply) = _Success;
  const factory ChatState.failure(String error) = _Failure;
  const factory ChatState.chatHistoryLoaded(List<ChatMessage> messages) =
      _ChatHistoryLoaded;
  const factory ChatState.chatHistoryLoading() = _ChatHistoryLoading;
}
