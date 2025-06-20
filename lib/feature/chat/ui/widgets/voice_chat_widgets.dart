import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AnimatedVoiceCircle extends StatelessWidget {
  final bool isListening;
  final bool isAISpeaking;
  final Animation<double> waveAnimation;
  final Animation<double> pulseAnimation;

  const AnimatedVoiceCircle({
    super.key,
    required this.isListening,
    required this.isAISpeaking,
    required this.waveAnimation,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outermost wave circle (when AI is speaking)
        if (isAISpeaking)
          AnimatedBuilder(
            animation: waveAnimation,
            builder: (context, child) {
              return Container(
                width: 200 - (waveAnimation.value * 30),
                height: 200 - (waveAnimation.value * 30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(
                        0xFF7C3AED,
                      ).withValues(alpha: 0.1 + (waveAnimation.value * 0.2)),
                      const Color(0xFF7C3AED).withValues(alpha: 0.05),
                    ],
                  ),
                ),
              );
            },
          ),

        // Second wave circle
        if (isAISpeaking)
          AnimatedBuilder(
            animation: waveAnimation,
            builder: (context, child) {
              return Container(
                width: 160 - (waveAnimation.value * 20),
                height: 160 - (waveAnimation.value * 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(
                        0xFF8B5CF6,
                      ).withValues(alpha: 0.2 + (waveAnimation.value * 0.3)),
                      const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    ],
                  ),
                ),
              );
            },
          ),

        // Third wave circle
        if (isAISpeaking)
          AnimatedBuilder(
            animation: waveAnimation,
            builder: (context, child) {
              return Container(
                width: 120 - (waveAnimation.value * 10),
                height: 120 - (waveAnimation.value * 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(
                        0xFFA855F7,
                      ).withValues(alpha: 0.3 + (waveAnimation.value * 0.4)),
                      const Color(0xFFA855F7).withValues(alpha: 0.15),
                    ],
                  ),
                ),
              );
            },
          ),

        // Breathing circles (when idle)
        if (!isAISpeaking && !isListening)
          AnimatedBuilder(
            animation: pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 140 * pulseAnimation.value,
                height: 140 * pulseAnimation.value,
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

        if (!isAISpeaking && !isListening)
          AnimatedBuilder(
            animation: pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 100 * pulseAnimation.value,
                height: 100 * pulseAnimation.value,
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
        if (isListening)
          AnimatedBuilder(
            animation: pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 120 * pulseAnimation.value,
                height: 120 * pulseAnimation.value,
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
                  isListening
                      ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                      : isAISpeaking
                      ? [const Color(0xFF7C3AED), const Color(0xFF8B5CF6)]
                      : [const Color(0xFF7C3AED), const Color(0xFF8B5CF6)],
            ),
            boxShadow: [
              BoxShadow(
                color: (isListening
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
            isListening
                ? Iconsax.microphone
                : isAISpeaking
                ? Iconsax.sound
                : Iconsax.cpu,
            size: 35,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const StatusIndicator({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
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

class StatusMessageBubble extends StatelessWidget {
  final String message;

  const StatusMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
        message,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class MicrophoneButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback onTap;
  final Animation<double> pulseAnimation;

  const MicrophoneButton({
    super.key,
    required this.isListening,
    required this.onTap,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isListening ? pulseAnimation.value : 1.0,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors:
                      isListening
                          ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                          : [const Color(0xFF7C3AED), const Color(0xFF8B5CF6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isListening
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
                isListening ? Iconsax.stop : Iconsax.microphone,
                size: 35,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
