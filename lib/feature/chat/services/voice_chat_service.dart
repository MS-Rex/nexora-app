import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import 'package:injectable/injectable.dart';

class VoiceChatServiceState {
  final bool isListening;
  final bool isAISpeaking;
  final bool isConnected;
  final bool hasMicPermission;
  final String statusText;
  final String? error;

  const VoiceChatServiceState({
    this.isListening = false,
    this.isAISpeaking = false,
    this.isConnected = false,
    this.hasMicPermission = false,
    this.statusText = "Hello! How may I assist you today?",
    this.error,
  });

  VoiceChatServiceState copyWith({
    bool? isListening,
    bool? isAISpeaking,
    bool? isConnected,
    bool? hasMicPermission,
    String? statusText,
    String? error,
  }) {
    return VoiceChatServiceState(
      isListening: isListening ?? this.isListening,
      isAISpeaking: isAISpeaking ?? this.isAISpeaking,
      isConnected: isConnected ?? this.isConnected,
      hasMicPermission: hasMicPermission ?? this.hasMicPermission,
      statusText: statusText ?? this.statusText,
      error: error ?? this.error,
    );
  }
}

@injectable
class VoiceChatService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  WebSocketChannel? _webSocketChannel;
  StreamSubscription? _webSocketSubscription;
  String? _currentRecordingPath;
  String _clientId = const Uuid().v4();
  Timer? _recordingTimer;

  final StreamController<VoiceChatServiceState> _stateController =
      StreamController<VoiceChatServiceState>.broadcast();

  VoiceChatServiceState _state = const VoiceChatServiceState();

  Stream<VoiceChatServiceState> get stateStream => _stateController.stream;
  VoiceChatServiceState get currentState => _state;

  void _updateState(VoiceChatServiceState newState) {
    _state = newState;
    _stateController.add(_state);
  }

  Future<void> initialize() async {
    await checkMicPermission();
  }

  /// Check and request microphone permission
  Future<void> checkMicPermission() async {
    final status = await Permission.microphone.status;
    bool hasMicPermission = status == PermissionStatus.granted;

    if (!hasMicPermission) {
      final result = await Permission.microphone.request();
      hasMicPermission = result == PermissionStatus.granted;
    }

    _updateState(_state.copyWith(hasMicPermission: hasMicPermission));
  }

  /// Connect to WebSocket
  Future<void> connectWebSocket() async {
    try {
      String baseUrl =
          dotenv.env['BASE_URL'] ?? 'http://192.168.1.156:8000/api/v1';
      final wsUrl =
          baseUrl.replaceFirst('http', 'ws') + '/voice-chat/$_clientId';

      _updateState(_state.copyWith(statusText: "Connecting..."));

      _webSocketChannel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Listen for messages from server
      _webSocketSubscription = _webSocketChannel?.stream.listen(
        (data) {
          if (!_state.isConnected) {
            _updateState(
              _state.copyWith(
                isConnected: true,
                statusText: "Connected - Ready to listen",
              ),
            );
          }
          handleWebSocketMessage(jsonDecode(data));
        },
        onError: (error) => _handleWebSocketError(error),
        onDone: () => _handleWebSocketClosed(),
      );

      // Wait a bit to see if connection is successful
      await Future.delayed(const Duration(seconds: 2));

      // If still not connected after delay, send a test message to verify connection
      if (!_state.isConnected) {
        _updateState(_state.copyWith(statusText: "Checking connection..."));

        try {
          _webSocketChannel?.sink.add(
            jsonEncode({"type": "test", "message": "connection_test"}),
          );

          _updateState(
            _state.copyWith(
              isConnected: true,
              statusText: "Connected - Ready to listen",
            ),
          );
        } catch (e) {
          throw Exception("Failed to send test message: $e");
        }
      }
    } catch (e) {
      _updateState(
        _state.copyWith(
          isConnected: false,
          statusText: "Connection failed",
          error:
              "Failed to connect: $e\n\nMake sure your backend is running on localhost:8000",
        ),
      );
    }
  }

  /// Disconnect WebSocket
  Future<void> disconnectWebSocket() async {
    _webSocketSubscription?.cancel();
    _webSocketSubscription = null;
    await _webSocketChannel?.sink.close();
    _webSocketChannel = null;

    _updateState(
      _state.copyWith(isConnected: false, statusText: "Tap to start speaking"),
    );
  }

  /// Handle incoming WebSocket messages
  void handleWebSocketMessage(Map<String, dynamic> message) {
    switch (message['type']) {
      case 'transcription':
        _updateState(
          _state.copyWith(statusText: "You said: \"${message['text']}\""),
        );
        break;
      case 'response_audio':
        _playResponseAudio(message['data']);
        if (message['text'] != null) {
          _updateState(
            _state.copyWith(statusText: "AI: \"${message['text']}\""),
          );
        }
        break;
      case 'processing':
        _updateState(
          _state.copyWith(
            statusText: message['message'] ?? 'AI is thinking...',
          ),
        );
        break;
      case 'pong':
        _updateState(
          _state.copyWith(statusText: "Connection verified ✓ - Ready to talk"),
        );
        // Reset to ready state after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (!_state.isListening && !_state.isAISpeaking) {
            _updateState(_state.copyWith(statusText: "Tap to start speaking"));
          }
        });
        break;
      case 'error':
        _updateState(
          _state.copyWith(
            statusText: "Error occurred - Try again",
            error: message['message'] ?? 'Unknown error',
          ),
        );
        break;
    }
  }

  /// Handle WebSocket errors
  void _handleWebSocketError(error) {
    _updateState(
      _state.copyWith(
        isConnected: false,
        statusText: "Connection error",
        error: error.toString(),
      ),
    );
  }

  /// Handle WebSocket closed
  void _handleWebSocketClosed() {
    _updateState(
      _state.copyWith(isConnected: false, statusText: "Connection closed"),
    );
  }

  /// Start recording audio
  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final tempDir = Directory.systemTemp;
        _currentRecordingPath =
            '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.wav,
            sampleRate: 16000,
            numChannels: 1,
          ),
          path: _currentRecordingPath!,
        );

        _updateState(
          _state.copyWith(
            isListening: true,
            isAISpeaking: false,
            statusText: "Recording... Tap again to stop",
          ),
        );
      } else {
        _updateState(
          _state.copyWith(error: "Microphone permission not granted"),
        );
      }
    } catch (e) {
      _updateState(_state.copyWith(error: "Failed to start recording: $e"));
    }
  }

  /// Stop recording audio
  Future<void> stopRecording() async {
    try {
      await _audioRecorder.stop();
      _recordingTimer?.cancel();

      // Wait a moment for the file to be fully written
      await Future.delayed(const Duration(milliseconds: 500));

      // Send the complete audio file
      await _sendCompleteAudio();

      _updateState(
        _state.copyWith(
          isListening: false,
          statusText: "Processing your message...",
        ),
      );
    } catch (e) {
      debugPrint("Error stopping recording: $e");
    }
  }

  /// Send complete audio file via WebSocket
  Future<void> _sendCompleteAudio() async {
    if (_currentRecordingPath != null && _webSocketChannel != null) {
      try {
        final audioFile = File(_currentRecordingPath!);

        if (await audioFile.exists()) {
          final audioBytes = await audioFile.readAsBytes();

          if (audioBytes.isEmpty) {
            _updateState(_state.copyWith(error: "Audio file is empty"));
            return;
          }

          final base64Audio = base64Encode(audioBytes);
          final message = {
            "type": "audio_chunk",
            "data": base64Audio,
            "format": "wav",
            "sample_rate": 16000,
            "channels": 1,
          };

          _webSocketChannel?.sink.add(jsonEncode(message));

          // Clean up the temporary file
          await audioFile.delete();
        } else {
          _updateState(_state.copyWith(error: "Audio file not found"));
        }
      } catch (e) {
        _updateState(_state.copyWith(error: "Failed to send audio: $e"));
      }
    } else {
      _updateState(
        _state.copyWith(
          error:
              "Cannot send audio: missing recording path or WebSocket connection",
        ),
      );
    }
  }

  /// Play audio response from AI
  Future<void> _playResponseAudio(String base64Audio) async {
    try {
      final audioBytes = base64Decode(base64Audio);
      final tempDir = Directory.systemTemp;
      final tempFile = File(
        '${tempDir.path}/response_${DateTime.now().millisecondsSinceEpoch}.wav',
      );
      await tempFile.writeAsBytes(audioBytes);

      _updateState(
        _state.copyWith(isAISpeaking: true, statusText: "AI is responding..."),
      );

      await _audioPlayer.play(DeviceFileSource(tempFile.path));

      // Clean up after playing
      await tempFile.delete();
      _updateState(
        _state.copyWith(
          isAISpeaking: false,
          statusText: "Tap to start speaking",
        ),
      );
    } catch (e) {
      debugPrint("Error playing audio: $e");
      _updateState(
        _state.copyWith(
          isAISpeaking: false,
          statusText: "Tap to start speaking",
        ),
      );
    }
  }

  /// Send a test message to verify WebSocket connection
  Future<void> sendTestMessage() async {
    if (_webSocketChannel != null && _state.isConnected) {
      try {
        final testMessage = {"type": "ping", "message": "test_connection"};
        _webSocketChannel?.sink.add(jsonEncode(testMessage));

        _updateState(_state.copyWith(statusText: "Test message sent..."));
      } catch (e) {
        _updateState(_state.copyWith(error: "Failed to send test message: $e"));
      }
    } else {
      _updateState(
        _state.copyWith(
          error: "Not connected to server. Please connect first.",
        ),
      );
    }
  }

  void dispose() {
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _webSocketSubscription?.cancel();
    _webSocketChannel?.sink.close();
    _stateController.close();
  }
}
