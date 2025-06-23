import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexora/core/localization/app_localization_extension.dart';

class WelcomeContent extends StatelessWidget {
  final Function(String)? onActionButtonPressed;
  final String? firstName;

  const WelcomeContent({super.key, this.onActionButtonPressed, this.firstName});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting message
          Text(
            firstName != null && firstName!.isNotEmpty
                ? "Hey $firstName, how can I help you today?"
                : "Hey there, how can I help you today?",
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          // Description
          Text(
            "I'm Nexora, your campus AI assistant. I can help you find class schedules and bus schedules, cafeteria menus, and many more",
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          // Action buttons in 2x2 grid
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.8,
            children: [
              _buildActionButton(
                context,
                icon: Icons.calendar_today,
                iconColor: const Color(0xFF3B82F6),
                backgroundColor: const Color(0xFFDCEEFF),
                title: "Class Schedule",
                onTap: () {
                  onActionButtonPressed?.call(
                    "Give me information about Class Schedule",
                  );
                },
              ),
              _buildActionButton(
                context,
                icon: Icons.directions_bus,
                iconColor: const Color(0xFF10B981),
                backgroundColor: const Color(0xFFD1FAE5),
                title: "Bus Timing",
                onTap: () {
                  onActionButtonPressed?.call(
                    "Give me information about Bus Timing",
                  );
                },
              ),
              _buildActionButton(
                context,
                icon: Icons.restaurant_menu,
                iconColor: const Color(0xFF8B5CF6),
                backgroundColor: const Color(0xFFE9D5FF),
                title: "Cafeteria Menu",
                onTap: () {
                  onActionButtonPressed?.call(
                    "Give me information about Cafeteria Menu",
                  );
                },
              ),
              _buildActionButton(
                context,
                icon: Icons.event,
                iconColor: const Color(0xFFEF4444),
                backgroundColor: const Color(0xFFFECDD3),
                title: "Campus Events",
                onTap: () {
                  onActionButtonPressed?.call(
                    "Give me information about Campus Events",
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          // color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
