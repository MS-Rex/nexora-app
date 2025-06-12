import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../repository/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';
part 'chat_bloc.freezed.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;

  ChatBloc(this._chatRepository) : super(const ChatState.initial()) {
    on<_SendMessage>(_onSendMessage);
  }

  Future<void> _onSendMessage(
    _SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatState.loading());

    try {
      final response = await _chatRepository.sendMessage(event.message);
      emit(ChatState.success(response.response));
    } catch (e) {
      emit(ChatState.failure(e.toString()));
    }
  }
}
