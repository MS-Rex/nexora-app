import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nexora/core/config/routes/app_routes.dart';

import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/primary_button.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 140),
              Image.asset(
                'assets/images/logo.png', // Add your logo image in the assets folder
                height: 150,
                width: 150,
                color: Colors.black,
              ),
              const Text(
                "Welcome !",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              const Text(
                'Login to Nexora',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black26,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(label: 'Email', controller: emailController),

              const SizedBox(height: 30),
              PrimaryButton(
                label: 'Login',
                onPressed: () {
                  print(
                    'Login: ${emailController.text}, ${passwordController.text}',
                  );
                  context.router.push(OtpVerifyRoute());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
