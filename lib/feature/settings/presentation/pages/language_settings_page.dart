import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexora/core/localization/localization.dart';
import 'package:nexora/core/widgets/language_selector_widget.dart';
import 'package:nexora/injector.dart';

@RoutePage()
class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image matching voice chat page
          Image.asset(
            'assets/images/def_background.png',
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            fit: BoxFit.cover,
          ),
          // Custom app bar matching voice chat page
          Positioned(
            top: ScreenUtil().statusBarHeight,
            left: 0,
            right: 0,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF7F22FE)),
                  onPressed: () => context.router.pop(),
                ),
                Expanded(
                  child: Text(
                    context.l10n.language,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(width: 48.w), // Balance the back button
              ],
            ),
          ),
          // Main content
          Positioned.fill(
            top: ScreenUtil().statusBarHeight + 60.h,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page title and description
                  Text(
                    context.l10n.selectLanguage,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _getDescriptionText(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Language selector
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.language,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          const LanguageSelectorWidget(),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDescriptionText(BuildContext context) {
    final localizationService = getIt<LocalizationService>();
    switch (localizationService.currentLocale.languageCode) {
      case 'si':
        return 'ඔබගේ කැමති භාෂාව තෝරා ගන්න. යෙදුම ඔබගේ තේරීම මතක තබා ගනී.';
      case 'ta':
        return 'உங்கள் விருப்பமான மொழியைத் தேர்ந்தெடுக்கவும். ஆப் உங்கள் தேர்வை நினைவில் வைத்துக் கொள்ளும்.';
      case 'en':
      default:
        return 'Choose your preferred language. The app will remember your selection.';
    }
  }

}
