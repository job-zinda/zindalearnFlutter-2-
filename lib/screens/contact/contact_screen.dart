// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:zindaonlineschool/core/utils/responsive.dart';
// import 'package:zindaonlineschool/widgets/responsive_body.dart';

// class ContactScreen extends StatelessWidget {
//   const ContactScreen({super.key});

//   void makeCall() async {
//     final Uri uri = Uri(scheme: 'tel', path: '8921923281');
//     await launchUrl(uri);
//   }

//   void openWhatsApp() async {
//     final Uri uri = Uri.parse("https://wa.me/918921923281");
//     await launchUrl(uri, mode: LaunchMode.externalApplication);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Contact Us"),
//         backgroundColor: const Color.fromARGB(255, 13, 2, 64),
//       ),
//       body: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           color: Color.fromARGB(255, 13, 2, 64),
//         ),
//         child: Center(
//           child: ResponsiveBody(
//             alignTop: false,
//             child: Container(
//               width: double.infinity,
//               padding: Responsive.screenPadding(context),
//               decoration: BoxDecoration(
//                 // ignore: deprecated_member_use
//                 color: Colors.white.withOpacity(0.95),
//                 borderRadius: BorderRadius.circular(25),
//                 boxShadow: const [
//                   BoxShadow(
//                     blurRadius: 30,
//                     color: Colors.black26,
//                     offset: Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "Get in Touch",
//                     style: TextStyle(
//                       fontSize: Responsive.fontSize(context, 0.07, min: 22, max: 28),
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0xFF0F172A),
//                     ),
//                   ),
//                   SizedBox(height: Responsive.spacing(context, 0.01)),
//                   Text(
//                     "We're here to help you anytime",
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: Responsive.fontSize(context, 0.035, min: 13, max: 16),
//                     ),
//                   ),
//                   SizedBox(height: Responsive.spacing(context, 0.03)),
//                   _buildContactCard(
//                     icon: Icons.call,
//                     title: "Call Now",
//                     subtitle: "8921923281",
//                     color: const Color(0xFF2563EB),
//                     onTap: makeCall,
//                   ),
//                   SizedBox(height: Responsive.spacing(context, 0.015)),
//                   _buildContactCard(
//                     icon: Icons.chat,
//                     title: "WhatsApp",
//                     subtitle: "Chat instantly with us",
//                     color: const Color(0xFF25D366),
//                     onTap: openWhatsApp,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildContactCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(color: Colors.grey.shade200),
//           boxShadow: [
//             BoxShadow(
//               // ignore: deprecated_member_use
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               height: 50,
//               width: 50,
//               decoration: BoxDecoration(
//                 // ignore: deprecated_member_use
//                 color: color.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: color, size: 26),
//             ),
//             const SizedBox(width: 15),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF0F172A),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: const TextStyle(
//                       fontSize: 13,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zindaonlineschool/core/constants/app_colors.dart';
import 'package:zindaonlineschool/core/constants/app_gaps.dart';
import 'package:zindaonlineschool/core/constants/app_space.dart'; 
import 'package:zindaonlineschool/core/constants/app_textstyle.dart'; 
import 'package:zindaonlineschool/core/utils/responsive.dart';
import 'package:zindaonlineschool/widgets/responsive_body.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  void makeCall() async {
    final Uri uri = Uri(scheme: 'tel', path: '8921923281');
    await launchUrl(uri);
  }

  void openWhatsApp() async {
    final Uri uri = Uri.parse("https://wa.me/918921923281");
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
        backgroundColor: AppColors.appBarFill,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.background,
        ),
        child: Center(
          child: ResponsiveBody(
            alignTop: false,
            child: Container(
              width: double.infinity,
              // Increased padding inside the primary card for an expanded feel
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.screenPadding(context).left,
                vertical: 40, 
              ),
              decoration: BoxDecoration(
                color: AppColors.cardFill, 
                borderRadius: BorderRadius.circular(30), // Slightly more premium rounded corners
                boxShadow: [
                  BoxShadow(
                    blurRadius: 40,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Added upper spacer inside the container to expand card presence
                  AppSpacing.h10,
                  Text(
                    "Get in Touch",
                    style: AppTextStyles.heading.copyWith(
                      fontSize: Responsive.fontSize(context, 0.08, min: 26, max: 32),
                      color: AppColors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  AppSpacing.h10,
                  Text(
                    "We're here to help you anytime",
                    style: AppTextStyles.small.copyWith(
                      fontSize: Responsive.fontSize(context, 0.038, min: 14, max: 17),
                      color: Colors.white54,
                    ),
                  ),
                  AppSpacing.h40, // Expanded spacing layout separation
                  
                  /// CALL CARD
                  _buildContactCard(
                    icon: const Icon(Icons.call_rounded, color: Color(0xFF3B82F6), size: 26),
                    title: "Call Now",
                    subtitle: "8921923281",
                    color: const Color(0xFF3B82F6),
                    onTap: makeCall,
                  ),
                  
                  AppSpacing.h20, // Increased gap between action items
                  
                  /// WHATSAPP CARD
                  _buildContactCard(
                    // Render your clean stored local workspace graphic resource asset file cleanly
                    icon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/images/whatsapp.png', 
                        fit: BoxFit.contain,
                      ),
                    ),
                    title: "WhatsApp",
                    subtitle: "Chat instantly with us",
                    color: const Color(0xFF25D366),
                    onTap: openWhatsApp,
                  ),
                  AppSpacing.h10,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required Widget icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Enhanced internal row item spacing bounds
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.7), 
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 52, // Expanded side thumbnail shape structures
              width: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(child: icon),
            ),
            AppSpacing.w15,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.subHeading.copyWith(
                      fontSize: 17,
                      color: AppColors.white,
                    ),
                  ),
                  AppSpacing.h5,
                  Text(
                    subtitle,
                    style: AppTextStyles.small.copyWith(
                      color: Colors.white60,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withOpacity(0.3),
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}