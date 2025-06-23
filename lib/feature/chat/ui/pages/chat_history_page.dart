import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/config/routes/app_routes.dart';
import '../../bloc/chat_history_bloc.dart';
import '../../../../injector.dart';
import '../../../../core/localization/app_localization_extension.dart';

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
        title: Text(
          context.l10n.chatHistory,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/def_background.png',
              height: ScreenUtil().screenHeight,
              width: ScreenUtil().screenWidth,
              fit: BoxFit.cover,
            ),
          ),
          BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
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
                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.3),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                          child: ListTile(
                            title: Text(chat.title),
                            subtitle: Text(chat.lastMessage),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red.shade300,
                              ),
                              onPressed: () {
                                // TODO: Add delete functionality
                              },
                            ),
                            onTap: () {
                              context.router.push(
                                ChatViewRoute(sessionId: chat.sessionId),
                              );
                            },
                          ),
                        );
                      },
                    );
              } else {
                return const Center(child: Text('No data available'));
              }
            },
          ),
        ],
      ),
    );
  }
}
