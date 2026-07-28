
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

  const ChatScreen({super.key, required this.token});

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

  /// Pulls tutor info off a room regardless of whether the backend
  /// populated it under "tutor" or "tutorId" (ChatRoomSchema uses tutorId).
  Map _extractTutor(Map room) {
    final raw = room["tutor"] ?? room["tutorId"];
    if (raw is Map) return raw;
    return {};
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();
    final currentUserId =
        context.watch<AuthProvider>().userId?.toString() ?? '';

    final bool isLoading =
        provider.rooms.isEmpty && _isProviderLoading(provider);

    // Split rooms into admin room(s) and tutor rooms.
    final List adminRooms = provider.rooms
        .where((r) => (r["roomType"] ?? "") == "student_admin")
        .toList();
    final List tutorRooms = provider.rooms
        .where((r) => (r["roomType"] ?? "") == "student_tutor")
        .toList();

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
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    if (adminRooms.isNotEmpty) ...[
                      ...adminRooms.map(
                        (room) => _buildRoomTile(
                          context,
                          room,
                          currentUserId,
                          isAdminRoom: true,
                        ),
                      ),
                    ],
                    if (tutorRooms.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
                        child: Text(
                          "Tutor Chat",
                          style: TextStyle(
                            color: Colors.white.withAlpha(180),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      ...tutorRooms.map(
                        (room) => _buildRoomTile(
                          context,
                          room,
                          currentUserId,
                          isAdminRoom: false,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildRoomTile(
    BuildContext context,
    dynamic room,
    String currentUserId, {
    required bool isAdminRoom,
  }) {
    final Map tutor = _extractTutor(room);
    final String tutorName = (tutor["name"] ?? "").toString().trim();
    final String tutorImage = (tutor["photo"] ?? tutor["image"] ?? "")
        .toString()
        .trim();
    final String lastMessage =
        (room["lastMessage"] ?? "Waiting for reply...").toString();
    final bool hasUnread =
        room["unreadCount"] != null &&
        (int.tryParse(room["unreadCount"].toString()) ?? 0) > 0;
    // final bool isAssigned =
    //     room["status"] == "assigned" || room["assignedTutor"] != null;

    final String displayTitle = isAdminRoom
        ? "Support Team"
        : (tutorName.isNotEmpty ? tutorName : "Tutor Chat");

    return Card(
      color: const Color(0xFF160B4D),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isAdminRoom
              ? Colors.purpleAccent
              : Colors.blueAccent,
          backgroundImage: !isAdminRoom && tutorImage.startsWith('http')
              ? NetworkImage(tutorImage)
              : null,
          child: isAdminRoom
              ? const Icon(Icons.support_agent, color: Colors.white)
              : (tutorImage.startsWith('http')
                    ? null
                    : const Icon(Icons.person, color: Colors.white)),
        ),
        title: Text(
          displayTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // subtitle: Row(
        //   children: [
        //     Container(
        //       width: 6,
        //       height: 6,
        //       margin: const EdgeInsets.only(right: 6),
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         // color: isAssigned ? Colors.greenAccent : Colors.orangeAccent,
        //       ),
        //     ),
        //     Expanded(
        //       child: Text(
        //         lastMessage,
        //         maxLines: 1,
        //         overflow: TextOverflow.ellipsis,
        //         style: const TextStyle(color: Colors.white70),
        //       ),
        //     ),
        //   ],
        // ),
        subtitle: Text(
  lastMessage,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(color: Colors.white70),
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
  }

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
            const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 80,
              color: Colors.white24,
            ),
            const SizedBox(height: 24),
            const Text(
              "No Chats Yet",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TutorsScreen(
                        courseId: "",
                        token: widget.token,
                        courseTitle: 'All Tutors',
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Find a Tutor",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}