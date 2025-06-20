import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/localization/app_localization_extension.dart';

@RoutePage()
class SignUpPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                context.l10n.signUpForNexora,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: context.l10n.name,
                controller: nameController,
              ),
              CustomTextField(
                label: context.l10n.email,
                controller: emailController,
              ),
              CustomTextField(
                label: context.l10n.password,
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                label: context.l10n.signUp,
                onPressed: () {
                  // Handle sign-up logic here
                  print(
                    'Sign Up: ${nameController.text}, ${emailController.text}, ${passwordController.text}',
                  );
                  // Navigate to the chat page after successful sign-up
                  // context.router.push(const ChatRoute());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
