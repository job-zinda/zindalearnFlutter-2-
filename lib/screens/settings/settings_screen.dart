import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zindaonlineschool/screens/auth/login_screen.dart';
import 'package:zindaonlineschool/screens/profile/profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  final String token;

  const SettingsScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B023D),
        elevation: 0,
        title: const Text("Settings"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [

          /// PROFILE CARD ⭐
          _buildCard(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: const Text(
                "My Profile",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                "View & edit your profile",
                style: TextStyle(color: Colors.white54),
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white54, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(token: token),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 15),

          /// SUPPORT SECTION
          _sectionTitle("Support"),

          _buildCard(
            child: Column(
              children: [

                _tile(Icons.help, "Help & Support"),
                const Divider(color: Colors.white10),

                _tile(Icons.feedback, "Feedback"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// LEGAL SECTION
          _sectionTitle("Legal"),

          _buildCard(
            child: Column(
              children: [

                _tile(Icons.description, "Terms & Conditions"),
                const Divider(color: Colors.white10),

                _tile(Icons.privacy_tip, "Privacy Policy"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// ABOUT
          _buildCard(
            child: _tile(Icons.info, "About Zinda Learn"),
          ),

          const SizedBox(height: 30),

          /// LOGOUT BUTTON 🔴
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove("token");

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text(
              "Logout",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// CARD DESIGN
  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  /// LIST TILE DESIGN
  Widget _tile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title,
          style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios,
          color: Colors.white54, size: 16),
      onTap: () {},
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}