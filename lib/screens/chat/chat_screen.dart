// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:zindaonlineschool/core/constants/app_colors.dart';
// import 'package:zindaonlineschool/providers/chat_provider.dart';
// import 'package:zindaonlineschool/screens/tutor/tutor_screen.dart';
// import 'package:zindaonlineschool/widgets/responsive_body.dart';
// import 'chat_room_screen.dart';

// class ChatScreen extends StatefulWidget {
//   final String token;

//   const ChatScreen({
//     super.key,
//     required this.token,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {

//   @override
//   void initState() {
//     super.initState();

//     Future.microtask(() {
//       // ignore: use_build_context_synchronously
//       context.read<ChatProvider>().fetchRooms(widget.token);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<ChatProvider>();

//     return Scaffold(
//       backgroundColor: const Color(0xFF0B023D),
//       appBar: AppBar(title: const Text("Chats")),

//       // body: provider.rooms.isEmpty
//       //     ? const Center(child: Text("No Chats", style: TextStyle(color: Colors.white)))
//     body: provider.rooms.isEmpty
//     ? Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Add a nice icon to make it look professional
//               const Icon(Icons.chat_bubble_outline_rounded, size: 80, color: Colors.white24),
//               const SizedBox(height: 24),
//               const Text(
//                 "No Chats Yet",
//                 style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 "Connect with a tutor to start your learning journey.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.white54, fontSize: 16),
//               ),
//               const SizedBox(height: 32),
//               // Attractive Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:AppColors.primary,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context, 
//                       MaterialPageRoute(builder: (context) => TutorsScreen(courseId: "", token: widget.token, courseTitle: 'All Tutors')),
//                     );
//                   },
//                   child: const Text("Find a Tutor", style: TextStyle(fontSize: 18, color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       )
//           : ResponsiveBody(
//               padding: EdgeInsets.zero,
//               child: ListView.builder(
//               itemCount: provider.rooms.length,
//               itemBuilder: (context, index) {
//                 final room = provider.rooms[index];

//                 return ListTile(
//                   title: Text(
//                     room["lastMessage"] ?? "No message",
//                     style: const TextStyle(color: Colors.white),
//                   ),

//                   subtitle: Text(
//                     room["_id"],
//                     style: const TextStyle(color: Colors.white54),
//                   ),

//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => ChatRoomScreen(
//                           roomId: room["_id"],
//                           token: widget.token,
//   tutor: room["tutor"],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//             ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:zindaonlineschool/core/constants/app_colors.dart';
// import 'package:zindaonlineschool/providers/chat_provider.dart';
// import 'package:zindaonlineschool/screens/tutor/tutor_screen.dart';
// import 'package:zindaonlineschool/widgets/responsive_body.dart';
// import 'chat_room_screen.dart';

// class ChatScreen extends StatefulWidget {
//   final String token;

//   const ChatScreen({
//     super.key,
//     required this.token,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   @override
//   void initState() {
//     super.initState();

//     Future.microtask(() {
//       // ignore: use_build_context_synchronously
//       context.read<ChatProvider>().fetchRooms(widget.token);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<ChatProvider>();

//     return Scaffold(
//       backgroundColor: const Color(0xFF0B023D),
//       appBar: AppBar(title: const Text("Chats")),
//       body: provider.rooms.isEmpty
//           ? Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.chat_bubble_outline_rounded,
//                         size: 80, color: Colors.white24),
//                     const SizedBox(height: 24),
//                     const Text(
//                       "No Chats Yet",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 12),
//                     const Text(
//                       "Connect with a tutor to start your learning journey.",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.white54, fontSize: 16),
//                     ),
//                     const SizedBox(height: 32),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                         ),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => TutorsScreen(
//                                     courseId: "",
//                                     token: widget.token,
//                                     courseTitle: 'All Tutors')),
//                           );
//                         },
//                         child: const Text("Find a Tutor",
//                             style: TextStyle(fontSize: 18, color: Colors.white)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           : ResponsiveBody(
//               padding: EdgeInsets.zero,
//               child: ListView.builder(
//                 itemCount: provider.rooms.length,
//                 itemBuilder: (context, index) {
//                   final room = provider.rooms[index];

