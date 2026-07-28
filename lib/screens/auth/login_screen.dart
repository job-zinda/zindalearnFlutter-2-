
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:zindaonlineschool/core/constants/app_space.dart';
// import 'package:zindaonlineschool/screens/auth/forgot_password_screen.dart';
// import 'package:zindaonlineschool/screens/dashboard/dashborad_screen.dart';
// import 'package:zindaonlineschool/widgets/custom_snackbar.dart';
// import '../../core/utils/responsive.dart';
// import '../../core/utils/validators.dart';
// import '../../providers/auth_provider.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_label.dart';
// import '../../widgets/custom_textfield.dart';
// import '../../widgets/responsive_body.dart';
// import 'register_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final formKey = GlobalKey<FormState>();

//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   bool showValidation = false;

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   void triggerValidation() {
//     setState(() {
//       showValidation = true;
//     });

//     formKey.currentState!.validate();
//   }

//   Future<void> _openTutorWhatsApp() async {
//   final Uri uri = Uri.parse(
//     "https://wa.me/918921923281?text=${Uri.encodeComponent("Hi, I'm interested in joining Zinda Online School as a tutor. Could you share the online teaching details?")}",
//   );
//   try {
//     await launchUrl(uri, mode: LaunchMode.externalApplication);
//   } catch (e) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Could not open WhatsApp")),
//       );
//     }
//   }
// }



//   @override
//   Widget build(BuildContext context) {
//     // final provider = Provider.of<AuthProvider>(context);
//     final provider = context.watch<AuthProvider>();

//     return Scaffold(
//       resizeToAvoidBottomInset: true,

//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: SafeArea(
//           child: ResponsiveBody(
//             alignTop: false,
//             child: SingleChildScrollView(
//               keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//               child: Form(
//                 key: formKey,
//                 autovalidateMode: showValidation
//                     ? AutovalidateMode.onUserInteraction
//                     : AutovalidateMode.disabled,

//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     AppSpacing.h50,
//                     Center(
//                       child: Image.asset(
//                         "assets/images/Online school logo.png",
//                         height: Responsive.value(
//                           context,
//                           mobile: 120.0,
//                           tablet: 140.0,
//                           desktop: 150.0,
//                         ),
//                       ),
//                     ),
//                     AppSpacing.h40,
//                     Center(
//                       child: Text(
//                         "Welcome Back",
//                         style: TextStyle(
//                           fontSize: Responsive.fontSize(
//                             context,
//                             0.07,
//                             min: 22,
//                             max: 30,
//                           ),
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),

//                     AppSpacing.h10,

//                     Center(
//                       child: Text(
//                         "Sign in to continue",
//                         style: TextStyle(
//                           fontSize: Responsive.fontSize(
//                             context,
//                             0.042,
//                             min: 14,
//                             max: 18,
//                           ),
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),

//                     AppSpacing.h30,

//                     const CustomLabel(text: "EMAIL OR PHONE"),

//                     AppSpacing.h10,

//                     CustomTextField(
//                       controller: emailController,
//                       hint: "Enter your email or phone",
//                       maxLength: 50,
//                       prefixIcon: Icons.email_outlined,
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return "Email or Phone is required";
//                         }

//                         if (value.contains("@")) {
//                           return Validators.email(value);
//                         } else {
//                           return Validators.phone(value);
//                         }
//                       },

//                       onChanged: (_) {
//                         if (showValidation) {
//                           formKey.currentState!.validate();
//                         }
//                       },
//                     ),

//                     AppSpacing.h20,

//                     const CustomLabel(text: "PASSWORD"),

//                     AppSpacing.h10,

//                     CustomTextField(
//                       controller: passwordController,
//                       hint: "Enter password",
//                       maxLength: 20,
//                       isPassword: true,
//                       showToggle: true,
//                       isVisible: provider.isPasswordVisible,
//                       onToggle: provider.togglePassword,

//                       validator: Validators.password,

//                       onChanged: (_) {
//                         if (showValidation) {
//                           formKey.currentState!.validate();
//                         }
//                       },
//                     ),

//                     AppSpacing.h20,

//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const ForgotPasswordScreen(),
//                             ),
//                           );
//                         },
//                         child: const Text(
//                           "Forgot Password?",
//                           style: TextStyle(color: Colors.white70),
//                         ),
//                       ),
//                     ),

//                     AppSpacing.h20,

//                     CustomButton(
//                       text: "Login",
//                       isLoading: provider.isLoading,

//                       onPressed: () async {
//                         if (provider.isLoading) return;

//                         triggerValidation();

