
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:zindaonlineschool/screens/auth/login_screen.dart';
// import 'package:zindaonlineschool/widgets/custom_snackbar.dart';
// import '../../providers/profile_provider.dart';
// import 'edit_profile_screen.dart';
// import '../../widgets/responsive_body.dart';

// class ProfileScreen extends StatefulWidget {
//   final String token;

//   const ProfileScreen({super.key, required this.token});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       context.read<ProfileProvider>().getProfile(token: widget.token);
//     });
//   }

//   Future<void> _refresh() async {
//     await context.read<ProfileProvider>().getProfile(token: widget.token);
//   }

//   void _showDeleteConfirmation(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (dialogContext) {
//         return AlertDialog(
//           backgroundColor: const Color(0xFF1E1B4B), // Custom deep indigo
//           title: const Text(
//             "Delete Account?",
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           content: const Text(
//             "This action cannot be undone. You will lose access to all your registered courses and certificates permanently.",
//             style: TextStyle(color: Colors.white70),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(dialogContext),
//               child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
//               onPressed: () async {
//                 Navigator.pop(dialogContext);
                
//                 final profileProvider = context.read<ProfileProvider>();
//                 final (success, message) = await profileProvider.deleteAccount(token: widget.token);
                
//                 if (success) {
//                   if (context.mounted) {
//                     // Using your CustomSnackbar instead of default SnackBar
//                     CustomSnackbar.success(context, message ?? "Account deleted successfully.");
                    
//                     // Boot user out to login screen
//                     Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(builder: (_) => const LoginScreen()), // Ensure LoginScreen is imported
//                       (route) => false,
//                     );
//                   }
//                 } else {
//                   if (context.mounted) {
//                     CustomSnackbar.error(context, message ?? "Failed to delete account.");
//                   }
//                 }
//               },
//               child: const Text("Delete Permanently", style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<ProfileProvider>();
//     final profile = provider.profileData;

//     return Scaffold(
//       backgroundColor: const Color(0xFF0B023D),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0B023D),
//         elevation: 0,
//         title: const Text("My Profile"),
//       ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : profile == null
//               ? const Center(
//                   child: Text("No Profile Data",
//                       style: TextStyle(color: Colors.white)),
//                 )
//               : RefreshIndicator(
//                   onRefresh: _refresh,
//                   child: ResponsiveBody(
//                     child: ListView(
//                       children: [
//                         const SizedBox(height: 10),

//                         /// PROFILE HEADER
//                         _glassCard(
//                           child: ListTile(
//                             leading:CircleAvatar(
//   radius: 28,
//   backgroundColor: Colors.white24,
//   backgroundImage: provider.image != null
//       ? FileImage(provider.image!) as ImageProvider // 1. 👇 Show the newly picked local image instantly!
//       : (profile["photo"] == null || profile["photo"].toString().isEmpty)
//           ? null
//           : (profile["photo"].toString().startsWith('http://') || profile["photo"].toString().startsWith('https://'))
//               ? NetworkImage(profile["photo"].toString()) // 2. Fallback to Cloudinary URL
//               : MemoryImage(base64Decode(profile["photo"].toString())), // 3. Fallback to raw base64
//   child: provider.image == null && (profile["photo"] == null || profile["photo"].toString().isEmpty)
//       ? const Icon(
//           Icons.person,
//           color: Colors.white,
//         )
//       : null,
// ),
//                             title: Text(
//                               profile["name"] ?? "",
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                             subtitle: Text(
//                               profile["email"] ?? "",
//                               style: const TextStyle(color: Colors.white54),
//                             ),
//                             trailing: const Icon(
//                               Icons.verified,
//                               color: Colors.greenAccent,
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 15),

//                         /// INFO SECTION TITLE
//                         _sectionTitle("Personal Info"),

//                         _glassCard(
//                           child: Column(
//                             children: [
//                               _tile(Icons.person, "Name", profile["name"] ?? ""),
//                               const Divider(color: Colors.white10),
//                               _tile(Icons.email, "Email", profile["email"] ?? ""),
//                               const Divider(color: Colors.white10),
//                               _tile(Icons.phone, "Phone", profile["phone"] ?? ""),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 25),

//                         /// EDIT BUTTON
//                         _button(
//                           text: "Edit Profile",
//                           color: const Color.fromARGB(255, 78, 35, 131),
//                           onTap: () async {
//                             final result = await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => EditProfileScreen(
//                                   token: widget.token,
//                                   profileData: profile,
//                                 ),
//                               ),
//                             );

//                             if (result == true) _refresh();
//                           },
//                         ),

//                         const SizedBox(height: 12),

//                         /// DELETE BUTTON
//                         // _button(
//                         //   text: "Delete Account",
//                         //   color: Colors.red,
//                         //   onTap: () async {
//                         //     final (success, message) =
//                         //         await context.read<ProfileProvider>()
//                         //             .deleteAccount(token: widget.token);

//                         //     if (!context.mounted) return;

//                         //     ScaffoldMessenger.of(context).showSnackBar(
//                         //       SnackBar(content: Text(message.toString())),
//                         //     );

//                         //     if (success) Navigator.pop(context);
//                         //   },
//                         // ),

//                         _button(
//   text: "Delete Account",
//   color: Colors.red,
//   onTap: () => _showDeleteConfirmation(context), // <--- Simply call the dialog builder function here!
// ),
//                       ],
//                     ),
//                   ),
//                 ),
//     );
//   }

//   Widget _glassCard({required Widget child}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.06),
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0,5),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }

