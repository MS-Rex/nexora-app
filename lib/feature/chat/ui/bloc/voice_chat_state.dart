part of 'voice_chat_bloc.dart';

class VoiceChatState {
  final bool isListening;
  final bool isAISpeaking;
  final bool isConnected;
  final bool hasMicPermission;
  final String statusText;
  final bool isLoading;
  final String? error;

  const VoiceChatState({
    this.isListening = false,
    this.isAISpeaking = false,
    this.isConnected = false,
    this.hasMicPermission = false,
    this.statusText = "Hello! How may I assist you today?",
    this.isLoading = false,
    this.error,
  });

  VoiceChatState copyWith({
    bool? isListening,
    bool? isAISpeaking,
    bool? isConnected,
    bool? hasMicPermission,
    String? statusText,
    bool? isLoading,
    String? error,
  }) {
    return VoiceChatState(
      isListening: isListening ?? this.isListening,
      isAISpeaking: isAISpeaking ?? this.isAISpeaking,
      isConnected: isConnected ?? this.isConnected,
      hasMicPermission: hasMicPermission ?? this.hasMicPermission,
      statusText: statusText ?? this.statusText,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
