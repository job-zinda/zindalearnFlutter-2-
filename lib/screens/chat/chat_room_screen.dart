import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/core/utils/responsive.dart';
import 'package:zindaonlineschool/providers/chat_provider.dart';
import 'package:zindaonlineschool/widgets/responsive_body.dart';
import 'package:zindaonlineschool/widgets/custom_snackbar.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class ChatRoomScreen extends StatefulWidget {
  final String roomId;
  final String token;
  final Map<String, dynamic>? tutor;

  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.token,
    this.tutor,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  String? editingMessageId;
  bool showEmoji = false;

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  final AudioRecorder audioRecord = AudioRecorder();
  bool isRecording = false;

  String? audioPath;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final chat = context.read<ChatProvider>();

      await chat.fetchMessages(widget.roomId, widget.token);
      await chat.markAsRead(widget.roomId, widget.token);

      if (mounted) scrollBottom();
    });
  }

  void scrollBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> handleSend() async {
    if (controller.text.trim().isEmpty) return;

    final chat = context.read<ChatProvider>();
    final text = controller.text.trim();
    controller.clear();

    try {
      if (editingMessageId != null) {
        await chat.editMessage(
          editingMessageId!,
          text,
          widget.token,
          widget.roomId,
        );
        editingMessageId = null;
      } else {
        await chat.sendMessage(widget.roomId, text, widget.token);
      }

      scrollBottom();
    } catch (e) {
      debugPrint("Send error: $e");
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() => selectedImage = File(image.path));
      await sendImageMessage();
    }
  }

  Future<void> sendImageMessage() async {
    if (selectedImage == null) return;

    final chat = context.read<ChatProvider>();

    await chat.sendImageMessage(widget.roomId, selectedImage!, widget.token);

    setState(() => selectedImage = null);
    scrollBottom();
  }

  Future<void> startRecording() async {
    final hasPermission = await audioRecord.hasPermission();

    if (hasPermission) {
      final dir = await getTemporaryDirectory();

      audioPath =
          "${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a";

      await audioRecord.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: audioPath!,
      );

      setState(() => isRecording = true);
    }
  }

  Future<void> stopRecording() async {
    final path = await audioRecord.stop();

    setState(() => isRecording = false);

    if (path != null) {
      final chat = context.read<ChatProvider>();

      await chat.sendVoiceMessage(widget.roomId, File(path), widget.token);

      scrollBottom();
    }
  }

  @override
  void dispose() {
    audioRecord.dispose();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  /// FORMAT DATE
  String formatDate(String? date) {
    if (date == null) return "";
    try {
      final dt = DateTime.parse(date);
      return "${dt.day}/${dt.month}/${dt.year}  ${dt.hour}:${dt.minute}";
    } catch (e) {
      return "";
    }
  }

  // ================= NORMAL MESSAGE =================
  Widget buildNormalMessage(Map msg) {
    final isMe = msg["senderId"] is Map && msg["senderId"]["role"] == "student";

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

        padding: const EdgeInsets.all(14),

        constraints: BoxConstraints(
          maxWidth: Responsive.contentWidth(context) * 0.78,
        ),

        decoration: BoxDecoration(
          color: isMe
              ? const Color.fromARGB(255, 78, 35, 131)
              : Colors.white.withOpacity(0.06),

          borderRadius: BorderRadius.circular(18),

          border: Border.all(color: Colors.white12),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (msg["text"] ?? msg["message"] ?? "").toString(),
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 6),

            /// TIME + DATE
            Text(
              formatDate(msg["createdAt"]),
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),

            const SizedBox(height: 5),

            /// STATUS
            if (isMe)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  msg["isRead"] == true ? "Seen ✓✓" : "Sent ✓",
                  style: TextStyle(
                    color: msg["isRead"] == true
                        ? Colors.greenAccent
                        : Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ),

            /// EDIT DELETE BUTTONS (NOW FIXED VISIBILITY)
            if (isMe)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white70,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        editingMessageId = msg["_id"];
                        controller.text = (msg["text"] ?? msg["message"] ?? "")
                            .toString();
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                    onPressed: () async {
                      await context.read<ChatProvider>().deleteMessage(
                        msg["_id"],
                        widget.roomId,
                        widget.token,
                      );

                      CustomSnackbar.success(context, "Deleted");
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // ================= TUTOR CARD (PREMIUM UI FIXED) =================
  Widget buildTutorRequestCard(Map msg) {
    final card = msg["connectCard"] ?? {};

    final isMe = msg["senderId"] is Map && msg["senderId"]["role"] == "student";

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: card["image"] != null
                      ? NetworkImage(card["image"])
                      : null,
                  backgroundColor: Colors.white10,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card["name"] ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        card["qualification"] ?? "",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// MESSAGE
            Text(
              msg["text"] ?? "",
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 6),

            /// TIME FIXED HERE TOO
            Text(
              formatDate(msg["createdAt"]),
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),

            if (isMe)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white70,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        editingMessageId = msg["_id"];
                        controller.text = (msg["text"] ?? "").toString();
                      });
                    },
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                    onPressed: () async {
                      await context.read<ChatProvider>().deleteMessage(
                        msg["_id"],
                        widget.roomId,
                        widget.token,
                      );

                      CustomSnackbar.success(context, "Deleted");
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // ================= MAIN UI (SETTINGS STYLE INPUT) =================
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B023D),
        elevation: 0,
        centerTitle: true,
        title: const Text("Chat"),
      ),

      body: ResponsiveBody(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: Responsive.screenPadding(context),
                controller: scrollController,
                itemCount: provider.messages.length,
                itemBuilder: (context, index) {
                  final msg = provider.messages[index];

                  if (msg["messageType"] == "connect_card") {
                    return buildTutorRequestCard(msg);
                  }

                  return buildNormalMessage(msg);
                },
              ),
            ),

            /// INPUT (GLASS SETTINGS STYLE)
            Container(
              margin: const EdgeInsets.all(10),

              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white12),
              ),

              child: Column(
                children: [
                  Row(
                    children: [
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

                      IconButton(
                        icon: const Icon(Icons.image, color: Colors.white),
                        onPressed: pickImage,
                      ),

                      IconButton(
                        icon: Icon(
                          isRecording ? Icons.stop : Icons.mic,
                          color: isRecording ? Colors.red : Colors.white,
                        ),
                        onPressed: () {
                          isRecording ? stopRecording() : startRecording();
                        },
                      ),

                      IconButton(
                        icon: Icon(
                          editingMessageId != null
                              ? Icons.check_circle
                              : Icons.send,
                          color: Colors.purpleAccent,
                        ),
                        onPressed: handleSend,
                      ),
                    ],
                  ),

                  if (showEmoji)
                    SizedBox(
                      height: 250,
                      child: EmojiPicker(
                        onEmojiSelected: (c, e) {
                          controller.text += e.emoji;
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
