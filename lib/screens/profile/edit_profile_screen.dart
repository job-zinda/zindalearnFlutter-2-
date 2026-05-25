import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/responsive_body.dart';

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

class _EditProfileScreenState
    extends State<EditProfileScreen> {

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

    final provider =
        context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B023D),
        elevation: 0,
        title: const Text("Edit Profile"),
      ),

      body: Form(
        key: formKey,

        child: ResponsiveBody(
          child: ListView(
          children: [

            const SizedBox(height: 10),

            /// HEADER CARD
            _buildCard(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),

                title: const Text(
                  "Update Your Info",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),

                subtitle: const Text(
                  "Change your name & phone number",
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            _sectionTitle("Edit Details"),

            _buildCard(
              child: Column(
                children: [

                  _tileField(
                    icon: Icons.person,
                    label: "Name",
                    controller: nameController,
                  ),

                  const Divider(
                    color: Colors.white10,
                  ),

                  _tileField(
                    icon: Icons.phone,
                    label: "Phone",
                    controller: phoneController,
                    keyboard: TextInputType.phone,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(
                      255,
                      78,
                      35,
                      131,
                    ),

                padding:
                    const EdgeInsets.symmetric(
                  vertical: 14,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),

              onPressed:
                  provider.isLoading
                  ? null
                  : () async {

                      if (!formKey
                          .currentState!
                          .validate()) {
                        return;
                      }

                      final (
                        success,
                        message,
                      ) = await provider
                          .updateProfile(
                        token: widget.token,

                        name: nameController.text
                            .trim(),

                        phone:
                            phoneController.text
                                .trim(),
                      );

                      if (!context.mounted)
                        return;

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(
                            message.toString(),
                          ),
                        ),
                      );

                      if (success) {
                        Navigator.pop(
                          context,
                          true,
                        );
                      }
                    },

              child: provider.isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      "Save Changes",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  /// CARD
  Widget _buildCard({
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.06,
        ),

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.2,
            ),

            blurRadius: 10,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: child,
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 10),

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

  /// FORM FIELD
  Widget _tileField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    TextInputType keyboard =
        TextInputType.text,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),

      title: TextFormField(
        controller: controller,

        keyboardType: keyboard,

        style: const TextStyle(
          color: Colors.white,
        ),

        validator: (value) {

          if (value == null ||
              value.trim().isEmpty) {

            return "$label is required";
          }

          return null;
        },

        decoration: InputDecoration(
          border: InputBorder.none,

          labelText: label,

          labelStyle:
              const TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}