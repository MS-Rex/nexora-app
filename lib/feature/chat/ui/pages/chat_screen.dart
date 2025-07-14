import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/config/routes/app_routes.dart';
import '../../../../feature/auth/bloc/auth_bloc.dart';
import '../../../../feature/chat/ui/bloc/chat_bloc.dart';
import '../../../../core/common/storage/token_service.dart';
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
  final TokenService _tokenService = getIt<TokenService>();
  String? _userEmail;
  String? _userFirstName;

  @override
  void initState() {
    super.initState();
    // Load existing chat messages if sessionId is provided
    if (widget.sessionId != null && widget.sessionId!.isNotEmpty) {
      _chatBloc.add(ChatEvent.loadChatHistory(widget.sessionId!));
    }
    // Load user email and first name for avatar and welcome message
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final email = await _tokenService.getUserEmail();
    final firstName = await _tokenService.getUserFirstName();
    if (mounted) {
      setState(() {
        _userEmail = email;
        _userFirstName = firstName;
      });
    }
  }

  String _getAvatarUrl() {
    if (_userEmail == null) return '';
    // URL encode the email for the Vercel avatar API
    final encodedEmail = Uri.encodeComponent(_userEmail!);
    return 'https://avatar.vercel.sh/$encodedEmail.svg';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _chatBloc.close();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    // Dismiss keyboard when message is sent
    FocusScope.of(context).unfocus();

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

  void _onActionButtonPressed(String message) {
    _messageController.text = message;
  }

  void _startNewChat() {
    // Check if it's already a new chat (no sessionId and no messages)
    final isAlreadyNewChat =
        (widget.sessionId == null || widget.sessionId!.isEmpty) &&
        _messages.isEmpty;

    if (!isAlreadyNewChat) {
      // Clear current messages and reset to new chat
      setState(() {
        _messages.clear();
      });
    }
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
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // Main content area
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
            // Custom app bar using Row
            Positioned(
              top: MediaQuery.of(context).padding.top + 8.h,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Menu button
                    GestureDetector(
                      onTap: () {
                        // Navigate to chat history page
                        context.router.push(const ChatHistoryRoute());
                      },
                      child: CircleAvatar(
                        radius: 24.r,
                        backgroundColor: const Color(
                          0xFF7F22FE,
                        ).withValues(alpha: 0.1),
                        child: Icon(
                          Icons.menu,
                          color: Colors.black,
                          size: 24.sp,
                        ),
                      ),
                    ),
                    // Right side actions
                    Row(
                      children: [
                        // New chat button
                        GestureDetector(
                          onTap: _startNewChat,
                          child: CircleAvatar(
                            radius: 24.r,
                            backgroundColor: const Color(
                              0xFF7F22FE,
                            ).withValues(alpha: 0.1),
                            child: SvgPicture.asset(
                              'assets/images/chat_add.svg',
                              colorFilter: ColorFilter.mode(
                                const Color(0xFF7F22FE),
                                BlendMode.srcIn,
                              ),
                              width: 24.sp,
                              height: 24.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Profile avatar
                        GestureDetector(
                          onTap: _showLogoutConfirmationDialog,
                          child: CircleAvatar(
                            radius: 20.r,
                            backgroundColor: const Color(0xFF00D4AA),
                            backgroundImage:
                                _userEmail != null && _getAvatarUrl().isNotEmpty
                                    ? NetworkImage(_getAvatarUrl())
                                    : null,
                            child:
                                _userEmail == null || _getAvatarUrl().isEmpty
                                    ? Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 20.sp,
                                    )
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              top:
                  ScreenUtil().statusBarHeight +
                  64.h, // Space for custom app bar
              bottom: 80.h, // Space for ChatInput
              child:
                  _messages.isEmpty
                      ? Center(
                        child: WelcomeContent(
                          onActionButtonPressed: _onActionButtonPressed,
                          firstName: _userFirstName,
                        ),
                      )
                      : ListView.builder(
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        cacheExtent: 1000.0, // Cache off-screen items for smoother scrolling
                        addAutomaticKeepAlives: true, // Keep widgets alive when scrolled off-screen
                        addRepaintBoundaries: true, // Isolate repaints per item
                        padding: EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 8.0,
                          bottom:
                              100.h, // Extra bottom margin to avoid ChatInput overlap
                        ),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) => RepaintBoundary(
                          child: _messages[index],
                        ),
                      ),
            ),
            // ChatInput at the bottom
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: MediaQuery.of(context).viewInsets.bottom + 32.h,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ChatInput(
                  messageController: _messageController,
                  onSubmitted: _handleSubmitted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
