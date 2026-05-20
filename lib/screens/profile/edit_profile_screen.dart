import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> profileData;

  const EditProfileScreen({
    super.key,
    required this.token,
    required this.profileData,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.profileData["name"] ?? "",
    );

    phoneController = TextEditingController(
      text: widget.profileData["phone"] ?? "",
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B023D),
        elevation: 0,
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: formKey,

          child: Column(
            children: [

              const SizedBox(height: 20),

              /// PROFILE IMAGE (INSTAGRAM STYLE)
              Stack(
                alignment: Alignment.bottomRight,
                children: [

                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        widget.profileData["profile"] != null
                            ? NetworkImage(widget.profileData["profile"])
                            : null,
                    child: widget.profileData["profile"] == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),

                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),

                    child: IconButton(
                      icon: const Icon(Icons.edit,
                          color: Colors.white, size: 18),
                      onPressed: () {
                        // TODO: upload image later
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// NAME FIELD
              _buildField(
                controller: nameController,
                label: "Name",
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              /// PHONE FIELD
              _buildField(
                controller: phoneController,
                label: "Phone",
                icon: Icons.phone,
                keyboard: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter phone";
                  }
                  if (value.length < 10) {
                    return "Enter valid phone";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              /// UPDATE BUTTON (MODERN STYLE)
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
onPressed: provider.isLoading
    ? null
    : () async {

        if (!formKey.currentState!.validate()) return;

        final (success, message) =
            await provider.updateProfile(
          token: widget.token,
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
        );

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.toString())),
        );

        /// 🔥 IMPORTANT FIX
        if (success) {
          Navigator.pop(context, true);
        }
      },

                  child: provider.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Update Profile",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
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

  /// REUSABLE INPUT FIELD
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,

      style: const TextStyle(color: Colors.white),

      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),

        prefixIcon: Icon(icon, color: Colors.white70),

        filled: true,
        fillColor: Colors.white10,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white24),
        ),
      ),

      validator: validator,
    );
  }
}