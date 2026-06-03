import 'package:flutter/material.dart';
import 'package:zindaonlineschool/widgets/legal_screenTemplate.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {

  return const LegalScreenTemplate(
  title: "Help & Support",

  body: [

    // =====================
    // INTRO SECTION (PARAGRAPH STYLE)
    // =====================

    "Zinda Online School is a learning platform designed to help students study easily from home by connecting them with tutors, online classes, learning support, and educational resources. Our mission is to make learning simple, accessible, reliable, and helpful for every student.",

    // =====================
    // QUICK GUIDE HEADER
    // =====================

    "Getting Started Guide",

    "Before using Zinda Online School, take time to explore the app. You can browse courses, tutors, sessions, profile, chat support, feedback, and settings.",

    "Choosing the Right Course or Tutor",

    "Select courses based on your academic level. Zinda Online School offers Online Tuition, Skill Courses, and Talent Courses based on student needs.",

    "Attend Classes Regularly",

    "Regular attendance is important. Join sessions on time and follow tutor instructions for better learning results.",

    "Use Chat & Support",

    "If you face any issue with courses, tutors, payments, or technical problems, use the in-app support system to contact the Zinda Online School team.",

    "Keep Your Profile Updated",

    "Make sure your name, email, phone number, and profile details are always correct for better communication and support.",

    // =====================
    // FAQ SECTION HEADER
    // =====================

    "Frequently Asked Questions",

    "Q1. What is Zinda Online School?\n\nIt is a mobile learning platform where students can learn from home using online tutors and classes.",

    "Q2. What services are available?\n\nOnline tuition, tutor connection, classes, chat support, feedback system, and learning assistance.",

    "Q3. Is it free?\n\nSome services are free, but premium courses or tutors may require payment.",

    "Q4. How do I choose a tutor?\n\nBrowse tutor profiles, check ratings, and send a request to connect.",

    "Q5. How do I get help?\n\nUse the in-app support or chat system to contact the Zinda Online School team.",

    "Q6. Why use Zinda Online School?\n\nBecause it provides flexible, home-based learning with expert tutors and structured guidance.",

    "We hope Zinda Online School helps you achieve your learning goals. Keep growing and learning!"
  ],
);
  }
}