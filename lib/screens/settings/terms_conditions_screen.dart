import 'package:flutter/material.dart';
import 'package:zindaonlineschool/core/utils/responsive.dart';
import 'package:zindaonlineschool/widgets/responsive_body.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B023D),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Terms & Conditions",
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
                  "Zinda Online School is a mobile learning platform designed to help students learn from home by connecting them with tutors, online classes, academic support, and learning resources.\n\n"
                  "By accessing or using Zinda Online School, you confirm that you have read, understood, and accepted these Terms & Conditions.\n\n"
                  "These terms form a legally binding agreement between the User and Zinda Online School.",
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.8,
                    fontSize: 15,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              _buildSection(
                title: "Services",
                content:
                    "Zinda Online School provides educational services including online tuition, tutor discovery, learning sessions, student support, communication features, and learning guidance.\n\n"
                    "Certain services may require registration, approval, subscription, or payment before access is granted.",
              ),

              _buildSection(
                title: "Account Registration",
                content:
                    "Users may be required to create an account using details such as name, email, phone number, profile information, and login credentials.\n\n"
                    "Users must maintain accurate information and keep account credentials confidential.\n\n"
                    "Any activity performed using your account will be considered your responsibility.",
              ),

              _buildSection(
                title: "Eligibility",
                content:
                    "Users must be legally permitted to use digital services under applicable law.\n\n"
                    "Students under 18 years may use the application with supervision or consent from parents or legal guardians.",
              ),

              _buildSection(
                title: "Payments",
                content:
                    "Some learning services on Zinda Online School may be paid.\n\n"
                    "Fees may vary depending on tutors, courses, subscriptions, or selected services.\n\n"
                    "Payments completed inside the platform are generally non-refundable unless explicitly stated otherwise.",
              ),

              _buildSection(
                title: "User Conduct",
                content:
                    "Users agree not to misuse the platform, upload harmful content, disturb tutors or students, impersonate others, commit fraud, or engage in unlawful activities.\n\n"
                    "Harassment, abusive communication, fake information, or misuse of chat and learning services may result in warnings, restrictions, or account suspension.",
              ),

              _buildSection(
                title: "License & Access",
                content:
                    "Users receive a limited, personal, non-exclusive license to access and use Zinda Online School for educational purposes only.\n\n"
                    "Users are not permitted to copy, resell, reproduce, distribute, modify, record, or commercially exploit platform content without written permission.",
              ),

              _buildSection(
                title: "Communication",
                content:
                    "By using Zinda Online School, users agree to receive service notifications, support messages, learning updates, payment information, and communication through email, phone, WhatsApp, in-app messages, or other contact methods provided.",
              ),

              _buildSection(
                title: "Disclaimer",
                content:
                    "Zinda Online School provides services on an 'as available' basis.\n\n"
                    "We do not guarantee uninterrupted availability, specific academic results, examination success, or learning outcomes.\n\n"
                    "Learning success depends on attendance, effort, tutor guidance, and individual student performance.",
              ),

              _buildSection(
                title: "Limitation of Liability",
                content:
                    "Zinda Online School shall not be liable for indirect losses, device issues, internet failures, third-party service interruptions, payment gateway failures, or consequences resulting from misuse of the application.",
              ),

              _buildSection(
                title: "Termination",
                content:
                    "We reserve the right to suspend, restrict, or terminate accounts that violate platform policies, misuse services, provide misleading information, or engage in unlawful activities.",
              ),

              _buildSection(
                title: "Privacy",
                content:
                    "Use of Zinda Online School is also governed by our Privacy Policy.\n\n"
                    "By using the application, users consent to collection and use of information required for providing educational services and platform functionality.",
              ),

              _buildSection(
                title: "Changes to Terms",
                content:
                    "Zinda Online School may update these Terms & Conditions from time to time without prior notice.\n\n"
                    "Continued use of the application after changes indicates acceptance of revised terms.",
              ),

              _buildSection(
                title: "Contact Support",
                content:
                    "For questions regarding Terms & Conditions, services, payments, or platform usage, contact Zinda Online School support through the application's support section.",
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