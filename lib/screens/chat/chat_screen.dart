import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/providers/chat_provider.dart';
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

    Future.microtask(() {
      context.read<ChatProvider>().fetchRooms(widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),
      appBar: AppBar(title: const Text("Chats")),

      body: provider.rooms.isEmpty
          ? const Center(child: Text("No Chats", style: TextStyle(color: Colors.white)))
          : ListView.builder(
              itemCount: provider.rooms.length,
              itemBuilder: (context, index) {
                final room = provider.rooms[index];

                return ListTile(
                  title: Text(
                    room["lastMessage"] ?? "No message",
                    style: const TextStyle(color: Colors.white),
                  ),

                  subtitle: Text(
                    room["_id"],
                    style: const TextStyle(color: Colors.white54),
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatRoomScreen(
                          roomId: room["_id"],
                          token: widget.token,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}