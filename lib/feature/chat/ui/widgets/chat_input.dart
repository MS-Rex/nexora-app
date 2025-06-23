import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/config/routes/app_routes.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController messageController;
  final Function(String) onSubmitted;

  const ChatInput({
    super.key,
    required this.messageController,
    required this.onSubmitted,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.messageController.addListener(_onTextChanged);
    _hasText = widget.messageController.text.isNotEmpty;
  }

  @override
  void dispose() {
    widget.messageController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.messageController.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _handleSendMessage() {
    final text = widget.messageController.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmitted(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: TextField(
                controller: widget.messageController,
                decoration: InputDecoration(
                  hintText: 'Message Nexora',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                ),
                onSubmitted: widget.onSubmitted,
                textInputAction: TextInputAction.send,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap:
                _hasText
                    ? _handleSendMessage
                    : () {
                      // Navigate to voice chat page
                      context.router.push(const VoiceChatRoute());
                    },
            child: Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED),
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Icon(
                _hasText ? Icons.send : Iconsax.microphone_2,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
