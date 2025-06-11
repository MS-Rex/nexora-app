// Reusable Gradient Background Widget
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE8F0FE), // Light blue gradient (top)
            Color(0xFFF5F7FA), // Lighter shade (bottom)
          ],
        ),
      ),
      child: child,
    );
  }
}
