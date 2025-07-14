class LocalizedString {
  final String key;
  final String en;
  final String si;
  final String ta;

  const LocalizedString({
    required this.key,
    required this.en,
    required this.si,
    required this.ta,
  });
}

class LocalizationStrings {
  static const List<LocalizedString> values = [
    LocalizedString(
      key: 'app_name',
      en: 'Nexora',
      si: 'නෙක්සෝරා',
      ta: 'நெக்சோரா',
    ),
    LocalizedString(
      key: 'welcome',
      en: 'Welcome',
      si: 'සාදරයෙන් පිළිගන්නවා',
      ta: 'வரவேற்கிறோம்',
    ),
    LocalizedString(key: 'login', en: 'LOGIN', si: 'ප්‍රවේශය', ta: 'உள்நுழைய'),
    LocalizedString(key: 'logout', en: 'Logout', si: 'පිටවීම', ta: 'வெளியேறு'),
    LocalizedString(
      key: 'register',
      en: 'Register',
      si: 'ලියාපදිංචිය',
      ta: 'பதிவு செய்',
    ),
    LocalizedString(key: 'email', en: 'Email', si: 'ඊමේල්', ta: 'மின்னஞ்சல்'),
    LocalizedString(
      key: 'password',
      en: 'Password',
      si: 'මුරපදය',
      ta: 'கடவுச்சொல்',
    ),
    LocalizedString(
      key: 'confirm_password',
      en: 'Confirm Password',
      si: 'මුරපදය තහවුරු කරන්න',
      ta: 'கடவுச்சொல்லை உறுதிப்படுத்தவும்',
    ),
    LocalizedString(
      key: 'forgot_password',
      en: 'Forgot Password?',
      si: 'මුරපදය අමතකද?',
      ta: 'கடவுச்சொல் மறந்துவிட்டதா?',
    ),
    LocalizedString(
      key: 'reset_password',
      en: 'Reset Password',
      si: 'මුරපදය නැවත සකසන්න',
      ta: 'கடவுச்சொல்லை மீட்டமை',
    ),
    LocalizedString(
      key: 'submit',
      en: 'Submit',
      si: 'ඉදිරිපත් කරන්න',
      ta: 'சமர்ப்பிக்கவும்',
    ),
    LocalizedString(
      key: 'cancel',
      en: 'Cancel',
      si: 'අවලංගු කරන්න',
      ta: 'ரத்துசெய்',
    ),
    LocalizedString(key: 'save', en: 'Save', si: 'සුරකින්න', ta: 'சேமிக்க'),
    LocalizedString(key: 'delete', en: 'Delete', si: 'මකන්න', ta: 'நீக்கு'),
    LocalizedString(key: 'edit', en: 'Edit', si: 'සංස්කරණය', ta: 'திருத்து'),
    LocalizedString(key: 'yes', en: 'Yes', si: 'ඔව්', ta: 'ஆம்'),
    LocalizedString(key: 'no', en: 'No', si: 'නැත', ta: 'இல்லை'),
    LocalizedString(key: 'ok', en: 'OK', si: 'හරි', ta: 'சரி'),
    LocalizedString(key: 'error', en: 'Error', si: 'දෝෂය', ta: 'பிழை'),
    LocalizedString(
      key: 'success',
      en: 'Success',
      si: 'සාර්ථකයි',
      ta: 'வெற்றி',
    ),
    LocalizedString(
      key: 'loading',
      en: 'Loading...',
      si: 'පූරණය වෙමින්...',
      ta: 'ஏற்றுகிறது...',
    ),
    LocalizedString(
      key: 'no_data_found',
      en: 'No data found',
      si: 'දත්ත සොයා ගත නොහැක',
      ta: 'தரவு கிடைக்கவിல்லை',
    ),
    LocalizedString(
      key: 'retry',
      en: 'Retry',
      si: 'නැවත උත්සාහ කරන්න',
      ta: 'மீண்டும் முயற்சிக்கவும்',
    ),
    LocalizedString(
      key: 'settings',
      en: 'Settings',
      si: 'සැකසුම්',
      ta: 'அமைப்புகள்',
    ),
    LocalizedString(key: 'language', en: 'Language', si: 'භාෂාව', ta: 'மொழி'),
    LocalizedString(
      key: 'select_language',
      en: 'Select Language',
      si: 'භාෂාව තෝරන්න',
      ta: 'மொழியைத் தேர்ந்தெடுக்கவும்',
    ),
    LocalizedString(
      key: 'english',
      en: 'English',
      si: 'ඉංග්‍රීසි',
      ta: 'ஆங்கிலம்',
    ),
    LocalizedString(key: 'sinhala', en: 'Sinhala', si: 'සිංහල', ta: 'சிங்களம்'),
    LocalizedString(key: 'tamil', en: 'Tamil', si: 'දෙමළ', ta: 'தமிழ்'),
    LocalizedString(key: 'search', en: 'Search', si: 'සොයන්න', ta: 'தேடு'),
    LocalizedString(key: 'filter', en: 'Filter', si: 'පෙරහන', ta: 'வடிகட்டி'),
    LocalizedString(
      key: 'sort',
      en: 'Sort',
      si: 'වර්ග කරන්න',
      ta: 'வரிசைப்படுத்து',
    ),
    LocalizedString(
      key: 'profile',
      en: 'Profile',
      si: 'පැතිකඩ',
      ta: 'சுயவிவரம்',
    ),
    LocalizedString(key: 'home', en: 'Home', si: 'මුල් පිටුව', ta: 'முகப்பு'),
    LocalizedString(key: 'back', en: 'Back', si: 'ආපසු', ta: 'பின்'),
    LocalizedString(key: 'next', en: 'CONTINUE', si: 'ඊළඟ', ta: 'தொடர்க'),
    LocalizedString(key: 'previous', en: 'Previous', si: 'පෙර', ta: 'முந்தைய'),
    LocalizedString(key: 'finish', en: 'Finish', si: 'අවසන්', ta: 'முடிக்க'),
    LocalizedString(key: 'skip', en: 'Skip', si: 'මගහරින්න', ta: 'தவிர்க்க'),
    LocalizedString(key: 'done', en: 'Done', si: 'අවසානයි', ta: 'முடிந்தது'),
    LocalizedString(key: 'close', en: 'Close', si: 'වසන්න', ta: 'மூடு'),
    LocalizedString(
      key: 'ask_me_anything',
      en: 'Hi, Ask me anything about University Related',
      si: 'හායි, විශ්වවිද්‍යාල ආශ්‍රිත ඕනෑම දෙයක් මගෙන් අහන්න',
      ta: 'வணக்கம், பல்கலைக்கழகம் தொடர்பான எதையும் என்னிடம் கேளுங்கள்',
    ),
    // Login screen specific strings
    LocalizedString(
      key: 'welcome_exclamation',
      en: 'Continue to Login',
      si: 'ප්‍රවේශය කිරීමට පවත්වා ගන්න',
      ta: 'உள்நுழையவும் தொடரவும்',
    ),
    LocalizedString(
      key: 'login_to_nexora',
      en:
          'Enter your email address to receive a one time password (OTP) for verification.',
      si: 'ප්‍රවේශ කිරීමට ඔබේ ඊමේල් ලිපිනය ඇතුළත් කරන්න',
      ta:
          'சரிபார்ப்புக்கு ஒரு முறை கடவுச்சொல் (OTP) பெற உங்கள் மின்னஞ்சல் முகவரியை உள்ளிடவும்',
    ),
    LocalizedString(
      key: 'processing',
      en: 'Processing...',
      si: 'සකසමින්...',
      ta: 'செயல்படுத்துகிறது...',
    ),
    LocalizedString(
      key: 'email_required',
      en: 'Email is required',
      si: 'ඊමේල් අවශ්‍ය වේ',
      ta: 'மின்னஞ்சல் தேவை',
    ),
    LocalizedString(
      key: 'enter_valid_email',
      en: 'Please enter a valid email',
      si: 'කරුණාකර වලංගු ඊමේල් ලිපිනයක් ඇතුළත් කරන්න',
      ta: 'தயவுசெய்து சரியான மின்னஞ்சலை உள்ளிடவும்',
    ),
    // Signup screen strings
    LocalizedString(
      key: 'sign_up_for_nexora',
      en: 'Sign Up for Nexora',
      si: 'නෙක්සෝරා සඳහා ලියාපදිංචි වන්න',
      ta: 'நெக்சோராவில் பதிவு செய்யவும்',
    ),
    LocalizedString(key: 'name', en: 'Name', si: 'නම', ta: 'பெயர்'),
    LocalizedString(
      key: 'sign_up',
      en: 'Sign Up',
      si: 'ලියාපදිංචි වන්න',
      ta: 'பதிவு செய்யவும்',
    ),
    // OTP verification strings
    LocalizedString(
      key: 'enter_otp',
      en: 'Enter the 6-digit code',
      si: '6 කින් යුත් කේතයක් ඇතුළත් කරන්න',
      ta: '6-இலக்க குறியீட்டை உள்ளிடவும்',
    ),
    LocalizedString(
      key: 'check_email_inbox',
      en: 'Enter the 6-digit code sent to your email to verify your identity',
      si: 'ප්‍රවේශ කිරීමට ඔබේ ඊමේල් ලිපිනය ඇතුළත් කරන්න',
      ta: 'உங்கள் மின்னஞ்சல் பெட்டியைச் சரிபார்க்கவும்',
    ),
    LocalizedString(
      key: 'verifying',
      en: 'Verifying...',
      si: 'සත්‍යාපනය කරමින්...',
      ta: 'சரிபார்க்கிறது...',
    ),
    LocalizedString(
      key: 'invalid_otp_format',
      en: 'Invalid OTP format',
      si: 'වලංගු නොවන OTP ආකෘතිය',
      ta: 'தவறான OTP வடிவம்',
    ),
    LocalizedString(
      key: 'enter_valid_six_digit_otp',
      en: 'Please enter a valid 6-digit OTP',
      si: 'කරුණාකර වලංගු ඉලක්කම් 6 කින් යුත් OTP එකක් ඇතුළත් කරන්න',
      ta: 'தயவுசெய்து சரியான 6-இலக்க OTP ஐ உள்ளிடவும்',
    ),
    // Chat and voice chat strings
    LocalizedString(
      key: 'chat_history',
      en: 'Chat History',
      si: 'කතාබස් ඉතිහාසය',
      ta: 'அரட்டை வரலாறு',
    ),
    LocalizedString(
      key: 'microphone_ready',
      en: 'Microphone Ready',
      si: 'මයික්‍රෆෝනය සකසා ඇත',
      ta: 'மைக்ரோஃபோன் தயார்',
    ),
    LocalizedString(
      key: 'connected_ready_to_listen',
      en: 'Connected - Ready to listen',
      si: 'සම්බන්ධයි - ඇසීමට සකසා ඇත',
      ta: 'இணைக்கப்பட்டது - கேட்க தயார்',
    ),
    LocalizedString(
      key: 'tap_to_start_speaking',
      en: 'Tap to start speaking',
      si: 'කතා කිරීම ආරම්භ කිරීමට ස්පර්ශ කරන්න',
      ta: 'பேச ஆரம்பிக்க தொடவும்',
    ),
    LocalizedString(
      key: 'connected',
      en: 'Connected',
      si: 'සම්බන්ධයි',
      ta: 'இணைக்கப்பட்டது',
    ),
    LocalizedString(
      key: 'disconnected',
      en: 'Disconnected',
      si: 'විසන්ධි වී ඇත',
      ta: 'துண்டிக்கப்பட்டது',
    ),
    // Error message strings
    LocalizedString(
      key: 'error_connection',
      en: 'Unable to connect. Please check your internet connection.',
      si: 'සම්බන්ධ විය නොහැක. කරුණාකර ඔබේ අන්තර්ජාල සම්බන්ධතාවය පරීක්ෂා කරන්න.',
      ta: 'இணைக்க முடியவில்லை. உங்கள் இணைய இணைப்பை சரிபார்க்கவும்.',
    ),
    LocalizedString(
      key: 'error_timeout',
      en: 'Request timed out. Please try again.',
      si: 'ඉල්ලීම කාලය ඉකුත් විය. කරුණාකර නැවත උත්සාහ කරන්න.',
      ta: 'கோரிக்கை காலாவதியானது. மீண்டும் முயற்சிக்கவும்.',
    ),
    LocalizedString(
      key: 'error_network',
      en: 'Network error occurred. Please try again.',
      si: 'ජාල දෝෂයක් ඇති විය. කරුණාකර නැවත උත්සාහ කරන්න.',
      ta: 'நெட்வொர்க் பிழை ஏற்பட்டது. மீண்டும் முயற்சிக்கவும்.',
    ),
    LocalizedString(
      key: 'error_unauthorized',
      en: 'Session expired. Please log in again.',
      si: 'සැසිය කල් ඉකුත් විය. කරුණාකර නැවත ප්‍රවේශ වන්න.',
      ta: 'அமர்வு காலாவதியானது. மீண்டும் உள்நுழையவும்.',
    ),
    LocalizedString(
      key: 'error_forbidden',
      en: 'Access denied. Please contact support.',
      si: 'ප්‍රවේශය ප්‍රතික්ෂේප විය. කරුණාකර සහයට සම්බන්ධ වන්න.',
      ta: 'அணுகல் மறுக்கப்பட்டது. ஆதரவைத் தொடர்பு கொள்ளவும்.',
    ),
    LocalizedString(
      key: 'error_invalid_credentials',
      en: 'Invalid login credentials. Please try again.',
      si: 'වලංගු නොවන ප්‍රවේශ විස්තර. කරුණාකර නැවත උත්සාහ කරන්න.',
      ta: 'தவறான உள்நுழைவு விவரங்கள். மீண்டும் முயற்சிக்கவும்.',
    ),
    LocalizedString(
      key: 'error_token_expired',
      en: 'Session expired. Please log in again.',
      si: 'සැසිය කල් ඉකුත් විය. කරුණාකර නැවත ප්‍රවේශ වන්න.',
      ta: 'அமர்வு காலாவதியானது. மீண்டும் உள்நுழையவும்.',
    ),
    LocalizedString(
      key: 'error_internal_error',
      en: 'Something went wrong. Please try again later.',
      si: 'යමක් වැරදී ගියා. කරුණාකර පසුව නැවත උත්සාහ කරන්න.',
      ta: 'ஏதோ தவறு நடந்தது. பின்னர் மீண்டும் முயற்சிக்கவும்.',
    ),
    LocalizedString(
      key: 'error_service_unavailable',
      en: 'Service temporarily unavailable. Please try again later.',
      si: 'සේවාව තාවකාලිකව නොමැත. කරුණාකර පසුව නැවත උත්සාහ කරන්න.',
      ta: 'சேவை தற்காலிகமாக கிடைக்கவில்லை. பின்னர் மீண்டும் முயற்சிக்கவும்.',
    ),
    LocalizedString(
      key: 'error_bad_gateway',
      en: 'Server error. Please try again later.',
      si: 'සේවාදායක දෝෂය. කරුණාකර පසුව නැවත උත්සාහ කරන්න.',
      ta: 'சர்வர் பிழை. பின்னர் மீண்டும் முயற்சிக்கவும்.',
    ),
    LocalizedString(
      key: 'error_empty_response',
      en: 'No response received. Please try again.',
      si: 'ප්‍රතිචාරයක් ලැබුණේ නැත. කරුණාකර නැවත උත්සාහ කරන්න.',
      ta: 'பதில் எதுவும் பெறப்படவில்லை. மீண்டும் முயற்சிக்கவும்.',
    ),
    LocalizedString(
      key: 'error_processing_error',
      en: 'Unable to process your message. Please try again.',
      si: 'ඔබේ පණිවිඩය සකසීමට නොහැකි විය. කරුණාකර නැවත උත්සාහ කරන්න.',
      ta: 'உங்கள் செய்தியை செயலாக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
    ),
    LocalizedString(
      key: 'error_voice_error',
      en: 'Voice processing failed. Please try again.',
      si: 'කණ්ඩායම් සැකසීම අසාර්ථක විය. කරුණාකර නැවත උත්සාහ කරන්න.',
      ta: 'குரல் செயலாக்கம் தோல்வியடைந்தது. மீண்டும் முயற்சிக்கவும்.',
    ),
    LocalizedString(
      key: 'error_unknown',
      en: 'An unexpected error occurred. Please try again.',
      si: 'අනපේක්ෂිත දෝෂයක් ඇති විය. කරුණාකර නැවත උත්සාහ කරන්න.',
      ta: 'எதிர்பாராத பிழை ஏற்பட்டது. மீண்டும் முயற்சிக்கவும்.',
    ),
    LocalizedString(
      key: 'error_validation',
      en: 'Please check your input and try again.',
      si: 'කරුණාකර ඔබේ ආදානය පරීක්ෂා කර නැවත උත්සාහ කරන්න.',
      ta: 'உங்கள் உள்ளீட்டை சரிபார்த்து மீண்டும் முயற்சிக்கவும்.',
    ),
    LocalizedString(
      key: 'dismiss',
      en: 'Dismiss',
      si: 'ඉවත්කරන්න',
      ta: 'நீக்கு',
    ),
  ];
}
