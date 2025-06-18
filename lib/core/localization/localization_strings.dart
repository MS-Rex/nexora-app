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
    LocalizedString(key: 'login', en: 'Login', si: 'ප්‍රවේශය', ta: 'உள்நுழைய'),
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
    LocalizedString(key: 'next', en: 'Next', si: 'ඊළඟ', ta: 'அடுத்து'),
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
  ];
}
