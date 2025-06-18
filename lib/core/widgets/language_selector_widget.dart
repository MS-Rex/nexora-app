import 'package:flutter/material.dart';
import 'package:nexora/injector.dart';
import '../localization/app_localization_extension.dart';
import '../localization/localization_service.dart';

class LanguageSelectorWidget extends StatefulWidget {
  final bool showAsDialog;
  final VoidCallback? onLanguageChanged;

  const LanguageSelectorWidget({
    super.key,
    this.showAsDialog = false,
    this.onLanguageChanged,
  });

  @override
  State<LanguageSelectorWidget> createState() => _LanguageSelectorWidgetState();
}

class _LanguageSelectorWidgetState extends State<LanguageSelectorWidget> {
  late final LocalizationService _localizationService;

  @override
  void initState() {
    super.initState();
    _localizationService = getIt<LocalizationService>();
  }

  @override
  Widget build(BuildContext context) {
    // Safety check to ensure service is initialized
    if (!_localizationService.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListenableBuilder(
      listenable: _localizationService,
      builder: (context, child) {
        if (widget.showAsDialog) {
          return _buildLanguageDialog(context);
        }
        return _buildLanguageList(context);
      },
    );
  }

  Widget _buildLanguageDialog(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.selectLanguage),
      content: SizedBox(
        width: double.minPositive,
        child: _buildLanguageList(context),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.close),
        ),
      ],
    );
  }

  Widget _buildLanguageList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children:
          _localizationService.supportedLocales.map((locale) {
            final isSelected =
                _localizationService.currentLocale.languageCode ==
                locale.languageCode;

            return ListTile(
              leading: _buildLanguageFlag(locale.languageCode),
              title: Text(
                _localizationService.getLanguageNameInCurrentLocale(
                  locale.languageCode,
                ),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Text(
                _localizationService.getLanguageName(locale.languageCode),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              trailing:
                  isSelected
                      ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).primaryColor,
                      )
                      : null,
              onTap: () async {
                await _localizationService.changeLanguage(locale);
                widget.onLanguageChanged?.call();
                if (widget.showAsDialog) {
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            );
          }).toList(),
    );
  }

  Widget _buildLanguageFlag(String languageCode) {
    String emoji;
    switch (languageCode) {
      case 'en':
        emoji = '🇺🇸';
        break;
      case 'si':
        emoji = '🇱🇰';
        break;
      case 'ta':
        emoji = '🇱🇰';
        break;
      default:
        emoji = '🌐';
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
    );
  }
}

// Helper function to show language selector as a bottom sheet
void showLanguageSelectorBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder:
        (context) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.selectLanguage,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              const LanguageSelectorWidget(),
              const SizedBox(height: 16),
            ],
          ),
        ),
  );
}

// Helper function to show language selector as a dialog
void showLanguageSelectorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const LanguageSelectorWidget(showAsDialog: true),
  );
}
