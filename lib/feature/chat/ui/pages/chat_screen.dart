import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/routes/app_routes.dart';
import '../../../../feature/auth/bloc/auth_bloc.dart';
import '../../../../feature/chat/ui/bloc/chat_bloc.dart';
import '../../../../injector.dart';
import '../widgets/widgets.dart';
import '../mixins/chat_event_handler_mixin.dart';

@RoutePage()
class ChatViewPage extends StatefulWidget {
  final String? sessionId;

  const ChatViewPage({super.key, this.sessionId});

  @override
  State<ChatViewPage> createState() => _ChatViewPageState();
}

class _ChatViewPageState extends State<ChatViewPage>
    with ChatEventHandlerMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final AuthBloc _authBloc = getIt<AuthBloc>();
  final ChatBloc _chatBloc = getIt<ChatBloc>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load existing chat messages if sessionId is provided
    if (widget.sessionId != null && widget.sessionId!.isNotEmpty) {
      _chatBloc.add(ChatEvent.loadChatHistory(widget.sessionId!));
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _chatBloc.close();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    handleSubmitted(
      text,
      _messageController,
      _messages,
      _chatBloc,
      sessionId: widget.sessionId,
    );
  }

  void _showLogoutConfirmationDialog() {
    LogoutDialog.show(context, () => handleLogout(_authBloc));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          bloc: _authBloc,
          listener: (context, state) => handleAuthStateChange(state),
        ),
        BlocListener<ChatBloc, ChatState>(
          bloc: _chatBloc,
          listener: (context, state) => handleChatStateChange(state, _messages),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
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
                      ? const WelcomeContent()
                      : ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(8.0),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) => _messages[index],
                      ),
            ),
            ChatInput(
              messageController: _messageController,
              onSubmitted: _handleSubmitted,
            ),
          ],
        ),
      ),
    );
  }
}
