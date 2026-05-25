import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 13, 2, 64),
        ),
        child: Center(
          child: ResponsiveBody(
            alignTop: false,
            child: Container(
              width: double.infinity,
              padding: Responsive.screenPadding(context),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 30,
                    color: Colors.black26,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Get in Touch",
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 0.07, min: 22, max: 28),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, 0.01)),
                  Text(
                    "We're here to help you anytime",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: Responsive.fontSize(context, 0.035, min: 13, max: 16),
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, 0.03)),
                  _buildContactCard(
                    icon: Icons.call,
                    title: "Call Now",
                    subtitle: "8921923281",
                    color: const Color(0xFF2563EB),
                    onTap: makeCall,
                  ),
                  SizedBox(height: Responsive.spacing(context, 0.015)),
                  _buildContactCard(
                    icon: Icons.chat,
                    title: "WhatsApp",
                    subtitle: "Chat instantly with us",
                    color: const Color(0xFF25D366),
                    onTap: openWhatsApp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
