import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/core/config/routes/app_routes.dart';
import 'package:nexora/feature/auth/bloc/auth_bloc.dart';
import 'package:nexora/injector.dart';

import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/localization/app_localization_extension.dart';
import '../../../../core/localization/localization_service.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthBloc _authBloc = getIt<AuthBloc>();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.emailRequired;
    }
    // Simple email validation regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return context.l10n.enterValidEmail;
    }
    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      _authBloc.add(LoginRequested(emailController.text));
    }
  }

  Widget _buildLanguageSelectorButton() {
    final localizationService = getIt<LocalizationService>();

    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return InkWell(
          onTap: () => _showLanguageSelector(),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black26, width: 1),
              color: Colors.white.withValues(alpha: 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageFlag(
                  localizationService.currentLocale.languageCode,
                ),
                const SizedBox(width: 8),
                Text(
                  localizationService.getLanguageName(
                    localizationService.currentLocale.languageCode,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        );
      },
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
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 14))),
    );
  }

  void _showLanguageSelector() {
    final localizationService = getIt<LocalizationService>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.selectLanguage,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...localizationService.supportedLocales.map((locale) {
                  final isSelected =
                      localizationService.currentLocale.languageCode ==
                      locale.languageCode;

                  return ListTile(
                    leading: _buildLanguageFlag(locale.languageCode),
                    title: Text(
                      localizationService.getLanguageNameInCurrentLocale(
                        locale.languageCode,
                      ),
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      localizationService.getLanguageName(locale.languageCode),
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing:
                        isSelected
                            ? Icon(
                              Icons.check_circle,
                              color: Theme.of(context).primaryColor,
                            )
                            : null,
                    onTap: () async {
                      await localizationService.changeLanguage(locale);
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  );
                }).toList(),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        bloc: _authBloc,
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() {
              _isLoading = true;
            });
          } else {
            setState(() {
              _isLoading = false;
            });

            if (state is AuthSuccess) {
              // Navigate to OTP verification screen with email parameter
              context.router.push(OtpVerifyRoute(email: emailController.text));
            } else if (state is AuthError) {
              // Show error snackbar
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          }
        },
        child: GradientBackground(
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 140),
                          Image.asset(
                            'assets/images/logo.png',
                            height: 150,
                            width: 150,
                            color: Colors.black,
                          ),
                          Text(
                            context.l10n.welcomeExclamation,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            context.l10n.loginToNexora,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black26,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            label: context.l10n.email,
                            controller: emailController,
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 30),
                          PrimaryButton(
                            label:
                                _isLoading
                                    ? context.l10n.processing
                                    : context.l10n.login,
                            onPressed: _isLoading ? () {} : _handleLogin,
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
                // Language selector at bottom
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Center(child: _buildLanguageSelectorButton()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
