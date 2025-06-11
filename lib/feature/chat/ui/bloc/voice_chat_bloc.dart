import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../services/voice_chat_service.dart';

part 'voice_chat_event.dart';
part 'voice_chat_state.dart';

@injectable
class VoiceChatBloc extends Bloc<VoiceChatEvent, VoiceChatState> {
  final VoiceChatService _voiceChatService;
  StreamSubscription? _serviceSubscription;

  VoiceChatBloc(this._voiceChatService) : super(const VoiceChatState()) {
    // Event handlers
    on<VoiceChatInitialize>(_onInitialize);
    on<VoiceChatConnectWebSocket>(_onConnectWebSocket);
    on<VoiceChatDisconnectWebSocket>(_onDisconnectWebSocket);
    on<VoiceChatStartListening>(_onStartListening);
    on<VoiceChatStopListening>(_onStopListening);
    on<VoiceChatSendTestMessage>(_onSendTestMessage);
    on<VoiceChatUpdateStatus>(_onUpdateStatus);
    on<VoiceChatSetAISpeaking>(_onSetAISpeaking);
    on<VoiceChatSetConnected>(_onSetConnected);
    on<VoiceChatSetMicPermission>(_onSetMicPermission);
    on<VoiceChatHandleWebSocketMessage>(_onHandleWebSocketMessage);
    on<VoiceChatHandleError>(_onHandleError);

    // Listen to service state changes
    _serviceSubscription = _voiceChatService.stateStream.listen((serviceState) {
      add(VoiceChatSetConnected(serviceState.isConnected));
      add(VoiceChatSetMicPermission(serviceState.hasMicPermission));
      add(VoiceChatUpdateStatus(serviceState.statusText));
      add(VoiceChatSetAISpeaking(serviceState.isAISpeaking));

      if (serviceState.error != null) {
        add(VoiceChatHandleError(serviceState.error!));
      }
    });
  }

  Future<void> _onInitialize(
    VoiceChatInitialize event,
    Emitter<VoiceChatState> emit,
  ) async {
    await _voiceChatService.initialize();
  }

  Future<void> _onConnectWebSocket(
    VoiceChatConnectWebSocket event,
    Emitter<VoiceChatState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await _voiceChatService.connectWebSocket();
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _onDisconnectWebSocket(
    VoiceChatDisconnectWebSocket event,
    Emitter<VoiceChatState> emit,
  ) async {
    await _voiceChatService.disconnectWebSocket();
  }

  Future<void> _onStartListening(
    VoiceChatStartListening event,
    Emitter<VoiceChatState> emit,
  ) async {
    if (!state.hasMicPermission) {
      await _voiceChatService.checkMicPermission();
      return;
    }

    if (!state.isConnected) {
      await _voiceChatService.connectWebSocket();
    }

    if (state.isConnected) {
      await _voiceChatService.startRecording();
      emit(state.copyWith(isListening: true));
    }
  }

  Future<void> _onStopListening(
    VoiceChatStopListening event,
    Emitter<VoiceChatState> emit,
  ) async {
    await _voiceChatService.stopRecording();
    emit(state.copyWith(isListening: false));
  }

  Future<void> _onSendTestMessage(
    VoiceChatSendTestMessage event,
    Emitter<VoiceChatState> emit,
  ) async {
    await _voiceChatService.sendTestMessage();
  }

  void _onUpdateStatus(
    VoiceChatUpdateStatus event,
    Emitter<VoiceChatState> emit,
  ) {
    emit(state.copyWith(statusText: event.status));
  }

  void _onSetAISpeaking(
    VoiceChatSetAISpeaking event,
    Emitter<VoiceChatState> emit,
  ) {
    emit(state.copyWith(isAISpeaking: event.isSpeaking));
  }

  void _onSetConnected(
    VoiceChatSetConnected event,
    Emitter<VoiceChatState> emit,
  ) {
    emit(state.copyWith(isConnected: event.isConnected));
  }

  void _onSetMicPermission(
    VoiceChatSetMicPermission event,
    Emitter<VoiceChatState> emit,
  ) {
    emit(state.copyWith(hasMicPermission: event.hasPermission));
  }

  void _onHandleWebSocketMessage(
    VoiceChatHandleWebSocketMessage event,
    Emitter<VoiceChatState> emit,
  ) {
    _voiceChatService.handleWebSocketMessage(event.message);
  }

  void _onHandleError(
    VoiceChatHandleError event,
    Emitter<VoiceChatState> emit,
  ) {
    emit(state.copyWith(error: event.error));
  }

  @override
  Future<void> close() {
    _serviceSubscription?.cancel();
    _voiceChatService.dispose();
    return super.close();
  }
}
