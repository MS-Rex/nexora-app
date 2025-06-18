import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/routes/app_routes.dart';
import '../../../../feature/auth/bloc/auth_bloc.dart';
import '../../../../feature/chat/ui/bloc/chat_bloc.dart';
import '../widgets/chat_message.dart';
import '../../api/chat_api.dart' as api;

mixin ChatEventHandlerMixin<T extends StatefulWidget> on State<T> {
  void handleSubmitted(
    String text,
    TextEditingController messageController,
    List<ChatMessage> messages,
    ChatBloc chatBloc, {
    String? sessionId,
  }) {
    if (text.trim().isEmpty) return;

    messageController.clear();
    setState(() {
      messages.insert(0, ChatMessage(text: text, isUser: true));
    });

    // Send message through bloc
    chatBloc.add(ChatEvent.sendMessage(text, sessionId: sessionId));
  }

  void handleLogout(AuthBloc authBloc) {
    authBloc.add(LogoutRequested());
  }

  void handleAuthStateChange(AuthState state) {
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
  }

  void handleChatStateChange(ChatState state, List<ChatMessage> messages) {
    // Handle chat history loaded state
    if (state.runtimeType.toString().contains('_ChatHistoryLoaded')) {
      final historyState = state as dynamic;
      final apiMessages = historyState.messages as List<api.ChatMessage>;

      setState(() {
        messages.clear();
        // Convert API messages to UI messages and add them in reverse chronological order
        // so that the newest messages are at index 0 (which appears at bottom due to ListView reverse: true)
        for (int i = apiMessages.length - 1; i >= 0; i--) {
          var apiMessage = apiMessages[i];
          messages.add(
            ChatMessage(text: apiMessage.text, isUser: apiMessage.isUser),
          );
        }
      });
      return;
    }

    // Handle chat history loading state
    if (state.runtimeType.toString().contains('_ChatHistoryLoading')) {
      setState(() {
        messages.clear();
        messages.add(
          const ChatMessage(
            text: 'Loading chat history...',
            isUser: false,
            isLoading: true,
          ),
        );
      });
      return;
    }

    // Handle loading state - add loading message
    if (state.runtimeType.toString().contains('_Loading')) {
      setState(() {
        // Add loading message if not already present
        if (messages.isEmpty || !messages[0].text.contains('...')) {
          messages.insert(
            0,
            const ChatMessage(
              text: 'Thinking...',
              isUser: false,
              isLoading: true,
            ),
          );
        }
      });
    }
    // Handle success state - replace loading with actual response
    else if (state.runtimeType.toString().contains('_Success')) {
      final successState = state as dynamic;
      final reply = successState.reply as String?;

      setState(() {
        // Remove loading message if present
        if (messages.isNotEmpty && messages[0].text.contains('Thinking...')) {
          messages.removeAt(0);
        }

        if (reply != null && reply.isNotEmpty) {
          messages.insert(0, ChatMessage(text: reply, isUser: false));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Received empty response from server'),
            ),
          );
        }
      });
    }
    // Handle failure state - remove loading and show error
    else if (state.runtimeType.toString().contains('_Failure')) {
      final failureState = state as dynamic;
      setState(() {
        // Remove loading message if present
        if (messages.isNotEmpty && messages[0].text.contains('Thinking...')) {
          messages.removeAt(0);
        }
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${failureState.error}')));
    }
  }
}
