import 'package:flutter/material.dart';

class ChatPageEmptyWidget extends StatelessWidget {
  const ChatPageEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Image.asset(
          'assets/images/logo.png',
          height: 120,
          width: 150,
          color: Colors.black,
        ),
        Text(
          'Welcome to\nNexora 👋',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Text(
            "Hi, you can ask me anything about the campus",
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.black54),
          ),
        ),
        const Spacer(),

        const SizedBox(height: 80),
      ],
    );
  }
}
