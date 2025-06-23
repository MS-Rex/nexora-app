import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/localization/app_localization_extension.dart';
import '../../../../core/common/logger/app_logger.dart';

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

  bool _isListening = false;
  bool _isAISpeaking = false;
  String _statusText = "Hello! How may I assist you today?";

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
          if (mounted) {
            setState(() {
              _statusText = "You said: \"${message['text']}\"";
            });
          }
          break;
        case 'response_audio':
          _playResponseAudio(message['data']);
          if (message['text'] != null && mounted) {
            setState(() {
              _statusText = "AI: \"${message['text']}\"";
            });
          }
          break;
        case 'processing':
          if (mounted) {
            setState(() {
              _statusText = message['message'] ?? 'AI is thinking...';
            });
          }
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
            if (mounted && !_isListening && !_isAISpeaking) {
              setState(() {
                _statusText = context.l10n.tapToStartSpeaking;
              });
            }
          });
          break;
        case 'error':
          if (mounted) {
            // _showErrorDialog(message['message'] ?? 'Unknown error');
            setState(() {
              _statusText = "Error occurred - Try again";
            });
          }
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

      if (mounted) {
        setState(() {
          _isAISpeaking = true;
          _statusText = "AI is responding...";
          _waveController.repeat();
        });
      }

      await _audioPlayer.play(DeviceFileSource(tempFile.path));

      // Clean up after playing
      await tempFile.delete();
      if (mounted) {
        setState(() {
          _isAISpeaking = false;
          _statusText = context.l10n.tapToStartSpeaking;
          _waveController.stop();
          _waveController.reset();
        });
      }
    } catch (e) {
      logger.e("Error playing audio: $e", e);
      if (mounted) {
        setState(() {
          _isAISpeaking = false;
          _statusText = context.l10n.tapToStartSpeaking;
          _waveController.stop();
          _waveController.reset();
        });
      }
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

    if (_isListening) {
      // Just stop recording, keep WebSocket connected for response
      await _stopRecording();
    } else {
      // If AI is currently speaking, stop the audio first
      if (_isAISpeaking) {
        await _audioPlayer.stop();
        if (mounted) {
          setState(() {
            _isAISpeaking = false;
            _waveController.stop();
            _waveController.reset();
          });
        }
      }

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
    }
  }

  Future<void> _startRecording() async {
    if (_isListening || !_hasMicPermission || !_isConnected) return;

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

      if (mounted) {
        setState(() {
          _isListening = true;
          _isAISpeaking = false;
          _statusText = "Recording... Tap again to stop";
          _pulseController.repeat(reverse: true);
          _waveController.stop();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusText = "Failed to start recording. Try again.";
        });
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!_isListening) return;

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

        if (mounted) {
          setState(() {
            _isListening = false;
            _pulseController.stop();
            _pulseController.reset();
            _statusText = "Processing your message...";
          });
        }
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

  void _simulateAISpeaking() {
    if (mounted) {
      setState(() {
        _isAISpeaking = true;
        _isListening = false;
        _statusText = "AI is responding...";
        _pulseController.stop();
        _pulseController.reset();
        _waveController.repeat();
      });
    }

    // Simulate AI speaking for a few seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isAISpeaking = false;
          _statusText = context.l10n.tapToStartSpeaking;
          _waveController.stop();
          _waveController.reset();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => context.router.pop(),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "NEXORA VOICE CHAT",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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

                    // Status message in chat bubble
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _statusText,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Connection status indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatusIndicator(
                          icon:
                              _hasMicPermission
                                  ? Iconsax.microphone
                                  : Iconsax.microphone_slash,
                          label:
                              _hasMicPermission
                                  ? context.l10n.microphoneReady
                                  : "Microphone Access Needed",
                          isActive: _hasMicPermission,
                        ),
                        const SizedBox(width: 20),
                        _buildStatusIndicator(
                          icon:
                              _isConnected ? Iconsax.wifi : Iconsax.cloud_cross,
                          label:
                              _isConnected
                                  ? context.l10n.connected
                                  : context.l10n.disconnected,
                          isActive: _isConnected,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bottom section with mic button and controls
              Column(
                children: [
                  // Mic button with pulse animation
                  GestureDetector(
                    onTap: _toggleListening,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _isListening ? _pulseAnimation.value : 1.0,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors:
                                    _isListening
                                        ? [
                                          const Color(0xFFEF4444),
                                          const Color(0xFFDC2626),
                                        ]
                                        : [
                                          const Color(0xFF7C3AED),
                                          const Color(0xFF8B5CF6),
                                        ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (_isListening
                                          ? const Color(0xFFEF4444)
                                          : const Color(0xFF7C3AED))
                                      .withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              _isListening ? Iconsax.stop : Iconsax.microphone,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Instructions
                  Text(
                    _isListening
                        ? "Listening... Tap to stop"
                        : context.l10n.tapToStartSpeaking,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedVoiceCircle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outermost wave circle (when AI is speaking)
        if (_isAISpeaking)
          AnimatedBuilder(
            animation: _waveAnimation,
            builder: (context, child) {
              return Container(
                width: 200 - (_waveAnimation.value * 30),
                height: 200 - (_waveAnimation.value * 30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(
                        0xFF7C3AED,
                      ).withValues(alpha: 0.1 + (_waveAnimation.value * 0.2)),
                      const Color(0xFF7C3AED).withValues(alpha: 0.05),
                    ],
                  ),
                ),
              );
            },
          ),

        // Second wave circle
        if (_isAISpeaking)
          AnimatedBuilder(
            animation: _waveAnimation,
            builder: (context, child) {
              return Container(
                width: 160 - (_waveAnimation.value * 20),
                height: 160 - (_waveAnimation.value * 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(
                        0xFF8B5CF6,
                      ).withValues(alpha: 0.2 + (_waveAnimation.value * 0.3)),
                      const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    ],
                  ),
                ),
              );
            },
          ),

        // Third wave circle
        if (_isAISpeaking)
          AnimatedBuilder(
            animation: _waveAnimation,
            builder: (context, child) {
              return Container(
                width: 120 - (_waveAnimation.value * 10),
                height: 120 - (_waveAnimation.value * 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(
                        0xFFA855F7,
                      ).withValues(alpha: 0.3 + (_waveAnimation.value * 0.4)),
                      const Color(0xFFA855F7).withValues(alpha: 0.15),
                    ],
                  ),
                ),
              );
            },
          ),

        // Breathing circles (when idle)
        if (!_isAISpeaking && !_isListening)
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

        if (!_isAISpeaking && !_isListening)
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

        // Listening state circles
        if (_isListening)
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 120 * _pulseAnimation.value,
                height: 120 * _pulseAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFEF4444).withValues(alpha: 0.3),
                      const Color(0xFFEF4444).withValues(alpha: 0.1),
                    ],
                  ),
                ),
              );
            },
          ),

        // Core circle
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  _isListening
                      ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                      : _isAISpeaking
                      ? [const Color(0xFF7C3AED), const Color(0xFF8B5CF6)]
                      : [const Color(0xFF7C3AED), const Color(0xFF8B5CF6)],
            ),
            boxShadow: [
              BoxShadow(
                color: (_isListening
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF7C3AED))
                    .withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            _isListening
                ? Iconsax.microphone
                : _isAISpeaking
                ? Iconsax.sound
                : Iconsax.cpu,
            size: 35,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color:
            isActive
                ? const Color(0xFF10B981).withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isActive
                  ? const Color(0xFF10B981).withValues(alpha: 0.3)
                  : Colors.red.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF10B981) : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF10B981) : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
