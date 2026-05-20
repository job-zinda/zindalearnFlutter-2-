import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  final String token;

  const ProfileScreen({
    super.key,
    required this.token,
  });

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

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<ProfileProvider>(context);

    final profile = provider.profileData;

    return Scaffold(

      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
      ),

      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )

          : profile == null
              ? const Center(
                  child: Text("No Profile Data"),
                )

              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [

                      /// PROFILE IMAGE
                      CircleAvatar(
                        radius: 60,

                        backgroundImage:
                            profile["profile"] != null
                                ? NetworkImage(
                                    profile["profile"],
                                  )
                                : null,

                        child: profile["profile"] == null
                            ? const Icon(
                                Icons.person,
                                size: 60,
                              )
                            : null,
                      ),

                      const SizedBox(height: 20),

                      /// NAME
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text("Name"),
                          subtitle:
                              Text(profile["name"] ?? ""),
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// EMAIL
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.email),
                          title: const Text("Email"),
                          subtitle:
                              Text(profile["email"] ?? ""),
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// PHONE
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.phone),
                          title: const Text("Phone"),
                          subtitle:
                              Text(profile["phone"] ?? ""),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// EDIT BUTTON
                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          onPressed: () {

                          },

                          child: const Text(
                            "Edit Profile",
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// DELETE ACCOUNT
                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),

                          onPressed: () async {

                            final provider =
                                context.read<ProfileProvider>();

                            final (success, message) =
                                await provider.deleteAccount(
                              token: widget.token,
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

                          child: const Text(
                            "Delete Account",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}