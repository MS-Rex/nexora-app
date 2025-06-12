import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/config/routes/app_routes.dart';
import '../../bloc/chat_history_bloc.dart';
import '../../../../injector.dart';

@RoutePage()
class ChatHistoryPage extends StatefulWidget {
  const ChatHistoryPage({super.key});

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  final ChatHistoryBloc _chatHistoryBloc = getIt<ChatHistoryBloc>();

  @override
  void initState() {
    super.initState();
    _chatHistoryBloc.add(FetchChatHistory());
  }

  @override
  void dispose() {
    _chatHistoryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
        bloc: _chatHistoryBloc,
        builder: (context, state) {
          if (state is ChatHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatHistoryError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is ChatHistoryLoaded) {
            return state.chatHistory.isEmpty
                ? const Center(child: Text('No chat history found'))
                : ListView.builder(
                  itemCount: state.chatHistory.length,
                  itemBuilder: (context, index) {
                    final chat = state.chatHistory[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Iconsax.user)),
                      title: Text(chat.title),
                      subtitle: Text(chat.lastMessage),
                      trailing: Text(chat.timestamp),
                      onTap: () {
                        // Navigate to the chat screen with the selected chat
                        context.router.push(const ChatViewRoute());
                      },
                    );
                  },
                );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a new chat
          context.router.push(const ChatViewRoute());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
