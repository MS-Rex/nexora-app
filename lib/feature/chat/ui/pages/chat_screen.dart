import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

@RoutePage()
class ChatViewPage extends StatefulWidget {
  const ChatViewPage({super.key});

  @override
  State<ChatViewPage> createState() => _ChatViewPageState();
}

class _ChatViewPageState extends State<ChatViewPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _messageController.clear();
    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUser: true));
      _messages.insert(
        0,
        ChatMessage(text: "Hello! How may I assist you today?", isUser: false),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chat_bubble_rounded),
          onPressed: () {},
        ),
        centerTitle: true,
        title: Text(
          "NEXORA",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.logout_rounded)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                      ),
                      onSubmitted: _handleSubmitted,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.send_1),
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        _handleSubmitted(_messageController.text);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser ? Color.fromARGB(255, 124, 58, 237) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              text,
              style: TextStyle(color: isUser ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
