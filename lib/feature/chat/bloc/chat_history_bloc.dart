import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../api/models/chat_history.dart';
import '../repository/chat_repository.dart';

// Events
abstract class ChatHistoryEvent {}

class FetchChatHistory extends ChatHistoryEvent {}

// States
abstract class ChatHistoryState {}

class ChatHistoryInitial extends ChatHistoryState {}

class ChatHistoryLoading extends ChatHistoryState {}

class ChatHistoryLoaded extends ChatHistoryState {
  final List<ChatHistory> chatHistory;

  ChatHistoryLoaded(this.chatHistory);
}

class ChatHistoryError extends ChatHistoryState {
  final String message;

  ChatHistoryError(this.message);
}

// BLoC
@injectable
class ChatHistoryBloc extends Bloc<ChatHistoryEvent, ChatHistoryState> {
  final ChatRepository _chatRepository;

  ChatHistoryBloc(this._chatRepository) : super(ChatHistoryInitial()) {
    on<FetchChatHistory>(_onFetchChatHistory);
  }

  Future<void> _onFetchChatHistory(
    FetchChatHistory event,
    Emitter<ChatHistoryState> emit,
  ) async {
    emit(ChatHistoryLoading());
    try {
      final chatHistory = await _chatRepository.getChatHistory();
      emit(ChatHistoryLoaded(chatHistory));
    } catch (e) {
      emit(ChatHistoryError(e.toString()));
    }
  }
}
