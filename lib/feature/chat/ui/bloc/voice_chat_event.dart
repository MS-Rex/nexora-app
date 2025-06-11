part of 'voice_chat_bloc.dart';

abstract class VoiceChatEvent {}

class VoiceChatInitialize extends VoiceChatEvent {}

class VoiceChatConnectWebSocket extends VoiceChatEvent {}

class VoiceChatDisconnectWebSocket extends VoiceChatEvent {}

class VoiceChatStartListening extends VoiceChatEvent {}

class VoiceChatStopListening extends VoiceChatEvent {}

class VoiceChatSendTestMessage extends VoiceChatEvent {}

class VoiceChatUpdateStatus extends VoiceChatEvent {
  final String status;
  VoiceChatUpdateStatus(this.status);
}

class VoiceChatSetAISpeaking extends VoiceChatEvent {
  final bool isSpeaking;
  VoiceChatSetAISpeaking(this.isSpeaking);
}

class VoiceChatSetConnected extends VoiceChatEvent {
  final bool isConnected;
  VoiceChatSetConnected(this.isConnected);
}

class VoiceChatSetMicPermission extends VoiceChatEvent {
  final bool hasPermission;
  VoiceChatSetMicPermission(this.hasPermission);
}

class VoiceChatHandleWebSocketMessage extends VoiceChatEvent {
  final Map<String, dynamic> message;
  VoiceChatHandleWebSocketMessage(this.message);
}

class VoiceChatHandleError extends VoiceChatEvent {
  final String error;
  VoiceChatHandleError(this.error);
}
