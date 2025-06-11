import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bloc/voice_chat_bloc.dart';
import '../widgets/voice_chat_widgets.dart';

@RoutePage()
class VoiceChatScreenRefactored extends StatefulWidget {
  const VoiceChatScreenRefactored({super.key});

  @override
  State<VoiceChatScreenRefactored> createState() =>
      _VoiceChatScreenRefactoredState();
}

class _VoiceChatScreenRefactoredState extends State<VoiceChatScreenRefactored>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  late Animation<double> _waveAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

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

    // Initialize the voice chat
    context.read<VoiceChatBloc>().add(VoiceChatInitialize());
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    final bloc = context.read<VoiceChatBloc>();
    final state = bloc.state;

    if (state.isListening) {
      bloc.add(VoiceChatStopListening());
    } else {
      if (!state.hasMicPermission) {
        _showPermissionDialog();
        return;
      }
      bloc.add(VoiceChatStartListening());
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
          child: BlocConsumer<VoiceChatBloc, VoiceChatState>(
            listener: (context, state) {
              // Handle side effects
              if (state.error != null) {
                _showErrorDialog(state.error!);
              }

              // Control animations based on state
              if (state.isAISpeaking) {
                _waveController.repeat();
                _pulseController.stop();
              } else if (state.isListening) {
                _waveController.stop();
                _pulseController.repeat(reverse: true);
              } else {
                _waveController.stop();
                _waveController.reset();
                _pulseController.repeat(reverse: true);
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  // Main content area
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // AI Voice Animation
                        Container(
                          width: 200,
                          height: 200,
                          margin: const EdgeInsets.only(bottom: 30),
                          child: AnimatedVoiceCircle(
                            isListening: state.isListening,
                            isAISpeaking: state.isAISpeaking,
                            waveAnimation: _waveAnimation,
                            pulseAnimation: _pulseAnimation,
                          ),
                        ),

                        // Status message in chat bubble
                        StatusMessageBubble(message: state.statusText),

                        const SizedBox(height: 30),

                        // Connection status indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StatusIndicator(
                              icon:
                                  state.hasMicPermission
                                      ? Iconsax.microphone
                                      : Iconsax.microphone_slash,
                              label:
                                  state.hasMicPermission
                                      ? "Microphone Ready"
                                      : "Microphone Access Needed",
                              isActive: state.hasMicPermission,
                            ),
                            const SizedBox(width: 20),
                            StatusIndicator(
                              icon:
                                  state.isConnected
                                      ? Iconsax.wifi
                                      : Iconsax.cloud_cross,
                              label:
                                  state.isConnected
                                      ? "Connected"
                                      : "Disconnected",
                              isActive: state.isConnected,
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
                      MicrophoneButton(
                        isListening: state.isListening,
                        onTap: _toggleListening,
                        pulseAnimation: _pulseAnimation,
                      ),

                      const SizedBox(height: 20),

                      // Instructions
                      Text(
                        state.isListening
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
              );
            },
          ),
        ),
      ),
    );
  }
}
