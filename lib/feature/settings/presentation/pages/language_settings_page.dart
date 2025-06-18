import 'package:flutter/material.dart';
import 'package:nexora/core/localization/localization.dart';
import 'package:nexora/core/widgets/language_selector_widget.dart';
import 'package:nexora/injector.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.language), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page title and description
            Text(
              context.l10n.selectLanguage,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _getDescriptionText(context),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Language selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.language,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const LanguageSelectorWidget(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Demo content to show localization working
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getDemoTitle(context),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDemoContent(context),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => showLanguageSelectorBottomSheet(context),
                    icon: const Icon(Icons.language),
                    label: Text(_getQuickSelectText(context)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => showLanguageSelectorDialog(context),
                    icon: const Icon(Icons.settings),
                    label: Text(context.l10n.settings),
                  ),
                ),
              ],
            ),
          ],
        ),
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

  String _getDemoTitle(BuildContext context) {
    final localizationService = getIt<LocalizationService>();
    switch (localizationService.currentLocale.languageCode) {
      case 'si':
        return 'නියැදි සම්පත්';
      case 'ta':
        return 'மாதிரி உள்ளடக்கம்';
      case 'en':
      default:
        return 'Sample Content';
    }
  }

  String _getQuickSelectText(BuildContext context) {
    final localizationService = getIt<LocalizationService>();
    switch (localizationService.currentLocale.languageCode) {
      case 'si':
        return 'ඉක්මන් තේරීම';
      case 'ta':
        return 'விரைவு தேர்வு';
      case 'en':
      default:
        return 'Quick Select';
    }
  }

  Widget _buildDemoContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDemoRow(context, context.l10n.welcome, Icons.waving_hand),
        _buildDemoRow(context, context.l10n.home, Icons.home),
        _buildDemoRow(context, context.l10n.profile, Icons.person),
        _buildDemoRow(context, context.l10n.settings, Icons.settings),
        _buildDemoRow(context, context.l10n.search, Icons.search),
        _buildDemoRow(context, context.l10n.save, Icons.save),
        _buildDemoRow(context, context.l10n.cancel, Icons.cancel),
        _buildDemoRow(context, context.l10n.success, Icons.check_circle),
        _buildDemoRow(context, context.l10n.error, Icons.error),
        _buildDemoRow(context, context.l10n.loading, Icons.refresh),
      ],
    );
  }

  Widget _buildDemoRow(BuildContext context, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}
