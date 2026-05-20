import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/core/constants/app_space.dart';
import 'package:zindaonlineschool/widgets/custom_snackbar.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_label.dart';
import '../../widgets/custom_textfield.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool showValidation = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
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
    // final provider = Provider.of<AuthProvider>(context);
    final provider = context.watch<AuthProvider>();

    return Scaffold(
       resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },

        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),

            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: formKey,
                autovalidateMode: showValidation
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    AppSpacing.h40,
                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    // SizedBox(height: height * 0.01),
                    Text(
                      "Fill your details to register",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: height * 0.04),

                    const CustomLabel(text: "FULL NAME"),

                    CustomTextField(
                      controller: nameController,
                      hint: "Enter full name",
                      maxLength: 50,
                      validator: (value) {
                        if (!showValidation) return null;
                        return Validators.required(value, "Name");
                      },

                      onChanged: (_) {
                        if (showValidation) {
                          formKey.currentState!.validate();
                        }
                      },
                    ),

                    SizedBox(height: height * 0.015),

                    const CustomLabel(text: "EMAIL"),
                    AppSpacing.h10,
                    CustomTextField(
                      controller: emailController,
                      hint: "Enter email",
                      maxLength: 50,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,

                      validator: (value) {
                        if (!showValidation) return null;
                        return Validators.email(value);
                      },

                      onChanged: (_) {
                        if (showValidation) {
                          formKey.currentState!.validate();
                        }
                      },
                    ),

                    SizedBox(height: height * 0.015),
                    const CustomLabel(text: "PHONE NUMBER"),
                    AppSpacing.h10,
                    CustomTextField(
                      controller: phoneController,
                      hint: "Enter phone number",
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                       prefixIcon: Icons.phone_outlined,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],

                      validator: (value) {
                        if (!showValidation) return null;
                        return Validators.phone(value);
                      },

                      onChanged: (_) {
                        if (showValidation) {
                          formKey.currentState!.validate();
                        }
                      },
                    ),

                    SizedBox(height: height * 0.015),
                    const CustomLabel(text: "PASSWORD"),
                    AppSpacing.h10,
                    CustomTextField(
                      controller: passwordController,
                      hint: "Enter password",
                      maxLength: 20,
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

                    SizedBox(height: height * 0.015),
                    const CustomLabel(text: "CONFIRM PASSWORD"),
                    AppSpacing.h10,
                    CustomTextField(
                      controller: confirmPasswordController,
                      hint: "Confirm password",
                      maxLength: 20,
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

                    AppSpacing.h40,

                    CustomButton(
                      text: "Register",
                      isLoading: provider.isLoading,

                      onPressed: () async {
                        FocusScope.of(context).unfocus();

                        if (provider.isLoading) return;
                        triggerValidation();

                        if (!formKey.currentState!.validate()) {
                          return;
                        }

                        final (ok, msg) = await provider.register(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          phone: phoneController.text.trim(),
                          password: passwordController.text.trim(),
                          cpassword: confirmPasswordController.text.trim(),
                        );

                        if (!context.mounted) return;

                        // CustomSnackbar.success(
                        //   context,
                        //   msg ?? "Registered Successfully",
                        // );

                        // if (ok) {
                        //   Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (_) => const LoginScreen(),
                        //     ),
                        //   );
                        // }
                        if (ok) {
                          CustomSnackbar.success(
                            context,
                            msg ?? "Registered Successfully",
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        } else {
                          CustomSnackbar.error(
                            context,
                            msg ?? "Registration Failed",
                          );
                        }
                      },
                    ),

                    AppSpacing.h20,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?", style: TextStyle(color: Colors.white70),),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.h20,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
