import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/widgets/custom_snackbar.dart';

import '../../core/utils/responsive.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_label.dart';
import '../../widgets/custom_textfield.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool showValidation = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void triggerValidation() {
    setState(() {
      showValidation = true;
    });
    formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.width(context);
    final height = Responsive.height(context);
    final provider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.08),

            child: Form(
              key: formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.05),

                  Center(
                    child: Text(
                      "Create New Password",
                      style: TextStyle(
                        fontSize: width * 0.07,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.05),

                  /// NEW PASSWORD
                  const CustomLabel(text: "NEW PASSWORD"),

                  CustomTextField(
                    controller: passwordController,
                    hint: "Enter new password",
                    isPassword: true,
                    showToggle: true,
                    isVisible: provider.isPasswordVisible,
                    onToggle: provider.togglePassword,

                    inputFormatters: [LengthLimitingTextInputFormatter(20)],

                    validator: (value) {
                      if (!showValidation) return null;
                      return Validators.password(value);
                    },

                    onChanged: (_) {
                      if (showValidation) {
                        formKey.currentState!.validate();
                      }
                    },
                  ),

                  SizedBox(height: height * 0.03),

                  /// CONFIRM PASSWORD
                  const CustomLabel(text: "CONFIRM PASSWORD"),

                  CustomTextField(
                    controller: confirmPasswordController,
                    hint: "Confirm password",
                    isPassword: true,

                    showToggle: false,

                    isVisible: provider.isConfirmPasswordVisible,
                    onToggle: provider.toggleConfirmPassword,

                    inputFormatters: [LengthLimitingTextInputFormatter(20)],

                    validator: (value) {
                      if (!showValidation) return null;

                      return Validators.confirmPassword(
                        value,
                        passwordController.text,
                      );
                    },

                    onChanged: (_) {
                      if (showValidation) {
                        formKey.currentState!.validate();
                      }
                    },
                  ),

                  SizedBox(height: height * 0.05),

                  /// RESET BUTTON
                  CustomButton(
                    text: "Reset Password",
                    isLoading: provider.isLoading,

                    onPressed: () async {
                      triggerValidation();

                      if (!formKey.currentState!.validate()) return;

                      final (success, message) = await provider.resetPassword(
                        email: widget.email,
                        otp: widget.otp,
                        password: passwordController.text.trim(),
                      );

                      if (!context.mounted) return;

                      if (success) {
                        CustomSnackbar.success(
                          context,
                          message ?? "Password Reset Successfully",
                        );
                        Navigator.popUntil(context, (route) => route.isFirst);
                      } else {
                        CustomSnackbar.error(
                          context,
                          message ?? "Failed to reset password",
                        );
                      }
                    },
                  ),

                  SizedBox(height: height * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
