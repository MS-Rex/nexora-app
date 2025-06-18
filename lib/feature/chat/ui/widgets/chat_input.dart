import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/config/routes/app_routes.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController messageController;
  final Function(String) onSubmitted;

  const ChatInput({
    super.key,
    required this.messageController,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
                onSubmitted: onSubmitted,
              ),
            ),
            IconButton(
              icon: const Icon(Iconsax.microphone_2),
              onPressed: () {
                // Navigate to voice chat page
                context.router.push(const VoiceChatRoute());
              },
            ),
            IconButton(
              icon: const Icon(Iconsax.send_1),
              onPressed: () {
                if (messageController.text.isNotEmpty) {
                  onSubmitted(messageController.text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
