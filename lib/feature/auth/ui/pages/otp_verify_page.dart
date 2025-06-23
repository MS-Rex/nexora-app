import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexora/feature/auth/bloc/auth_bloc.dart';
import 'package:nexora/injector.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/config/routes/app_routes.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/localization/app_localization_extension.dart';

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
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Clear error when user starts typing
    otpController.addListener(() {
      if (_errorMessage != null) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    if (otpController.text.length == 6) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Parse the OTP code to an integer
      try {
        final int code = int.parse(otpController.text);
        // Send both email and OTP code
        _authBloc.add(VerifyOtpRequested(widget.email, code));
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = context.l10n.invalidOtpFormat;
        });
      }
    } else {
      setState(() {
        _errorMessage = context.l10n.enterValidSixDigitOtp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: Center(
          child: Image.asset(
            'assets/images/appbar_logo.png',
            height: 150,
            width: 150,
            // color: Colors.black,
          ),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        bloc: _authBloc,
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
          } else {
            setState(() {
              _isLoading = false;
            });

            if (state is AuthSuccess) {
              // Navigate to Chat page on successful verification and clear the stack
              context.router.pushAndPopUntil(
                ChatViewRoute(),
                predicate: (route) => false,
              );
            } else if (state is AuthError) {
              // Show error below OTP input instead of SnackBar
              setState(() {
                _errorMessage = state.message;
              });
            }
          }
        },
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/def_background.png',
                height: ScreenUtil().screenHeight,
                width: ScreenUtil().screenWidth,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0).w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.enterOtp,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    context.l10n.checkEmailInbox,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black26,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  Pinput(
                    controller: otpController,
                    length: 6,
                    errorPinTheme: PinTheme(
                      width: 56.w,
                      height: 56.h,
                      textStyle: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    forceErrorState: _errorMessage != null,
                  ),
                  // Error message display
                  if (_errorMessage != null) ...[
                    SizedBox(height: 8.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 30.h),
                  PrimaryButton(
                    label:
                        _isLoading ? context.l10n.verifying : context.l10n.next,
                    onPressed: _isLoading ? () {} : _verifyOtp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
