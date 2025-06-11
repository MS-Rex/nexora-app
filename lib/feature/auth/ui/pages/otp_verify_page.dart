import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/config/routes/app_routes.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/primary_button.dart';

@RoutePage()
class OtpVerifyPage extends StatefulWidget {
  const OtpVerifyPage({super.key});

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  final otpController = TextEditingController();
  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

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
                "Enter OTP",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              const Text(
                'Check your email inbox for a 4-digit code.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black26,
                ),
              ),
              const SizedBox(height: 20),
              Pinput(controller: otpController, length: 4),

              const SizedBox(height: 30),
              PrimaryButton(
                label: 'Next',
                onPressed: () {
                  // Handle login logic here

                  // Navigate to the chat page after successful login
                  // context.router.push(ChatRoute());
                  context.router.push(ChatViewRoute());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