//                   // Updated UI for professional look
//                   return Card(
//                     color: const Color(0xFF160B4D),
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     child: ListTile(
//                       leading: const CircleAvatar(
//                         backgroundColor: Colors.blueAccent,
//                         child: Icon(Icons.person, color: Colors.white),
//                       ),
//                       title: const Text(
//                         "New Connect Request",
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text(
//                         room["lastMessage"] ?? "Waiting for reply...",
//                         style: const TextStyle(color: Colors.white70),
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => ChatRoomScreen(
//                               roomId: room["_id"],
//                               token: widget.token,
//                               tutor: room["tutor"],
//                                currentUserId: '', currentUser: null,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:zindaonlineschool/core/constants/app_colors.dart';
// import 'package:zindaonlineschool/providers/auth_provider.dart';
// import 'package:zindaonlineschool/providers/chat_provider.dart';
// import 'package:zindaonlineschool/screens/tutor/tutor_screen.dart';
// import 'package:zindaonlineschool/widgets/responsive_body.dart';
// import 'chat_room_screen.dart';

// class ChatScreen extends StatefulWidget {
//   final String token;

//   const ChatScreen({
//     super.key,
//     required this.token,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   @override
//   void initState() {
//     super.initState();

//     Future.microtask(() async {
//       if (!mounted) return;
//       // Same pattern used in TutorDetailsScreen — AuthProvider is the single
//       // source of truth for the logged-in user's id across the app.
//       await context.read<AuthProvider>().loadUser();
//       if (!mounted) return;
//       // context.read<ChatProvider>().fetchRooms(widget.token);
//     });
//   }

//   Future<void> _refresh() async {
//     await context.read<ChatProvider>().fetchRooms(widget.token);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<ChatProvider>();
//     final currentUserId =
//         context.watch<AuthProvider>().userId?.toString() ?? '';

//     // If your ChatProvider exposes a loading flag (e.g. `isLoading`), use it
//     // here so a fresh/empty list isn't mistaken for "no chats yet" while the
//     // first fetch is still in flight. Adjust the property name to match.
//     final bool isLoading = provider.rooms.isEmpty && _isProviderLoading(provider);

//     return Scaffold(
//       backgroundColor: const Color(0xFF0B023D),
//      appBar: AppBar(title: const Text("Chats")),
// //       appBar: AppBar(
// //   title: const Text("Chats"),
// //   actions: [
// //     IconButton(
// //       icon: const Icon(Icons.school_outlined),
// //       tooltip: "My Tutors",
// //       onPressed: () {
// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //             builder: (_) => AssignedTutorsScreen(token: widget.token),
// //           ),
// //         );
// //       },
// //     ),
// //   ],
// // ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : provider.rooms.isEmpty
//               ? _buildEmptyState(context)
//               : RefreshIndicator(
//                   onRefresh: _refresh,
//                   child: ResponsiveBody(
//                     padding: EdgeInsets.zero,
//                     child: ListView.builder(
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       itemCount: provider.rooms.length,
//                       itemBuilder: (context, index) {
//                         final room = provider.rooms[index];
//                         final Map tutor = (room["tutor"] is Map)
//                             ? room["tutor"] as Map
//                             : {};
//                         final String tutorName =
//                             (tutor["name"] ?? "").toString().trim();
//                         final String tutorImage =
//                             (tutor["image"] ?? "").toString().trim();
//                         final String lastMessage =
//                             (room["lastMessage"] ?? "Waiting for reply...")
//                                 .toString();
//                         final bool hasUnread = room["unreadCount"] != null &&
//                             (int.tryParse(room["unreadCount"].toString()) ??
//                                     0) >
//                                 0;
//                         // ASSUMPTION: backend marks assignment via
//                         // room["status"] == "assigned" or by populating
//                         // room["assignedTutor"]. Adjust to match your API.
//                         final bool isAssigned = room["status"] == "assigned" ||
//                             room["assignedTutor"] != null;

//                         return Card(
//                           color: const Color(0xFF160B4D),
//                           margin: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 5),
//                           child: ListTile(
//                             leading: CircleAvatar(
//                               backgroundColor: Colors.blueAccent,
//                               backgroundImage: tutorImage.startsWith('http')
//                                   ? NetworkImage(tutorImage)
//                                   : null,
//                               child: tutorImage.startsWith('http')
//                                   ? null
//                                   : const Icon(Icons.person,
//                                       color: Colors.white),
//                             ),
//                             title: Text(
//                               tutorName.isNotEmpty
//                                   ? tutorName
//                                   : "New Connect Request",
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             subtitle: Row(
//                               children: [
//                                 Container(
//                                   width: 6,
//                                   height: 6,
//                                   margin: const EdgeInsets.only(right: 6),
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: isAssigned
//                                         ? Colors.greenAccent
//                                         : Colors.orangeAccent,
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Text(
//                                     lastMessage,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style:
//                                         const TextStyle(color: Colors.white70),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             trailing: hasUnread
//                                 ? Container(
//                                     padding: const EdgeInsets.all(6),
//                                     decoration: const BoxDecoration(
//                                       color: AppColors.primary,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Text(
//                                       room["unreadCount"].toString(),
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 11,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   )
//                                 : null,
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => ChatRoomScreen(
//                                     roomId: room["_id"],
//                                     token: widget.token,
//                                     tutor: tutor.isNotEmpty
//                                         ? Map<String, dynamic>.from(tutor)
//                                         : null,
//                                     currentUserId: currentUserId,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//     );
//   }

//   /// Placeholder hook for a provider-level loading flag. Replace the body
//   /// with `provider.isLoading` (or whatever your ChatProvider actually
//   /// exposes) once available, so first-load never gets mistaken for empty.
//   bool _isProviderLoading(ChatProvider provider) {
//     return false;
//   }

//   Widget _buildEmptyState(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.chat_bubble_outline_rounded,
//                 size: 80, color: Colors.white24),
//             const SizedBox(height: 24),
//             const Text(
//               "No Chats Yet",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               "Connect with a tutor to start your learning journey.",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.white54, fontSize: 16),
//             ),
//             const SizedBox(height: 32),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => TutorsScreen(
//                             courseId: "",
//                             token: widget.token,
//                             courseTitle: 'All Tutors')),
//                   );
//                 },
//                 child: const Text("Find a Tutor",
//                     style: TextStyle(fontSize: 18, color: Colors.white)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/core/constants/app_colors.dart';
import 'package:zindaonlineschool/providers/auth_provider.dart';
import 'package:zindaonlineschool/providers/chat_provider.dart';
import 'package:zindaonlineschool/screens/tutor/tutor_screen.dart';
import 'package:zindaonlineschool/widgets/responsive_body.dart';
import 'chat_room_screen.dart';

class ChatScreen extends StatefulWidget {
  final String token;

  const ChatScreen({
    super.key,
    required this.token,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (!mounted) return;
      await context.read<AuthProvider>().loadUser();
      if (!mounted) return;
      await context.read<ChatProvider>().fetchRooms(widget.token);
    });
  }

  Future<void> _refresh() async {
    await context.read<ChatProvider>().fetchRooms(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();
    final currentUserId =
        context.watch<AuthProvider>().userId?.toString() ?? '';

    final bool isLoading = provider.rooms.isEmpty && _isProviderLoading(provider);

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),
      appBar: AppBar(title: const Text("Chats")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.rooms.isEmpty
              ? _buildEmptyState(context)
              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ResponsiveBody(
                    padding: EdgeInsets.zero,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: provider.rooms.length,
                      itemBuilder: (context, index) {
                        final room = provider.rooms[index];
                        final Map tutor = (room["tutor"] is Map)
                            ? room["tutor"] as Map
                            : {};
                        final String tutorName =
                            (tutor["name"] ?? "").toString().trim();
                        final String tutorImage =
                            (tutor["image"] ?? "").toString().trim();
                        final String lastMessage =
                            (room["lastMessage"] ?? "Waiting for reply...")
                                .toString();
                        final bool hasUnread = room["unreadCount"] != null &&
                            (int.tryParse(room["unreadCount"].toString()) ??
                                    0) >
                                0;
                        final bool isAssigned = room["status"] == "assigned" ||
                            room["assignedTutor"] != null;

                        // -----------------------------------------------------
                        // 1. EXTRACT ROOM TYPE & DETERMINE DISPLAY TITLE HERE
                        // -----------------------------------------------------
                        final String roomType =
                            (room["roomType"] ?? "student_tutor").toString();

                        final String displayTitle = roomType == "student_admin"
                            ? "Support Team"
                            : (tutorName.isNotEmpty ? tutorName : "Tutor Chat");
                        // -----------------------------------------------------

                        return Card(
                          color: const Color(0xFF160B4D),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: roomType == "student_admin"
                                  ? Colors.purpleAccent
                                  : Colors.blueAccent,
                              backgroundImage: roomType != "student_admin" &&
                                      tutorImage.startsWith('http')
                                  ? NetworkImage(tutorImage)
                                  : null,
                              child: roomType == "student_admin"
                                  ? const Icon(Icons.support_agent,
                                      color: Colors.white)
                                  : (tutorImage.startsWith('http')
                                      ? null
                                      : const Icon(Icons.person,
                                          color: Colors.white)),
                            ),
                            title: Text(
                              displayTitle,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isAssigned
                                        ? Colors.greenAccent
                                        : Colors.orangeAccent,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    lastMessage,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                ),
                              ],
                            ),
                            trailing: hasUnread
                                ? Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      room["unreadCount"].toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : null,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatRoomScreen(
                                    roomId: room["_id"],
                                    token: widget.token,
                                    tutor: tutor.isNotEmpty
                                        ? Map<String, dynamic>.from(tutor)
                                        : null,
                                    currentUserId: currentUserId,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
    );
  }

  /// Hook for provider-level loading flag to avoid empty state flash on initial load
  bool _isProviderLoading(ChatProvider provider) {
    return provider.isLoading;
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chat_bubble_outline_rounded,
                size: 80, color: Colors.white24),
            const SizedBox(height: 24),
            const Text(
              "No Chats Yet",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Connect with a tutor to start your learning journey.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TutorsScreen(
                            courseId: "",
                            token: widget.token,
                            courseTitle: 'All Tutors')),
                  );
                },
                child: const Text("Find a Tutor",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}