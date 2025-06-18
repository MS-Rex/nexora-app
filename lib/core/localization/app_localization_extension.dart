import 'package:flutter/material.dart';
import 'app_localizations.dart';

extension AppLocalizationExtension on BuildContext {
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    if (localizations == null) {
      throw Exception(
        'AppLocalizations not found in context. Make sure you have added AppLocalizations.delegate to your MaterialApp.',
      );
    }
    return localizations;
  }
}
