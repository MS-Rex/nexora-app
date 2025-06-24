import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutDialog({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          'Log out of Nexora?',
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You will be signed out of your account.',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          SizedBox(height: 32.h),
          Divider(color: Colors.grey, height: 1),
        ],
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  backgroundColor: Color(0xFF7F22FE).withValues(alpha: 0.05),
                  foregroundColor: Color(0xFF7F22FE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: const Text(
                  'STAY',
                  style: TextStyle(color: Color(0xFF7F22FE)),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onLogout();
                },
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  backgroundColor: Color(0xFF7F22FE),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),

                child: const Text(
                  'LOG OUT',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static void show(BuildContext context, VoidCallback onLogout) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogoutDialog(onLogout: onLogout);
      },
    );
  }
}
