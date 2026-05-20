import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/screens/profile/edit_profile_screen.dart';
import '../../providers/profile_provider.dart';

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
      context.read<ProfileProvider>().getProfile(
        token: widget.token,
      );
    });
  }

  Future<void> _refreshProfile() async {
    await context.read<ProfileProvider>().getProfile(
      token: widget.token,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final profile = provider.profileData;

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B023D),
        title: const Text("Profile"),
        centerTitle: true,
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())

          : profile == null
              ? const Center(
                  child: Text(
                    "No Profile Data",
                    style: TextStyle(color: Colors.white),
                  ),
                )

              : RefreshIndicator(
                  onRefresh: _refreshProfile,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      children: [

                        /// ================= PROFILE IMAGE =================
                        Stack(
                          children: [

                            CircleAvatar(
                              radius: 55,

                              backgroundImage: provider.image != null
                                  ? FileImage(provider.image!)
                                  : (profile["profile"] != null
                                      ? NetworkImage(profile["profile"])
                                      : null) as ImageProvider?,

                              child: profile["profile"] == null &&
                                      provider.image == null
                                  ? const Icon(Icons.person,
                                      size: 50, color: Colors.white)
                                  : null,
                            ),

                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  _showImagePicker(context);
                                },

                                child: const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.purple,
                                  child: Icon(Icons.camera_alt,
                                      size: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        /// ================= UPLOAD BUTTON =================
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                            ),

                            onPressed: provider.isLoading
                                ? null
                                : () async {
                                    final (success, message) =
                                        await context
                                            .read<ProfileProvider>()
                                            .uploadProfileImage(
                                              token: widget.token,
                                            );

                                    if (!context.mounted) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(message.toString()),
                                      ),
                                    );

                                    if (success) {
                                      _refreshProfile();
                                    }
                                  },

                            child: provider.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text("Upload Profile Photo"),
                          ),
                        ),

                        const SizedBox(height: 25),

                        /// ================= CARDS =================
                        _buildCard(Icons.person, "Name", profile["name"] ?? ""),
                        _buildCard(Icons.email, "Email", profile["email"] ?? ""),
                        _buildCard(Icons.phone, "Phone", profile["phone"] ?? ""),

                        const SizedBox(height: 30),

                        /// ================= EDIT BUTTON =================
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),

                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditProfileScreen(
                                    token: widget.token,
                                    profileData: profile,
                                  ),
                                ),
                              );

                              if (result == true) {
                                _refreshProfile();
                              }
                            },

                            child: const Text("Edit Profile"),
                          ),
                        ),

                        const SizedBox(height: 15),

                        /// ================= DELETE BUTTON =================
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),

                            onPressed: () async {
                              final (success, message) = await context
                                  .read<ProfileProvider>()
                                  .deleteAccount(token: widget.token);

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(message.toString())),
                              );

                              if (success) {
                                Navigator.pop(context);
                              }
                            },

                            child: const Text("Delete Account"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  /// ================= CARD WIDGET =================
  Widget _buildCard(IconData icon, String title, String value) {
    return Card(
      color: Colors.white10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title,
            style: const TextStyle(color: Colors.white70)),
        subtitle: Text(value,
            style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  /// ================= IMAGE PICKER =================
  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [

              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () {
                  context
                      .read<ProfileProvider>()
                      .pickImageFromGallery();
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  context
                      .read<ProfileProvider>()
                      .pickImageFromCamera();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}