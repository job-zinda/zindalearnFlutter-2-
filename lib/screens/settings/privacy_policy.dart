import 'package:flutter/material.dart';
import 'package:zindaonlineschool/core/utils/responsive.dart';
import 'package:zindaonlineschool/widgets/responsive_body.dart';

class PrivacyPolicyScreen extends StatelessWidget {
const PrivacyPolicyScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFF0B023D),

  appBar: AppBar(
    backgroundColor: const Color(0xFF0B023D),
    elevation: 0,
    centerTitle: true,
    title: Text(
      "Privacy Policy",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Responsive.fontSize(
          context,
          0.05,
          min: 18,
          max: 24,
        ),
      ),
    ),
  ),

  body: ResponsiveBody(
    child: SingleChildScrollView(
      padding: Responsive.screenPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// INTRODUCTION CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              "Zinda Online School is committed to protecting the privacy of students, tutors, and users who use our mobile application.\n\n"
              "This Privacy Policy explains how we collect, use, store, and protect your personal information.\n\n"
              "By using Zinda Online School, you agree to this Privacy Policy.",
              style: TextStyle(
                color: Colors.white,
                height: 1.8,
                fontSize: 15,
              ),
            ),
          ),

          const SizedBox(height: 28),

          _buildSection(
            title: "Information We Collect",
            content:
                "We may collect personal information such as name, email address, phone number, profile details, login credentials, and academic preferences.\n\n"
                "We also collect usage data such as app activity, device information, and interaction with tutors and courses to improve our services.",
          ),

          _buildSection(
            title: "How We Use Your Information",
            content:
                "Your information is used to provide educational services, connect students with tutors, manage accounts, process payments, improve learning experience, and provide support.\n\n"
                "We may also use your information to send important notifications, updates, and service-related messages.",
          ),

          _buildSection(
            title: "Data Sharing",
            content:
                "Zinda Online School does not sell or rent your personal data.\n\n"
                "We may share limited information with tutors, administrators, or service providers only to deliver educational services.\n\n"
                "We may also disclose information if required by law or government authorities.",
          ),

          _buildSection(
            title: "Data Security",
            content:
                "We use secure systems and encryption methods to protect your personal data.\n\n"
                "Access to user data is restricted to authorized personnel only.\n\n"
                "However, no online system is 100% secure, and we cannot guarantee absolute protection.",
          ),

          _buildSection(
            title: "Cookies & Tracking",
            content:
                "We may use cookies or similar technologies to improve app performance, user experience, and analytics.\n\n"
                "Users can disable cookies through device settings, but some features may not work properly.",
          ),

          _buildSection(
            title: "Third-Party Services",
            content:
                "Zinda Online School may use third-party services such as payment gateways, analytics tools, and communication services.\n\n"
                "These services have their own privacy policies, and we are not responsible for their practices.",
          ),

          _buildSection(
            title: "User Rights",
            content:
                "Users can access, update, or delete their personal information by contacting support.\n\n"
                "You may also request restrictions on certain data usage where applicable.",
          ),

          _buildSection(
            title: "Children's Privacy",
            content:
                "Students under 18 must use the platform under parental or guardian supervision.\n\n"
                "We do not knowingly collect data from children without proper consent.",
          ),

          _buildSection(
            title: "Changes to Privacy Policy",
            content:
                "Zinda Online School may update this Privacy Policy at any time.\n\n"
                "Continued use of the application means you accept any changes.",
          ),

          _buildSection(
            title: "Contact Us",
            content:
                "If you have any questions or concerns about this Privacy Policy, you can contact Zinda Online School support through the in-app support section or help center.",
          ),

          const SizedBox(height: 20),
        ],
      ),
    ),
  ),
);


}

static Widget _buildSection({
required String title,
required String content,
}) {
return Padding(
padding: const EdgeInsets.only(bottom: 28),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [


      Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 8),

      Container(
        width: 60,
        height: 3,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      const SizedBox(height: 14),

      Text(
        content,
        style: const TextStyle(
          color: Colors.white70,
          height: 1.8,
          fontSize: 15,
        ),
      ),
    ],
  ),
);


}
}
