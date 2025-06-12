import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/feature/auth/bloc/auth_bloc.dart';
import 'package:nexora/injector.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/config/routes/app_routes.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/primary_button.dart';

@RoutePage()
class OtpVerifyPage extends StatefulWidget {
  final String email;

  const OtpVerifyPage({super.key, @QueryParam('email') this.email = ''});

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  final otpController = TextEditingController();
  final AuthBloc _authBloc = getIt<AuthBloc>();
  bool _isLoading = false;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    if (otpController.text.length == 6) {
      setState(() {
        _isLoading = true;
      });

      // Parse the OTP code to an integer
      try {
        final int code = int.parse(otpController.text);
        // Send both email and OTP code
        _authBloc.add(VerifyOtpRequested(widget.email, code));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invalid OTP format')));
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
              // Navigate to Chat page on successful verification and clear the stack
              context.router.pushAndPopUntil(
                const ChatViewRoute(),
                predicate: (route) => false,
              );
            } else if (state is AuthError) {
              // Show error snackbar
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          }
        },
        child: GradientBackground(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
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
                const Text(
                  "Enter OTP",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Check your email inbox for a 6-digit code.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black26,
                  ),
                ),
                const SizedBox(height: 20),
                Pinput(controller: otpController, length: 6),

                const SizedBox(height: 30),
                PrimaryButton(
                  label: _isLoading ? 'Verifying...' : 'Next',
                  onPressed: _isLoading ? () {} : _verifyOtp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
