import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'localization_strings.dart';

class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizedString> _localizedValues =
      LocalizationStrings.values;

  final Locale locale;
  final Map<String, String> _localizedStrings = {};

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static List<Locale> get supportedLocales {
    return const [
      Locale('en', ''), // English
      Locale('si', ''), // Sinhala
      Locale('ta', ''), // Tamil
    ];
  }

  Future<bool> load() async {
    for (final localizedString in _localizedValues) {
      String? value;
      switch (locale.languageCode) {
        case 'si':
          value = localizedString.si;
          break;
        case 'ta':
          value = localizedString.ta;
          break;
        case 'en':
        default:
          value = localizedString.en;
          break;
      }
      _localizedStrings[localizedString.key] = value;
    }
    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Common App Strings
  String get appName => translate('app_name');
  String get welcome => translate('welcome');
  String get login => translate('login');
  String get logout => translate('logout');
  String get register => translate('register');
  String get email => translate('email');
  String get password => translate('password');
  String get confirmPassword => translate('confirm_password');
  String get forgotPassword => translate('forgot_password');
  String get resetPassword => translate('reset_password');
  String get submit => translate('submit');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get yes => translate('yes');
  String get no => translate('no');
  String get ok => translate('ok');
  String get error => translate('error');
  String get success => translate('success');
  String get loading => translate('loading');
  String get noDataFound => translate('no_data_found');
  String get retry => translate('retry');
  String get settings => translate('settings');
  String get language => translate('language');
  String get selectLanguage => translate('select_language');
  String get english => translate('english');
  String get sinhala => translate('sinhala');
  String get tamil => translate('tamil');
  String get search => translate('search');
  String get filter => translate('filter');
  String get sort => translate('sort');
  String get profile => translate('profile');
  String get home => translate('home');
  String get back => translate('back');
  String get next => translate('next');
  String get previous => translate('previous');
  String get finish => translate('finish');
  String get skip => translate('skip');
  String get done => translate('done');
  String get close => translate('close');
  String get askMeAnything => translate('ask_me_anything');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