//                         if (formKey.currentState!.validate()) {
//                           final (success, response) = await provider.login(
//                             email: emailController.text.trim(),
//                             password: passwordController.text.trim(),
//                           );

//                           if (!context.mounted) return;

//                           if (success) {
//                             final token = response["token"];
//                             // print("LOGIN TOKEN: $token");

//                             CustomSnackbar.success(
//                               context,
//                               response["msg"] ?? "Login Success",
//                             );

//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 // builder: (_) => HomeScreen(token: token),
//                                 builder: (_) => DashboardScreen(token: token,), // Pass an empty map for tutor
//                               ),
                              
//                             );
//                           } else {
//                             CustomSnackbar.error(
//                               context,
//                               response["msg"] ?? "Login Failed",
//                             );
//                           }
//                         }
//                       },
//                     ),

//                     AppSpacing.h30,

//                  Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     const Text(
//       "Don't have an account ?",
//       style: TextStyle(color: Colors.white70),
//     ),
//     TextButton(
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const RegisterScreen(),
//           ),
//         );
//       },
//       child: const Text(
//         "Register",
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     ),
//   ],
// ),

// AppSpacing.h30,

// Container(
//   width: double.infinity,
//   padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
//   decoration: BoxDecoration(
//     color: const Color(0xFF25D366).withValues(alpha: 0.08),
//     borderRadius: BorderRadius.circular(18),
//     border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.3)),
//   ),
//   child: Row(
//     children: [
//       Container(
//         height: 46,
//         width: 46,
//         decoration: BoxDecoration(
//           color: const Color(0xFF25D366).withValues(alpha: 0.15),
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: const Icon(Icons.school_rounded, color: Color(0xFF25D366), size: 24),
//       ),
//       const SizedBox(width: 14),
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "Join our teaching team",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 15,
//               ),
//             ),
//             const SizedBox(height: 2),
//             Text(
//               "Tutors — chat with admin for details",
//               style: TextStyle(
//                 color: Colors.white.withValues(alpha: 0.6),
//                 fontSize: 12.5,
//               ),
//             ),
//           ],
//         ),
//       ),
//       GestureDetector(
//         onTap: _openTutorWhatsApp,
//         child: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: const Color(0xFF25D366),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: const Icon(Icons.chat, color: Colors.white, size: 22),
//         ),
//       ),
//     ],
//   ),
// ),

// AppSpacing.h20,
//                   ],
//                 ),
                  
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
    
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zindaonlineschool/core/constants/app_colors.dart';
import 'package:zindaonlineschool/core/constants/app_space.dart';
import 'package:zindaonlineschool/screens/auth/forgot_password_screen.dart';
import 'package:zindaonlineschool/screens/dashboard/dashborad_screen.dart';
import 'package:zindaonlineschool/widgets/custom_snackbar.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_label.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/responsive_body.dart';
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

  Future<void> _openTutorWhatsApp() async {
    final Uri uri = Uri.parse(
      "https://wa.me/918921923281?text=${Uri.encodeComponent("Hi, I'm interested in joining Zinda Online School as a tutor. Could you share the online teaching details?")}",
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open WhatsApp")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: ResponsiveBody(
            alignTop: false,
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
                    AppSpacing.h40,
                    Center(
                      child: Image.asset(
                        "assets/images/Online school logo.png",
                        height: Responsive.value(
                          context,
                          mobile: 80.0,
                          tablet: 90.0,
                          desktop: 110.0,
                        
                        ),
                      ),
                    ),
                    AppSpacing.h20,
                    Center(
                      child: Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: Responsive.fontSize(
                            context,
                            0.098,
                            min: 32,
                            max: 40,
                          ),
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
                          fontSize: Responsive.fontSize(
                            context,
                            0.042,
                            min: 14,
                            max: 18,
                          ),
                          color: Colors.white70,
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

                    AppSpacing.h10,

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
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
                          style: TextStyle(color: Colors.white70, fontSize: 13),
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

                            CustomSnackbar.success(
                              context,
                              response["msg"] ?? "Login Success",
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
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

                    AppSpacing.h20,

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
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
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  AppSpacing.h30,

GestureDetector(
  onTap: _openTutorWhatsApp,
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    decoration: BoxDecoration(
      color: const Color(0xFF25D366).withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0xFF25D366).withValues(alpha: 0.4),
        width: 1.2,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/whatsapp.png',
          height: 28,
          width: 28,
        ),
        const SizedBox(width: 12),
        Text(
          "Join our teaching team",
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
      ],
    ),
  ),
),

AppSpacing.h30,
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