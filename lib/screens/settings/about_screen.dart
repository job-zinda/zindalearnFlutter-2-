import 'package:flutter/material.dart';
import 'package:zindaonlineschool/widgets/legal_screenTemplate.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalScreenTemplate(
      title: "About Zinda Online School",

      body: [

        "About Us",

        "Zinda Online School is a modern mobile learning application designed to help students study from home in an easy, flexible, and effective way.",

        "Our platform connects students with experienced tutors, online classes, academic support, and personalized learning resources to improve education quality.",

        "Our Mission",

        "Our mission is to make quality education accessible to every student, regardless of location or background, using technology and digital learning tools.",

        "We aim to simplify learning and help students understand subjects better through guided support and structured online education.",

        "What We Offer",

        "✔ Online Tuition Classes",
        "✔ Skilled & Verified Tutors",
        "✔ Subject-based Learning",
        "✔ Live Online Sessions",
        "✔ Student Support System",
        "✔ Chat Assistance with Admin",
        "✔ Feedback & Performance Tracking",

        "How It Works",

        "Students can browse available courses and tutors, view profiles, check ratings, and send requests to connect with tutors.",

        "Once approved by the admin and payment is completed, students are assigned to tutors for online learning sessions.",

        "Why Choose Zinda Online School",

        "✔ Learn from home easily",
        "✔ Flexible learning schedule",
        "✔ Verified tutors",
        "✔ Secure platform",
        "✔ Personalized learning experience",

        "Our Vision",

        "We aim to become one of the most trusted online learning platforms by delivering high-quality education and improving student success through technology.",

        "Support",

        "We provide dedicated support for students through chat, help center, and in-app assistance for any academic or technical issues.",

        "Thank You",

        "Thank you for choosing Zinda Online School. We are committed to supporting your learning journey and helping you achieve your academic goals."
      ],
    );
  }
}