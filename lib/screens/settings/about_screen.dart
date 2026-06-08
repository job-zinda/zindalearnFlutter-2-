import 'package:flutter/material.dart';
import 'package:zindaonlineschool/core/utils/responsive.dart';
import 'package:zindaonlineschool/widgets/responsive_body.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B023D),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "About Zinda Online School",
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

              /// HERO CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple.shade700,
                      Colors.indigo.shade700,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 60,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Welcome to Zinda Online School",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "A modern learning platform helping students connect with tutors, attend online classes, and achieve academic success from anywhere.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              _buildSection(
                "Our Mission",
                "Our mission is to make quality education accessible to every student regardless of location or background. Through technology and digital learning tools, we aim to simplify education and support academic growth.",
              ),

              _buildTitle("What We Offer"),

              const SizedBox(height: 16),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  FeatureCard(
                    icon: Icons.video_call,
                    title: "Online Tuition",
                  ),
                  FeatureCard(
                    icon: Icons.person,
                    title: "Verified Tutors",
                  ),
                  FeatureCard(
                    icon: Icons.menu_book,
                    title: "Subject Learning",
                  ),
                  FeatureCard(
                    icon: Icons.live_tv,
                    title: "Live Sessions",
                  ),
                  FeatureCard(
                    icon: Icons.support_agent,
                    title: "Student Support",
                  ),
                  FeatureCard(
                    icon: Icons.chat,
                    title: "Chat Assistance",
                  ),
                  FeatureCard(
                    icon: Icons.analytics,
                    title: "Performance Tracking",
                  ),
                ],
              ),

              const SizedBox(height: 30),

              _buildSection(
                "How It Works",
                "Students can browse courses and tutors, review profiles and ratings, send tutor requests, and begin learning after approval and enrollment. The platform makes online education simple and organized.",
              ),

              _buildTitle("Why Choose Zinda Online School"),

              const SizedBox(height: 16),

              const BenefitTile(
                text: "Learn from home easily",
              ),
              BenefitTile(
                text: "Flexible learning schedule",
              ),
              BenefitTile(
                text: "Verified tutors",
              ),
              BenefitTile(
                text: "Secure learning platform",
              ),
              BenefitTile(
                text: "Personalized learning experience",
              ),

              const SizedBox(height: 30),

              _buildSection(
                "Our Vision",
                "We aim to become one of the most trusted online learning platforms by delivering high-quality education and helping students succeed through innovation and technology.",
              ),

              _buildSection(
                "Support",
                "We provide dedicated assistance through in-app support, chat services, and help resources to ensure students receive timely academic and technical guidance.",
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.redAccent,
                      size: 40,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Thank You",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Thank you for choosing Zinda Online School. We are committed to supporting your learning journey and helping you achieve your academic goals.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: 3,
          color: Colors.amber,
        ),
      ],
    );
  }

  static Widget _buildSection(
    String title,
    String content,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(title),
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

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.amber, size: 30),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class BenefitTile extends StatelessWidget {
  final String text;

  const BenefitTile({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}