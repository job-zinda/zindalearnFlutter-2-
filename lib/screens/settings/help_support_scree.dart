import 'package:flutter/material.dart';
import 'package:zindaonlineschool/core/utils/responsive.dart';
import 'package:zindaonlineschool/widgets/responsive_body.dart';

class FAQItem {
  final String question;
  final String answer;

  const FAQItem({
    required this.question,
    required this.answer,
  });
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = Responsive.contentWidth(context);

    const String introduction = """
Zinda Online School is a learning platform designed to help students study easily from home by connecting them with tutors, online classes, learning support, and educational resources.

Getting Started Guide

Before using Zinda Online School, take time to explore the app. You can browse courses, tutors, sessions, profile, chat support, feedback, and settings.

Choosing the Right Course or Tutor

Select courses based on your academic level. Zinda Online School offers Online Tuition, Skill Courses, and Talent Courses based on student needs.

Attend Classes Regularly

Regular attendance is important. Join sessions on time and follow tutor instructions for better learning results.

Use Chat & Support

If you face any issue with courses, tutors, payments, or technical problems, use the in-app support system to contact the Zinda Online School team.

Keep Your Profile Updated

Make sure your name, email, phone number, and profile details are always correct for better communication and support.

We hope Zinda Online School helps you achieve your learning goals. Keep growing and learning!
""";

    const List<FAQItem> faqs = [
      FAQItem(
        question: "What is Zinda Online School?",
        answer:
            "It is a mobile learning platform where students can learn from home using online tutors and classes.",
      ),
      FAQItem(
        question: "What services are available?",
        answer:
            "Online tuition, tutor connection, classes, chat support, feedback system, and learning assistance.",
      ),
      FAQItem(
        question: "Is it free?",
        answer:
            "Some services are free, but premium courses or tutors may require payment.",
      ),
      FAQItem(
        question: "How do I choose a tutor?",
        answer:
            "Browse tutor profiles, check ratings, and send a request to connect.",
      ),
      FAQItem(
        question: "How do I get help?",
        answer:
            "Use the in-app support or chat system to contact the Zinda Online School team.",
      ),
      FAQItem(
        question: "Why use Zinda Online School?",
        answer:
            "Because it provides flexible, home-based learning with expert tutors and structured guidance.",
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B023D),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Help & Support",
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

              /// INTRODUCTION TITLE
              Text(
                "Zinda Online School",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Responsive.fontSize(
                    context,
                    0.045,
                    min: 18,
                    max: 24,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              /// INTRODUCTION CARD
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(width * 0.045),
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
                child: Text(
                  introduction,
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.8,
                    fontSize: Responsive.fontSize(
                      context,
                      0.034,
                      min: 13,
                      max: 17,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              /// FAQ TITLE
              Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Responsive.fontSize(
                    context,
                    0.045,
                    min: 18,
                    max: 24,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              /// FAQ LIST
              ...faqs.map(
                (faq) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      iconColor: Colors.white,
                      collapsedIconColor: Colors.white,
                      title: Text(
                        faq.question,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.fontSize(
                            context,
                            0.035,
                            min: 14,
                            max: 18,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            0,
                            16,
                            16,
                          ),
                          child: Text(
                            faq.answer,
                            style: TextStyle(
                              color: Colors.white70,
                              height: 1.7,
                              fontSize: Responsive.fontSize(
                                context,
                                0.032,
                                min: 13,
                                max: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}