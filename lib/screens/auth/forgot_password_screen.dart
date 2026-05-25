// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:zindaonlineschool/widgets/custom_snackbar.dart';

// import '../../core/utils/responsive.dart';
// import '../../core/utils/validators.dart';
// import '../../providers/auth_provider.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_label.dart';
// import '../../widgets/custom_textfield.dart';
// import 'otp_screen.dart';

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final formKey = GlobalKey<FormState>();

//   final emailController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final width = Responsive.width(context);

//     final height = Responsive.height(context);

//     final provider = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: width * 0.08),

//             child: Form(
//               key: formKey,

//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,

//                 children: [
//                   SizedBox(height: height * 0.06),

//                   /// TITLE
//                   Center(
//                     child: Text(
//                       "Forgot Password",

//                       style: TextStyle(
//                         fontSize: width * 0.07,

//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: height * 0.02),

//                   Center(
//                     child: Text(
//                       "Enter your registered email address",

//                       textAlign: TextAlign.center,

//                       style: TextStyle(fontSize: width * 0.04),
//                     ),
//                   ),

//                   SizedBox(height: height * 0.06),

//                   /// EMAIL LABEL
//                   const CustomLabel(text: "EMAIL"),

//                   /// EMAIL FIELD
//                   CustomTextField(
//                     controller: emailController,

//                     hint: "Enter email",

//                     keyboardType: TextInputType.emailAddress,

//                     validator: Validators.email,
//                   ),

//                   SizedBox(height: height * 0.05),

//                   /// SEND OTP BUTTON
//                   CustomButton(
//                     text: "Send OTP",
//                     isLoading: provider.isLoading,

//                     onPressed: () async {
//                       if (formKey.currentState!.validate()) {
//                         final (success, message) = await provider.sendOtp(
//                           emailController.text.trim(),
//                         );

//                         if (success && context.mounted) {
                          
//                           CustomSnackbar.success(
//                             context,
//                             message ?? "OTP Sent Successfully",
//                           );
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) =>
//                                   OtpScreen(email: emailController.text.trim()),
//                             ),
//                           );
//                         } else {
//                           CustomSnackbar.error(
//                             context,
//                             message ?? "Failed to send OTP",
//                           );
//                         }
//                       }
//                     },
//                   ),

//                   SizedBox(height: height * 0.03),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/widgets/custom_snackbar.dart';

import '../../core/utils/responsive.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_label.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/responsive_body.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();

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
                      "Forgot Password",

                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 0.07, min: 22, max: 30),

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: Responsive.spacing(context, 0.02)),

                  Center(
                    child: Text(
                      "Enter your registered email address",

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 0.04, min: 14, max: 18),
                      ),
                    ),
                  ),

                  SizedBox(height: Responsive.spacing(context, 0.06)),

                  /// EMAIL LABEL
                  const CustomLabel(text: "EMAIL"),

                  /// EMAIL FIELD
                  CustomTextField(
                    controller: emailController,

                    hint: "Enter email",

                    keyboardType: TextInputType.emailAddress,

                    validator: Validators.email,
                  ),

                  SizedBox(height: Responsive.spacing(context, 0.05)),

                  /// SEND OTP BUTTON
                  CustomButton(
                    text: "Send OTP",
                    isLoading: provider.isLoading,

                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final (success, message) = await provider.sendOtp(
                          emailController.text.trim(),
                        );

                        if (success && context.mounted) {
                          
                          CustomSnackbar.success(
                            context,
                            message ?? "OTP Sent Successfully",
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  OtpScreen(email: emailController.text.trim()),
                            ),
                          );
                        } else {
                          CustomSnackbar.error(
                            context,
                            message ?? "Failed to send OTP",
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
