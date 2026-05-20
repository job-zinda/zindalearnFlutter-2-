import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/core/constants/app_space.dart';
import 'package:zindaonlineschool/screens/auth/forgot_password_screen.dart';
import 'package:zindaonlineschool/screens/dashboard/dashborad_screen.dart';
import 'package:zindaonlineschool/screens/home/home_screen/home_screen.dart';
import 'package:zindaonlineschool/widgets/custom_snackbar.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_label.dart';
import '../../widgets/custom_textfield.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool showValidation = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                    AppSpacing.h50,
                    Center(
                      child: Image.asset(
                        "assets/images/Online school logo.png",
                        height: 130,
                      ),
                    ),
                    AppSpacing.h40,
                    Center(
                      child: Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: width * 0.07,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    AppSpacing.h10,

                    Center(
                      child: Text(
                        "Sign in to continue",
                        style: TextStyle(
                          fontSize: width * 0.042,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    AppSpacing.h30,

                    const CustomLabel(text: "EMAIL OR PHONE"),

                    AppSpacing.h10,

                    CustomTextField(
                      controller: emailController,
                      hint: "Enter your email or phone",
                      maxLength: 50,
                      prefixIcon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Email or Phone is required";
                        }

                        if (value.contains("@")) {
                          return Validators.email(value);
                        } else {
                          return Validators.phone(value);
                        }
                      },

                      onChanged: (_) {
                        if (showValidation) {
                          formKey.currentState!.validate();
                        }
                      },
                    ),

                    AppSpacing.h20,

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

                      validator: Validators.password,

                      onChanged: (_) {
                        if (showValidation) {
                          formKey.currentState!.validate();
                        }
                      },
                    ),

                    AppSpacing.h20,

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),

                    AppSpacing.h20,

                    CustomButton(
                      text: "Login",
                      isLoading: provider.isLoading,

                      onPressed: () async {
                        if (provider.isLoading) return;

                        triggerValidation();

                        if (formKey.currentState!.validate()) {
                          final (success, response) = await provider.login(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );

                          if (!context.mounted) return;

                          if (success) {
                            final token = response["token"];
                            print("LOGIN TOKEN: $token");

                            CustomSnackbar.success(
                              context,
                              response["msg"] ?? "Login Success",
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                // builder: (_) => HomeScreen(token: token),
                                builder: (_) => DashboardScreen(token: token),
                              ),
                            );
                          } else {
                            CustomSnackbar.error(
                              context,
                              response["msg"] ?? "Login Failed",
                            );
                          }
                        }
                      },
                    ),

                    AppSpacing.h30,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account ?",
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
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
