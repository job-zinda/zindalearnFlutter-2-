import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/providers/chat_provider.dart';
import 'package:zindaonlineschool/widgets/custom_snackbar.dart';

class ChatRoomScreen extends StatefulWidget {
  final String roomId;
  final String token;

  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.token,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController controller = TextEditingController();

  String? editingMessageId;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ChatProvider>().fetchMessages(
            widget.roomId,
            widget.token,
          );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// SEND OR UPDATE MESSAGE
  void handleSend() async {
    if (controller.text.trim().isEmpty) return;

    final chat = context.read<ChatProvider>();

    try {
      if (editingMessageId != null) {
        await chat.editMessage(
          editingMessageId!,
          controller.text,
          widget.token,
          widget.roomId,
        );

        CustomSnackbar.success(context, "Message updated");
        editingMessageId = null;
      } else {
        await chat.sendMessage(
          widget.roomId,
          controller.text,
          widget.token,
        );

        CustomSnackbar.success(context, "Message sent");
      }

      controller.clear();
      setState(() {});
    } catch (e) {
      CustomSnackbar.error(context, "Something went wrong");
    }
  }

  /// OPEN OPTIONS (EDIT / DELETE)
  void showOptions(Map msg) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F4B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.white),
              title: const Text("Edit", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);

                setState(() {
                  editingMessageId = msg["_id"];
                  controller.text = msg["text"] ?? "";
                });
              },
            ),

            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Delete", style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);

                await context.read<ChatProvider>().deleteMessage(
                      msg["_id"],
                      widget.roomId,
                      widget.token,
                    );

                CustomSnackbar.success(context, "Message deleted");
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF0B023D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B023D),
        title: const Text("Chat"),
      ),

      body: Column(
        children: [

          /// MESSAGES LIST
          Expanded(
            child: ListView.builder(
              itemCount: provider.messages.length,
              itemBuilder: (context, index) {
                final msg = provider.messages[index];

                final isMe = msg["sender"] == "student";

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,

                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    padding: const EdgeInsets.all(12),

                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),

                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.blueAccent
                          : Colors.white10,
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// MESSAGE TEXT
                        Text(
                          msg["text"] ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 5),

                        /// ACTION ROW (EDIT + DELETE BUTTONS)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            /// ✏️ EDIT BUTTON
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  editingMessageId = msg["_id"];
                                  controller.text = msg["text"] ?? "";
                                });
                              },
                            ),

                            /// 🗑 DELETE BUTTON
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 18,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                await context
                                    .read<ChatProvider>()
                                    .deleteMessage(
                                      msg["_id"],
                                      widget.roomId,
                                      widget.token,
                                    );

                                CustomSnackbar.success(
                                    context, "Deleted");
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// INPUT BOX (SEND / UPDATE)
          Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              top: 5,
            ),

            child: Row(
              children: [

                /// TEXT FIELD
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: editingMessageId != null
                          ? "Edit message..."
                          : "Type message...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                /// SEND / UPDATE BUTTON
                IconButton(
                  icon: Icon(
                    editingMessageId != null
                        ? Icons.check_circle
                        : Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: handleSend,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}