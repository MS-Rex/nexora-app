import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';

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
  String _clientId = const Uuid().v4();
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

      baseUrl = dotenv.env['BASE_URL'] ?? 'http://192.168.1.156:8000/api/v1';

      final wsUrl =
          baseUrl.replaceFirst('http', 'ws') + '/voice-chat/$_clientId';
      print("Base URL: $baseUrl"); // Debug log
      print("WebSocket URL: $wsUrl"); // Debug log
      print("Client ID: $_clientId"); // Debug log

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
              _statusText = "Connected - Ready to listen";
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
              _statusText = "Connected - Ready to listen";
            });
          }
        } catch (e) {
          throw Exception("Failed to send test message: $e");
        }
      }
    } catch (e) {
      print("WebSocket connection error: $e"); // Debug log
      if (mounted) {
        setState(() {
          _isConnected = false;
          _statusText = "Connection failed";
        });
        _showErrorDialog(
          "Failed to connect: $e\n\nMake sure your backend is running on localhost:8000",
        );
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
        _statusText = "Tap to start speaking";
      });
    }
  }

  /// Handle incoming WebSocket messages
  void _handleWebSocketMessage(dynamic data) {
    try {
      final message = jsonDecode(data);
      print("Received message: $message"); // Debug log

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
          print("🏓 Pong received from server");
          if (mounted) {
            setState(() {
              _statusText = "Connection verified ✓ - Ready to talk";
            });
          }
          // Reset to ready state after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted && !_isListening && !_isAISpeaking) {
              setState(() {
                _statusText = "Tap to start speaking";
              });
            }
          });
          break;
        case 'error':
          if (mounted) {
            _showErrorDialog(message['message'] ?? 'Unknown error');
            setState(() {
              _statusText = "Error occurred - Try again";
            });
          }
          break;
        default:
          print("Unknown message type: ${message['type']}");
      }
    } catch (e) {
      print("Error parsing WebSocket message: $e");
    }
  }

  /// Handle WebSocket errors
  void _handleWebSocketError(error) {
    print("WebSocket error: $error");
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
          _statusText = "Tap to start speaking";
          _waveController.stop();
          _waveController.reset();
        });
      }
    } catch (e) {
      print("Error playing audio: $e");
      if (mounted) {
        setState(() {
          _isAISpeaking = false;
          _statusText = "Tap to start speaking";
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
      // Connect to WebSocket if not already connected, then start recording
      if (!_isConnected) {
        await _connectWebSocket();
      }
      if (_isConnected) {
        await _startRecording();
      }
    }
  }

  Future<void> _startRecording() async {
    try {
      // Check if microphone permission is granted
      if (await _audioRecorder.hasPermission()) {
        final tempDir = Directory.systemTemp;
        _currentRecordingPath =
            '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';

        print("🔍 Starting recording to: $_currentRecordingPath");

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.wav,
            sampleRate: 16000, // Match web app sample rate
            numChannels: 1,
          ),
          path: _currentRecordingPath!,
        );

        print("🔍 Recording started successfully");

        if (mounted) {
          setState(() {
            _isListening = true;
            _isAISpeaking = false;
            _statusText = "Recording... Tap again to stop";
            _pulseController.repeat(reverse: true);
            _waveController.stop();
          });
        }
      } else {
        _showErrorDialog("Microphone permission not granted");
      }
    } catch (e) {
      _showErrorDialog("Failed to start recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      print("🔍 Stopping recording...");
      await _audioRecorder.stop();
      print("🔍 Recording stopped");

      _recordingTimer?.cancel();

      // Wait a moment for the file to be fully written
      print("🔍 Waiting for file to be written...");
      await Future.delayed(const Duration(milliseconds: 500));

      // Send the complete audio file
      print("🔍 About to send complete audio...");
      await _sendCompleteAudio();
      print("🔍 _sendCompleteAudio finished");

      if (mounted) {
        setState(() {
          _isListening = false;
          _pulseController.stop();
          _pulseController.reset();
          _statusText = "Processing your message...";
        });
      }
    } catch (e) {
      print("❌ Error stopping recording: $e");
    }
  }

  Future<void> _sendCompleteAudio() async {
    print("🔍 _sendCompleteAudio called");
    print("🔍 _currentRecordingPath: $_currentRecordingPath");
    print("🔍 _webSocketChannel: $_webSocketChannel");
    print("🔍 _isConnected: $_isConnected");

    if (_currentRecordingPath != null && _webSocketChannel != null) {
      try {
        final audioFile = File(_currentRecordingPath!);
        print("🔍 Audio file path: ${audioFile.path}");
        print("🔍 Audio file exists: ${await audioFile.exists()}");

        if (await audioFile.exists()) {
          try {
            print("🔍 Reading audio file...");
            final audioBytes = await audioFile.readAsBytes();
            print("🔍 Audio file size: ${audioBytes.length} bytes");

            if (audioBytes.isEmpty) {
              print("❌ Audio file is empty");
              _showErrorDialog("Audio file is empty");
              return;
            }

            print("🔍 Encoding to base64...");
            final base64Audio = base64Encode(audioBytes);
            print("🔍 Base64 audio length: ${base64Audio.length} characters");

            final message = {
              "type": "audio_chunk",
              "data": base64Audio,
              "format": "wav",
              "sample_rate": 16000,
              "channels": 1,
            };

            print("🔍 Sending message to WebSocket...");
            _webSocketChannel?.sink.add(jsonEncode(message));
            print("📤 Sent complete audio (${audioBytes.length} bytes)");

            // Clean up the temporary file
            print("🔍 Deleting audio file...");
            await audioFile.delete();
            print("🔍 Audio file deleted");
          } catch (fileError) {
            print("❌ Error reading audio file: $fileError");
            _showErrorDialog("Failed to read audio file: $fileError");
          }
        } else {
          print("❌ Audio file does not exist at path: ${audioFile.path}");
          _showErrorDialog("Audio file not found");
        }
      } catch (e) {
        print("❌ Error sending complete audio: $e");
        _showErrorDialog("Failed to send audio: $e");
      }
    } else {
      print("❌ Missing requirements:");
      print(
        "   _currentRecordingPath is null: ${_currentRecordingPath == null}",
      );
      print("   _webSocketChannel is null: ${_webSocketChannel == null}");
      _showErrorDialog(
        "Cannot send audio: missing recording path or WebSocket connection",
      );
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
          _statusText = "Tap to start speaking";
          _waveController.stop();
          _waveController.reset();
        });
      }
    });
  }

  /// Send a test message to verify WebSocket connection
  void _sendTestMessage() {
    if (_webSocketChannel != null && _isConnected) {
      try {
        final testMessage = {"type": "ping", "message": "test_connection"};

        _webSocketChannel?.sink.add(jsonEncode(testMessage));

        if (mounted) {
          setState(() {
            _statusText = "Test message sent...";
          });
        }

        print("Test message sent: ${jsonEncode(testMessage)}");
      } catch (e) {
        print("Error sending test message: $e");
        _showErrorDialog("Failed to send test message: $e");
      }
    } else {
      _showErrorDialog("Not connected to server. Please connect first.");
    }
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
                color: Colors.black.withOpacity(0.1),
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
          "NEXORA",
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
                            color: Colors.black.withOpacity(0.1),
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
                                  ? "Microphone Ready"
                                  : "Microphone Access Needed",
                          isActive: _hasMicPermission,
                        ),
                        const SizedBox(width: 20),
                        _buildStatusIndicator(
                          icon:
                              _isConnected ? Iconsax.wifi : Iconsax.cloud_cross,
                          label: _isConnected ? "Connected" : "Disconnected",
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
                                      .withOpacity(0.3),
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
                        : "Tap to start speaking",
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
                      ).withOpacity(0.1 + (_waveAnimation.value * 0.2)),
                      const Color(0xFF7C3AED).withOpacity(0.05),
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
                      ).withOpacity(0.2 + (_waveAnimation.value * 0.3)),
                      const Color(0xFF8B5CF6).withOpacity(0.1),
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
                      ).withOpacity(0.3 + (_waveAnimation.value * 0.4)),
                      const Color(0xFFA855F7).withOpacity(0.15),
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
                      const Color(0xFF7C3AED).withOpacity(0.15),
                      const Color(0xFF7C3AED).withOpacity(0.05),
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
                      const Color(0xFF8B5CF6).withOpacity(0.25),
                      const Color(0xFF8B5CF6).withOpacity(0.1),
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
                      const Color(0xFFEF4444).withOpacity(0.3),
                      const Color(0xFFEF4444).withOpacity(0.1),
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
                    .withOpacity(0.4),
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
                ? const Color(0xFF10B981).withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isActive
                  ? const Color(0xFF10B981).withOpacity(0.3)
                  : Colors.red.withOpacity(0.3),
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
