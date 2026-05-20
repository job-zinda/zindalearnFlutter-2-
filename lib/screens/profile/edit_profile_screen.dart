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
        Provider.of<ProfileProvider>(context);

    return Scaffold(

      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            children: [

              /// PROFILE IMAGE
              CircleAvatar(
                radius: 55,

                backgroundImage:
                    widget.profileData["profile"] != null
                        ? NetworkImage(
                            widget.profileData["profile"],
                          )
                        : null,

                child:
                    widget.profileData["profile"] == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                          )
                        : null,
              ),

              const SizedBox(height: 30),

              /// NAME FIELD
              TextFormField(
                controller: nameController,

                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),

                validator: (value) {

                  if (value == null ||
                      value.trim().isEmpty) {

                    return "Enter name";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              /// PHONE FIELD
              TextFormField(
                controller: phoneController,

                keyboardType: TextInputType.phone,

                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),

                validator: (value) {

                  if (value == null ||
                      value.trim().isEmpty) {

                    return "Enter phone";
                  }

                  if (value.length < 10) {
                    return "Enter valid phone";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 35),

              /// UPDATE BUTTON
              SizedBox(
                width: double.infinity,

                height: 50,

                child: ElevatedButton(

                  onPressed: provider.isLoading
                      ? null
                      : () async {

                          if (!formKey.currentState!
                              .validate()) {
                            return;
                          }

                          final (success, message) =
                              await provider.updateProfile(
                            token: widget.token,
                            name: nameController.text.trim(),
                            phone:
                                phoneController.text.trim(),
                          );

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                message.toString(),
                              ),
                            ),
                          );

                          if (success) {

                            Navigator.pop(context);
                          }
                        },

                  child: provider.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Update Profile",
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