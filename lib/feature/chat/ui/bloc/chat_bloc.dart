import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../repository/chat_repository.dart';
import '../../api/chat_api.dart';

part 'chat_event.dart';
part 'chat_state.dart';
part 'chat_bloc.freezed.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;

  ChatBloc(this._chatRepository) : super(const ChatState.initial()) {
    on<_SendMessage>(_onSendMessage);
    on<_LoadChatHistory>(_onLoadChatHistory);
  }

  Future<void> _onSendMessage(
    _SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatState.loading());

    try {
      final response = await _chatRepository.sendMessage(
        event.message,
        sessionId: event.sessionId,
      );
      emit(ChatState.success(response.response));
    } catch (e) {
      emit(ChatState.failure(e.toString()));
    }
  }

  Future<void> _onLoadChatHistory(
    _LoadChatHistory event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatState.chatHistoryLoading());

    try {
      final messages = await _chatRepository.getChatBySessionId(
        event.sessionId,
      );
      emit(ChatState.chatHistoryLoaded(messages));
    } catch (e) {
      emit(ChatState.failure(e.toString()));
    }
  }
}
