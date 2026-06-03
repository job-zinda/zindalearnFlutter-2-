import 'package:flutter/material.dart';
import 'package:zindaonlineschool/widgets/legal_screenTemplate.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalScreenTemplate(
      title: "Privacy Policy",

      body: [

        "Introduction",

        "Zinda Online School is committed to protecting the privacy of students, tutors, and users who use our mobile application.",

        "This Privacy Policy explains how we collect, use, store, and protect your personal information.",

        "By using Zinda Online School, you agree to this Privacy Policy.",

        "Information We Collect",

        "We may collect personal information such as name, email address, phone number, profile details, login credentials, and academic preferences.",

        "We also collect usage data such as app activity, device information, and interaction with tutors and courses to improve our services.",

        "How We Use Your Information",

        "Your information is used to provide educational services, connect students with tutors, manage accounts, process payments, improve learning experience, and provide support.",

        "We may also use your information to send important notifications, updates, and service-related messages.",

        "Data Sharing",

        "Zinda Online School does not sell or rent your personal data.",

        "We may share limited information with tutors, administrators, or service providers only to deliver educational services.",

        "We may also disclose information if required by law or government authorities.",

        "Data Security",

        "We use secure systems and encryption methods to protect your personal data.",

        "Access to user data is restricted to authorized personnel only.",

        "However, no online system is 100% secure, and we cannot guarantee absolute protection.",

        "Cookies & Tracking",

        "We may use cookies or similar technologies to improve app performance, user experience, and analytics.",

        "Users can disable cookies through device settings, but some features may not work properly.",

        "Third-Party Services",

        "Zinda Online School may use third-party services such as payment gateways, analytics tools, and communication services.",

        "These services have their own privacy policies, and we are not responsible for their practices.",

        "User Rights",

        "Users can access, update, or delete their personal information by contacting support.",

        "You may also request restrictions on certain data usage where applicable.",

        "Children Privacy",

        "Students under 18 must use the platform under parental or guardian supervision.",

        "We do not knowingly collect data from children without proper consent.",

        "Changes to Privacy Policy",

        "Zinda Online School may update this Privacy Policy at any time.",

        "Continued use of the application means you accept any changes.",

        "Contact Us",

        "If you have any questions or concerns about this Privacy Policy, you can contact Zinda Online School support through the in-app support section or help center."
      ],
    );
  }
}