//   Widget _tile(IconData icon, String title, String value) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.white),
//       title: Text(title, style: const TextStyle(color: Colors.white)),
//       subtitle: Text(value, style: const TextStyle(color: Colors.white70)),
//     );
//   }

//   Widget _sectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Text(
//         title,
//         style: const TextStyle(
//           color: Colors.white70,
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Widget _button({
//     required String text,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//         ),
//         onPressed: onTap,
//         child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/screens/auth/login_screen.dart';
import 'package:zindaonlineschool/widgets/custom_snackbar.dart';
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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1B4B), // Custom deep indigo
          title: const Text(
            "Delete Account?",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "This action cannot be undone. You will lose access to all your registered courses and certificates permanently.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                Navigator.pop(dialogContext);
                
                final profileProvider = context.read<ProfileProvider>();
                final (success, message) = await profileProvider.deleteAccount(token: widget.token);
                
                if (success) {
                  if (context.mounted) {
                    // 1. CLEAR LOCAL STORAGE HERE IF APPLICABLE
                    // e.g., await SharedPreferences.getInstance().then((p) => p.remove('token'));

                    // 2. Show Success Alert
                    CustomSnackbar.success(context, message ?? "Account deleted successfully.");
                    
                    // 3. Clear routing history and redirect straight to authentication screen
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                } else {
                  if (context.mounted) {
                    CustomSnackbar.error(context, message ?? "Failed to delete account.");
                  }
                }
              },
              child: const Text("Delete Permanently", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        const SizedBox(height: 10),

                        /// PROFILE HEADER
                        _glassCard(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white24,
                              backgroundImage: provider.image != null
                                  ? FileImage(provider.image!) as ImageProvider
                                  : (profile["photo"] == null || profile["photo"].toString().isEmpty)
                                      ? null
                                      : (profile["photo"].toString().startsWith('http://') || profile["photo"].toString().startsWith('https://'))
                                          ? NetworkImage(profile["photo"].toString())
                                          : MemoryImage(base64Decode(profile["photo"].toString())),
                              child: provider.image == null && (profile["photo"] == null || profile["photo"].toString().isEmpty)
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    )
                                  : null,
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
                          onTap: () => _showDeleteConfirmation(context),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

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
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}