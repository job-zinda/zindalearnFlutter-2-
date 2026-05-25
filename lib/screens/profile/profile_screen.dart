import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import 'edit_profile_screen.dart';
import '../../widgets/responsive_body.dart';

class ProfileScreen extends StatefulWidget {
  final String token;

  const ProfileScreen({super.key, required this.token});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProfileProvider>().getProfile(token: widget.token);
    });
  }

  Future<void> _refresh() async {
    await context.read<ProfileProvider>().getProfile(token: widget.token);
  }

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<ProfileProvider>();
    final profile = provider.profileData;

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B023D),
        elevation: 0,
        title: const Text("My Profile"),
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())

          : profile == null
              ? const Center(
                  child: Text("No Profile Data",
                      style: TextStyle(color: Colors.white)),
                )

              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ResponsiveBody(
                    child: ListView(
                    children: [

                      const SizedBox(height: 10),

                      /// PROFILE HEADER (LIKE SETTINGS CARD STYLE)
                      _glassCard(
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            profile["name"] ?? "",
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            profile["email"] ?? "",
                            style: const TextStyle(color: Colors.white54),
                          ),
                          trailing: const Icon(
                            Icons.verified,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// INFO SECTION TITLE
                      _sectionTitle("Personal Info"),

                      _glassCard(
                        child: Column(
                          children: [
                            _tile(Icons.person, "Name", profile["name"] ?? ""),
                            const Divider(color: Colors.white10),
                            _tile(Icons.email, "Email", profile["email"] ?? ""),
                            const Divider(color: Colors.white10),
                            _tile(Icons.phone, "Phone", profile["phone"] ?? ""),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// EDIT BUTTON
                      _button(
                        text: "Edit Profile",
                        color: const Color.fromARGB(255, 78, 35, 131),

                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfileScreen(
                                token: widget.token,
                                profileData: profile,
                              ),
                            ),
                          );

                          if (result == true) _refresh();
                        },
                      ),

                      const SizedBox(height: 12),

                      /// DELETE BUTTON
                      _button(
                        text: "Delete Account",
                        color: Colors.red,

                        onTap: () async {
                          final (success, message) =
                              await context.read<ProfileProvider>()
                                  .deleteAccount(token: widget.token);

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message.toString())),
                          );

                          if (success) Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  /// 🔵 SAME SETTINGS STYLE CARD
  Widget _glassCard({required Widget child}) {
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

  /// TILE LIKE SETTINGS SCREEN
  Widget _tile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(value, style: const TextStyle(color: Colors.white70)),
    );
  }

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

  Widget _button({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onTap,
        child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}