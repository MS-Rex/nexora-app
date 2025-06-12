import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/config/routes/app_routes.dart';
import '../../../../feature/auth/bloc/auth_bloc.dart';
import '../../../../feature/chat/ui/bloc/chat_bloc.dart';
import '../../../../feature/chat/api/chat_api.dart' as api;
import '../../../../injector.dart';

@RoutePage()
class ChatViewPage extends StatefulWidget {
  const ChatViewPage({super.key});

  @override
  State<ChatViewPage> createState() => _ChatViewPageState();
}

class _ChatViewPageState extends State<ChatViewPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final AuthBloc _authBloc = getIt<AuthBloc>();
  final ChatBloc _chatBloc = getIt<ChatBloc>();
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    _chatBloc.close();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _messageController.clear();
    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });

    // Send message through bloc
    _chatBloc.add(ChatEvent.sendMessage(text));
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Color.fromARGB(255, 124, 58, 237)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleLogout();
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Color.fromARGB(255, 124, 58, 237)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout() {
    _authBloc.add(LogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          bloc: _authBloc,
          listener: (context, state) {
            if (state is LogoutSuccess) {
              // Navigate to login page on successful logout
              context.router.pushAndPopUntil(
                const LoginRoute(),
                predicate: (route) => false,
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
        BlocListener<ChatBloc, ChatState>(
          bloc: _chatBloc,
          listener: (context, state) {
            setState(() {
              _isLoading = false;
            });

            // Temporary approach while build runner completes
            if (state.toString().contains('success')) {
              final replyMatch = RegExp(
                r'reply: ([^)]+)',
              ).firstMatch(state.toString());
              if (replyMatch != null) {
                final reply = replyMatch.group(1)!;
                setState(() {
                  _messages.insert(0, ChatMessage(text: reply, isUser: false));
                });
              }
            } else if (state.toString().contains('failure')) {
              final errorMatch = RegExp(
                r'error: ([^)]+)',
              ).firstMatch(state.toString());
              if (errorMatch != null) {
                final error = errorMatch.group(1)!;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Error: $error')));
              }
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.chat_bubble_rounded),
            onPressed: () {
              // Navigate to chat history page
              context.router.push(const ChatHistoryRoute());
            },
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
            IconButton(
              onPressed: _showLogoutConfirmationDialog,
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child:
                  _messages.isEmpty
                      ? _buildWelcomeContent()
                      : ListView.builder(
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
                      icon: const Icon(Iconsax.microphone_2),
                      onPressed: () {
                        // Navigate to voice chat page
                        context.router.push(const VoiceChatRoute());
                      },
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
      ),
    );
  }

  Widget _buildWelcomeContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // NEXORA Logo/Text
          Text(
            "NEXORA",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 80),
          // Welcome suggestion widget
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
              color: const Color(0xFFE8E3FF), // Light purple background
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF7C3AED,
                    ), // Purple background for icon
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Hi, Ask me anything about the Campus",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
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
