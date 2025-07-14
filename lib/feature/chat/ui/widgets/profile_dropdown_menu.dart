import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/config/routes/app_routes.dart';
import '../../../../core/localization/app_localization_extension.dart';
import '../../../../core/localization/localization.dart';
import '../../../../injector.dart';
import 'logout_dialog.dart';

class ProfileDropdownMenu extends StatelessWidget {
  final VoidCallback onLogout;
  final String? userEmail;
  final String avatarUrl;

  const ProfileDropdownMenu({
    super.key,
    required this.onLogout,
    this.userEmail,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: Offset(0, 50.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: CircleAvatar(
        radius: 20.r,
        backgroundColor: const Color(0xFF00D4AA),
        backgroundImage: userEmail != null && avatarUrl.isNotEmpty
            ? NetworkImage(avatarUrl)
            : null,
        child: userEmail == null || avatarUrl.isEmpty
            ? Icon(
                Icons.person,
                color: Colors.white,
                size: 20.sp,
              )
            : null,
      ),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'language',
          child: _buildMenuItem(
            icon: Icons.language,
            title: context.l10n.language,
            subtitle: _getLanguageSubtitle(context),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'logout',
          child: _buildMenuItem(
            icon: Icons.logout,
            title: context.l10n.logout,
            subtitle: _getLogoutSubtitle(context),
            isDestructive: true,
          ),
        ),
      ],
      onSelected: (String value) {
        switch (value) {
          case 'language':
            _navigateToLanguageSettings(context);
            break;
          case 'logout':
            _showLogoutDialog(context);
            break;
        }
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : Colors.black87;
    final iconColor = isDestructive ? Colors.red : const Color(0xFF7F22FE);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLanguageSubtitle(BuildContext context) {
    // Get current locale from localization service if available
    try {
      final localizationService = getIt<LocalizationService>();
      final currentLocale = localizationService.currentLocale.languageCode;
      
      switch (currentLocale) {
        case 'si':
          return 'යෙදුමේ භාෂාව වෙනස් කරන්න';
        case 'ta':
          return 'பயன்பாட்டின் மொழியை மாற்றவும்';
        case 'en':
        default:
          return 'Change app language';
      }
    } catch (e) {
      return 'Change app language';
    }
  }

  String _getLogoutSubtitle(BuildContext context) {
    // Get current locale from localization service if available
    try {
      final localizationService = getIt<LocalizationService>();
      final currentLocale = localizationService.currentLocale.languageCode;
      
      switch (currentLocale) {
        case 'si':
          return 'ඔබේ ගිණුමෙන් ඉවත් වන්න';
        case 'ta':
          return 'உங்கள் கணக்கிலிருந்து வெளியேறவும்';
        case 'en':
        default:
          return 'Sign out of your account';
      }
    } catch (e) {
      return 'Sign out of your account';
    }
  }

  void _navigateToLanguageSettings(BuildContext context) {
    context.router.push(const LanguageSettingsRoute());
  }

  void _showLogoutDialog(BuildContext context) {
    LogoutDialog.show(context, onLogout);
  }

  static Widget create({
    required VoidCallback onLogout,
    String? userEmail,
    required String avatarUrl,
  }) {
    return ProfileDropdownMenu(
      onLogout: onLogout,
      userEmail: userEmail,
      avatarUrl: avatarUrl,
    );
  }
}