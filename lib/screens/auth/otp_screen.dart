import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/widgets/custom_snackbar.dart';

import '../../core/utils/responsive.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_label.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/responsive_body.dart';
import 'reset_password.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final formKey = GlobalKey<FormState>();

  final otpController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveBody(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  SizedBox(height: Responsive.spacing(context, 0.06)),

                  /// TITLE
                  Center(
                    child: Text(
                      "Verify OTP",

                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 0.07, min: 22, max: 30),

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: Responsive.spacing(context, 0.02)),

                  Center(
                    child: Text(
                      "Enter the OTP sent to your email",

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 0.04, min: 14, max: 18),
                      ),
                    ),
                  ),

                  SizedBox(height: Responsive.spacing(context, 0.06)),

                  /// OTP LABEL
                  const CustomLabel(text: "OTP"),

                  /// OTP FIELD
                  CustomTextField(
                    controller: otpController,

                    hint: "Enter OTP",

                    keyboardType: TextInputType.number,

                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,

                      LengthLimitingTextInputFormatter(6),
                    ],

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "OTP is required";
                      }

                      if (value.length < 4) {
                        return "Enter valid OTP";
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: Responsive.spacing(context, 0.05)),

                  /// VERIFY BUTTON
                  CustomButton(
                    text: "Verify OTP",

                    isLoading: provider.isLoading,

                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final (success, message) = await provider.verifyOtp(
                          email: widget.email,
                          otp: otpController.text.trim(),
                        );

                        if (success && context.mounted) {
                          CustomSnackbar.success(
                            context,
                            message ?? "Verified Successfully",
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResetPasswordScreen(
                                email: widget.email,
                                otp: otpController.text.trim(),
                              ),
                            ),
                          );
                        } else {
                          CustomSnackbar.error(
                            context,
                            message ?? "Invalid OTP",
                          );
                        }
                      }
                    },
                  ),

                  SizedBox(height: Responsive.spacing(context, 0.03)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
