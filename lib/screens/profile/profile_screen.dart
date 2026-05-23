// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/profile_provider.dart';
// import 'edit_profile_screen.dart';

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
//       context.read<ProfileProvider>().getProfile(
//         token: widget.token,
//       );
//     });
//   }

//   Future<void> _refreshProfile() async {
//     await context.read<ProfileProvider>().getProfile(
//       token: widget.token,
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
//         title: const Text("Profile"),
//         centerTitle: true,
//       ),

//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())

//           : profile == null
//               ? const Center(
//                   child: Text(
//                     "No Profile Data",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 )

//               : RefreshIndicator(
//                   onRefresh: _refreshProfile,
//                   child: SingleChildScrollView(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     padding: const EdgeInsets.all(16),

//                     child: Column(
//                       children: [

//                         const SizedBox(height: 20),

//                         /// ================= NAME =================
//                         _buildCard(
//                           Icons.person,
//                           "Name",
//                           profile["name"] ?? "",
//                         ),

//                         const SizedBox(height: 10),

//                         /// ================= EMAIL =================
//                         _buildCard(
//                           Icons.email,
//                           "Email",
//                           profile["email"] ?? "",
//                         ),

//                         const SizedBox(height: 10),

//                         /// ================= PHONE =================
//                         _buildCard(
//                           Icons.phone,
//                           "Phone",
//                           profile["phone"] ?? "",
//                         ),

//                         const SizedBox(height: 30),

//                         /// ================= EDIT BUTTON =================
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.purple,
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),

//                             onPressed: () async {
//                               final result = await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => EditProfileScreen(
//                                     token: widget.token,
//                                     profileData: profile,
//                                   ),
//                                 ),
//                               );

//                               if (result == true) {
//                                 _refreshProfile();
//                               }
//                             },

//                             child: const Text("Edit Profile"),
//                           ),
//                         ),

//                         const SizedBox(height: 15),

//                         /// ================= DELETE BUTTON =================
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),

//                             onPressed: () async {
//                               final (success, message) =
//                                   await context.read<ProfileProvider>()
//                                       .deleteAccount(token: widget.token);

//                               if (!context.mounted) return;

//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text(message.toString())),
//                               );

//                               if (success) {
//                                 Navigator.pop(context);
//                               }
//                             },

//                             child: const Text("Delete Account"),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//     );
//   }

//   /// ================= CARD WIDGET =================
//   Widget _buildCard(IconData icon, String title, String value) {
//     return Card(
//       color: Colors.white10,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: ListTile(
//         leading: Icon(icon, color: Colors.white),
//         title: Text(
//           title,
//           style: const TextStyle(color: Colors.white70),
//         ),
//         subtitle: Text(
//           value,
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/profile_provider.dart';
import 'edit_profile_screen.dart';

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

  Future<void> _refresh() async {
    await context.read<ProfileProvider>().getProfile(
      token: widget.token,
    );
  }

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<ProfileProvider>();
    final profile = provider.profileData;

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B023D),
        elevation: 0,
        title: const Text("My Profile"),
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
                  onRefresh: _refresh,

                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      children: [

                        const SizedBox(height: 20),

                        /// ================= PROFILE HEADER CARD =================
                        Container(
                          width: size.width,
                          padding: const EdgeInsets.all(20),

                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF6A1B9A),
                                Color(0xFF0B023D),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),

                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Column(
                            children: [

                              const Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.white,
                              ),

                              const SizedBox(height: 10),

                              Text(
                                profile["name"] ?? "",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                profile["email"] ?? "",
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        /// ================= INFO CARDS =================
                        _card(Icons.person, "Name", profile["name"] ?? ""),
                        _card(Icons.email, "Email", profile["email"] ?? ""),
                        _card(Icons.phone, "Phone", profile["phone"] ?? ""),

                        const SizedBox(height: 30),

                        /// ================= EDIT BUTTON =================
                        _button(
                          text: "Edit Profile",
                          color: Colors.purple,

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

                            if (result == true) {
                              _refresh();
                            }
                          },
                        ),

                        const SizedBox(height: 12),

                        /// ================= DELETE BUTTON =================
                        _button(
                          text: "Delete Account",
                          color: Colors.red,

                          onTap: () async {
                            final (success, message) =
                                await context
                                    .read<ProfileProvider>()
                                    .deleteAccount(
                                      token: widget.token,
                                    );

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message.toString())),
                            );

                            if (success) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  /// ================= CARD UI =================
  Widget _card(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12),
      ),

      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  /// ================= BUTTON UI =================
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

        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}