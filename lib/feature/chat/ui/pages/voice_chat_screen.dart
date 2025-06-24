import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/localization/app_localization_extension.dart';
import '../../../../core/common/logger/app_logger.dart';

enum VoiceChatState {
  idle,
  listening,
  processing,
  aiSpeaking;

  bool get isIdle => this == VoiceChatState.idle;
  bool get isListening => this == VoiceChatState.listening;
  bool get isProcessing => this == VoiceChatState.processing;
  bool get isAiSpeaking => this == VoiceChatState.aiSpeaking;

  bool get shouldShowStopIcon => isProcessing;
  bool get shouldShowSendIcon => isListening;
  bool get shouldShowMicIcon => isIdle;
  bool get shouldShowWaveAnimation => isAiSpeaking;
}

@RoutePage()
class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({super.key});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  late Animation<double> _waveAnimation;
  late Animation<double> _pulseAnimation;

  VoiceChatState _currentState = VoiceChatState.idle;
  String _statusText = "Tap to start speaking";

  // Audio recording and WebSocket
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  WebSocketChannel? _webSocketChannel;
  StreamSubscription? _webSocketSubscription;
  String? _currentRecordingPath;
  bool _hasMicPermission = false;
  bool _isConnected = false;
  final String _clientId = const Uuid().v4();
  Timer? _recordingTimer;

  @override
  void initState() {
    super.initState();
    _checkMicPermission();

    // Wave animation for AI speaking
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    // Pulse animation for breathing effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start breathing animation
    _pulseController.repeat(reverse: true);
  }

  void _setState(VoiceChatState newState, {String? statusText}) {
    if (mounted) {
      setState(() {
        _currentState = newState;
        if (statusText != null) {
          _statusText = statusText;
        }
      });

      // Handle animations based on state
      switch (newState) {
        case VoiceChatState.idle:
          _pulseController.stop();
          _pulseController.reset();
          _pulseController.repeat(
            reverse: true,
          ); // breathing animation for idle
          _waveController.stop();
          _waveController.reset();
          break;
        case VoiceChatState.listening:
        case VoiceChatState.processing:
          _pulseController.repeat(reverse: true);
          _waveController.stop();
          _waveController.reset();
          break;
        case VoiceChatState.aiSpeaking:
          _pulseController.stop();
          _pulseController.reset();
          _waveController.repeat();
          break;
      }
    }
  }

  /// Check and request microphone permission
  Future<void> _checkMicPermission() async {
    final status = await Permission.microphone.status;
    _hasMicPermission = status == PermissionStatus.granted;

    if (!_hasMicPermission) {
      final result = await Permission.microphone.request();
      _hasMicPermission = result == PermissionStatus.granted;
    }
    if (mounted) {
      setState(() {});
    }
  }

  /// Connect to WebSocket
  Future<void> _connectWebSocket() async {
    try {
      String baseUrl;

      baseUrl = dotenv.env['VOICE_AI_URL'] ?? 'http://192.168.1.156/api/v1';

      String wsUrl = '$baseUrl/$_clientId';
      // '$wsScheme://${baseUri.host}:$wsPort/voice-chat/$_clientId';

      logger.d("Base URL: $baseUrl");
      logger.d("Constructed WebSocket URL: $wsUrl");
      logger.d("Client ID: $_clientId");

      if (mounted) {
        setState(() {
          _statusText = "Connecting...";
        });
      }

      _webSocketChannel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Listen for messages from server
      _webSocketSubscription = _webSocketChannel?.stream.listen(
        (data) {
          // Connection successful - set connected on first message
          if (!_isConnected && mounted) {
            setState(() {
              _isConnected = true;
              _statusText = context.l10n.connectedReadyToListen;
            });
          }
          _handleWebSocketMessage(data);
        },
        onError: (error) => _handleWebSocketError(error),
        onDone: () => _handleWebSocketClosed(),
      );

      // Wait a bit to see if connection is successful
      await Future.delayed(const Duration(seconds: 2));

      // If still not connected after delay, it means there might be an issue
      if (!_isConnected && mounted) {
        setState(() {
          _statusText = "Checking connection...";
        });

        // Send a test message to verify connection
        try {
          _webSocketChannel?.sink.add(
            jsonEncode({"type": "test", "message": "connection_test"}),
          );

          if (mounted) {
            setState(() {
              _isConnected = true;
              _statusText = context.l10n.connectedReadyToListen;
            });
          }
        } catch (e) {
          throw Exception("Failed to send test message: $e");
        }
      }
    } catch (e) {
      logger.e("WebSocket connection error: $e", e);
      if (mounted) {
        setState(() {
          _isConnected = false;
          _statusText = "Failed to connect. Tap to retry.";
        });
      }
    }
  }

  /// Disconnect WebSocket
  Future<void> _disconnectWebSocket() async {
    _webSocketSubscription?.cancel();
    _webSocketSubscription = null;
    await _webSocketChannel?.sink.close();
    _webSocketChannel = null;
    if (mounted) {
      setState(() {
        _isConnected = false;
        _statusText = context.l10n.tapToStartSpeaking;
      });
    }
  }

  /// Handle incoming WebSocket messages
  void _handleWebSocketMessage(dynamic data) {
    try {
      final message = jsonDecode(data);
      logger.d("Received message: $message");

      switch (message['type']) {
        case 'transcription':
          _setState(
            VoiceChatState.idle,
            statusText: "You said: \"${message['text']}\"",
          );
          break;
        case 'response_audio':
          _playResponseAudio(message['data']);
          if (message['text'] != null) {
            _setState(
              VoiceChatState.aiSpeaking,
              statusText: "AI: \"${message['text']}\"",
            );
          }
          break;
        case 'processing':
          _setState(
            VoiceChatState.aiSpeaking,
            statusText: message['message'] ?? 'AI is thinking...',
          );
          break;
        case 'pong':
          logger.d("🏓 Pong received from server");
          if (mounted) {
            setState(() {
              _statusText = "Connection verified ✓ - Ready to talk";
            });
          }
          // Reset to ready state after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted && _currentState.isIdle) {
              setState(() {
                _statusText = context.l10n.tapToStartSpeaking;
              });
            }
          });
          break;
        case 'error':
          _setState(
            VoiceChatState.idle,
            statusText: "Error occurred - Try again",
          );
          break;
        default:
          logger.w("Unknown message type: ${message['type']}");
      }
    } catch (e) {
      logger.e("Error parsing WebSocket message: $e", e);
    }
  }

  /// Handle WebSocket errors
  void _handleWebSocketError(error) {
    logger.e("WebSocket error: $error", error);
    if (mounted) {
      setState(() {
        _isConnected = false;
        _statusText = "Connection error";
      });
    }
  }

  /// Handle WebSocket closed
  void _handleWebSocketClosed() {
    if (mounted) {
      setState(() {
        _isConnected = false;
        _statusText = "Connection closed";
      });
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

      _setState(VoiceChatState.aiSpeaking, statusText: "AI is responding...");

      await _audioPlayer.play(DeviceFileSource(tempFile.path));

      // Clean up after playing
      await tempFile.delete();
      _setState(
        VoiceChatState.idle,
        statusText: context.l10n.tapToStartSpeaking,
      );
    } catch (e) {
      logger.e("Error playing audio: $e", e);
      _setState(
        VoiceChatState.idle,
        statusText: context.l10n.tapToStartSpeaking,
      );
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();

    // Cancel WebSocket subscription and disconnect
    _webSocketSubscription?.cancel();
    _webSocketChannel?.sink.close();

    super.dispose();
  }

  void _toggleListening() async {
    if (!_hasMicPermission) {
      await _checkMicPermission();
      if (!_hasMicPermission) {
        _showPermissionDialog();
        return;
      }
    }

    switch (_currentState) {
      case VoiceChatState.processing:
        // Stop processing and reset to ready state
        _setState(
          VoiceChatState.idle,
          statusText: context.l10n.tapToStartSpeaking,
        );
        break;
      case VoiceChatState.listening:
        // Stop recording, keep WebSocket connected for response
        await _stopRecording();
        break;
      case VoiceChatState.aiSpeaking:
        // Stop AI audio and start listening immediately
        await _audioPlayer.stop();
        if (_isConnected) {
          await _startRecording();
        } else {
          _setState(
            VoiceChatState.idle,
            statusText: "Tap again to retry connection",
          );
        }
        break;
      case VoiceChatState.idle:
        // Connect to WebSocket if not already connected, then start recording
        if (!_isConnected) {
          await _connectWebSocket();
        }
        if (_isConnected) {
          await _startRecording();
        } else {
          // If still not connected, update status
          if (mounted) {
            setState(() {
              _statusText = "Tap again to retry connection";
            });
          }
        }
        break;
    }
  }

  Future<void> _startRecording() async {
    if (_currentState.isListening || !_hasMicPermission || !_isConnected)
      return;

    try {
      logger.d("🔍 Starting recording to: $_currentRecordingPath");

      // Create a unique file path
      final directory = Directory.systemTemp;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentRecordingPath = '${directory.path}/audio_record_$timestamp.wav';

      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 16000,
          bitRate: 256000,
        ),
        path: _currentRecordingPath!,
      );

      logger.d("🔍 Recording started successfully");

      _setState(VoiceChatState.listening, statusText: "Tap to Send");
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusText = "Failed to start recording. Try again.";
        });
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!_currentState.isListening) return;

    try {
      logger.d("🔍 Stopping recording...");
      final path = await _audioRecorder.stop();
      logger.d("🔍 Recording stopped");

      if (path != null) {
        _currentRecordingPath = path;
        logger.d("🔍 Waiting for file to be written...");
        await Future.delayed(const Duration(milliseconds: 500));

        logger.d("🔍 About to send complete audio...");
        await _sendCompleteAudio();
        logger.d("🔍 _sendCompleteAudio finished");

        _setState(
          VoiceChatState.processing,
          statusText: "Processing... Tap to stop",
        );
      }
    } catch (e) {
      logger.e("❌ Error stopping recording: $e", e);
    }
  }

  /// Send complete audio file to WebSocket
  Future<void> _sendCompleteAudio() async {
    logger.d("🔍 _sendCompleteAudio called");
    logger.d("🔍 _currentRecordingPath: $_currentRecordingPath");
    logger.d("🔍 _webSocketChannel: $_webSocketChannel");
    logger.d("🔍 _isConnected: $_isConnected");

    if (_currentRecordingPath != null &&
        _webSocketChannel != null &&
        _isConnected) {
      final audioFile = File(_currentRecordingPath!);
      logger.d("🔍 Audio file path: ${audioFile.path}");
      logger.d("🔍 Audio file exists: ${await audioFile.exists()}");

      if (await audioFile.exists()) {
        try {
          logger.d("🔍 Reading audio file...");
          final audioBytes = await audioFile.readAsBytes();
          logger.d("🔍 Audio file size: ${audioBytes.length} bytes");

          if (audioBytes.isEmpty) {
            logger.e("❌ Audio file is empty");
            return;
          }

          // Convert to base64
          final base64Audio = base64Encode(audioBytes);

          // Instead of sending streaming chunks, send complete audio
          final message = jsonEncode({
            'type': 'audio_chunk',
            'data': base64Audio,
            'format': 'wav',
            'sample_rate': 16000,
            'channels': 1,
          });

          logger.d("🔍 Encoding to base64...");

          logger.d("🔍 Base64 audio length: ${base64Audio.length} characters");

          if (_webSocketChannel != null) {
            try {
              logger.d("🔍 Sending message to WebSocket...");
              _webSocketChannel!.sink.add(message);
              logger.i("📤 Sent complete audio (${audioBytes.length} bytes)");

              // Clean up the audio file
              logger.d("🔍 Deleting audio file...");
              await audioFile.delete();
              logger.d("🔍 Audio file deleted");
            } on FileSystemException catch (fileError) {
              logger.e("❌ Error reading audio file: $fileError", fileError);
            }
          }
        } catch (e) {
          if (e is FileSystemException) {
            // Handle file errors
            logger.e("❌ Error reading audio file: $e", e);
          } else {
            logger.e("❌ Audio file does not exist at path: ${audioFile.path}");
          }
        }
      } else {
        logger.e("❌ Audio file does not exist at path: ${audioFile.path}");
      }
    } else {
      // Debug missing requirements
      logger.e("❌ Missing requirements:");
      logger.e(
        "   _currentRecordingPath is null: ${_currentRecordingPath == null}",
      );
      logger.e("   _webSocketChannel is null: ${_webSocketChannel == null}");
      logger.e("   _isConnected: $_isConnected");
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Microphone Permission Required"),
          content: const Text(
            "This app needs microphone access to enable voice chat. Please grant permission in settings.",
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Open Settings"),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/def_background.png',
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: ScreenUtil().statusBarHeight,
            left: 0,
            right: 0,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF7F22FE)),
                  onPressed: () => context.router.pop(),
                ),
                Expanded(
                  child: const Text(
                    "Voice Chat",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Icon(
                    Iconsax.wifi,
                    color: Color(0xFF189210),
                    size: 24.sp,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  // Status message in chat bubble style
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // AI Voice Animation
                        Container(
                          width: 200,
                          height: 200,
                          margin: const EdgeInsets.only(bottom: 30),
                          child: _buildAnimatedVoiceCircle(),
                        ),

                        // Connection status indicators
                        if (!_hasMicPermission)
                          Container(
                            width: 236.w,
                            padding: EdgeInsets.symmetric(
                              horizontal: 18.w,
                              vertical: 18.h,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFC49C2D).withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: Color(0xFFC49C2D),
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.mic_off_outlined,
                                  color: Color(0xFFC49C2D),
                                  size: 24.sp,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'No Microphone Access',
                                  style: TextStyle(
                                    color: Color(0xFFC49C2D),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (!_isConnected)
                          Container(
                            width: 236.w,
                            padding: EdgeInsets.symmetric(
                              horizontal: 18.w,
                              vertical: 18.h,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFC49C2D).withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: Color(0xFFC49C2D),
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons
                                      .signal_wifi_connected_no_internet_4_outlined,
                                  color: Color(0xFFC49C2D),
                                  size: 24.sp,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'Not Connected',
                                  style: TextStyle(
                                    color: Color(0xFFC49C2D),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Bottom section with mic button and controls
                  Column(
                    children: [
                      // Instructions
                      Text(
                        _statusText,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),
                      GestureDetector(
                        onTap: _toggleListening,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF7C3AED,
                                ).withValues(alpha: 0.3),
                                blurRadius: 20,
                                spreadRadius: 0,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            _currentState.shouldShowStopIcon
                                ? Icons.stop
                                : _currentState.shouldShowSendIcon
                                ? Icons.send
                                : Icons.mic,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedVoiceCircle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (!_currentState.shouldShowWaveAnimation)
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 180 * _pulseAnimation.value,
                height: 180 * _pulseAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                      const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    ],
                  ),
                ),
              );
            },
          ),
        if (!_currentState.shouldShowWaveAnimation)
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 140 * _pulseAnimation.value,
                height: 140 * _pulseAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF7C3AED).withValues(alpha: 0.15),
                      const Color(0xFF7C3AED).withValues(alpha: 0.05),
                    ],
                  ),
                ),
              );
            },
          ),
        if (!_currentState.shouldShowWaveAnimation)
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 100 * _pulseAnimation.value,
                height: 100 * _pulseAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                      const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    ],
                  ),
                ),
              );
            },
          ),
        if (!_currentState.shouldShowWaveAnimation)
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 60 * _pulseAnimation.value,
                height: 60 * _pulseAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF8B5CF6).withValues(alpha: 0.05),
                      const Color(0xFF8B5CF6).withValues(alpha: 0.05),
                    ],
                  ),
                ),
              );
            },
          ),

        // Core circle
        SvgPicture.asset(
          'assets/images/app_logo.svg',
          width: 60.w,
          height: 16.h,
        ),
      ],
    );
  }
}
