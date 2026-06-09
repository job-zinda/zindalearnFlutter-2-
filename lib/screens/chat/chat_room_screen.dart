import 'dart:convert';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

import 'package:zindaonlineschool/core/constants/app_colors.dart';
import 'package:zindaonlineschool/core/constants/app_gaps.dart';
import 'package:zindaonlineschool/core/constants/app_space.dart';
import 'package:zindaonlineschool/core/constants/app_textstyle.dart';
import 'package:zindaonlineschool/core/utils/responsive.dart';
import 'package:zindaonlineschool/providers/chat_provider.dart';
import 'package:zindaonlineschool/screens/tutor/tutor_detailes_screen.dart';
import 'package:zindaonlineschool/widgets/responsive_body.dart';
import 'package:zindaonlineschool/widgets/custom_snackbar.dart';

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
      if (!mounted) return;
      final chat = context.read<ChatProvider>();
      await chat.fetchMessages(widget.roomId, widget.token);
      await chat.markAsRead(widget.roomId, widget.token);
      scrollBottom();
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
    
    setState(() => showEmoji = false);

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
    try {
      final hasPermission = await audioRecord.hasPermission();
      if (hasPermission) {
        final dir = await getTemporaryDirectory();
        audioPath = "${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a";

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
    } catch (e) {
      debugPrint("Error starting recording: $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await audioRecord.stop();
      setState(() => isRecording = false);

      if (path != null) {
        if (!mounted) return;
        final chat = context.read<ChatProvider>();
        await chat.sendVoiceMessage(widget.roomId, File(path), widget.token);
        scrollBottom();
      }
    } catch (e) {
      debugPrint("Error stopping recording: $e");
    }
  }

  @override
  void dispose() {
    audioRecord.dispose();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  String formatDate(String? date) {
    if (date == null) return "";
    try {
      final dt = DateTime.parse(date).toLocal();
      return DateFormat('dd/MM/yyyy hh:mm a').format(dt);
    } catch (_) {
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
          color: isMe ? AppColors.cardFill : AppColors.white.withAlpha(15),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.white.withAlpha(30)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withAlpha(51),
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
              style: AppTextStyles.body.copyWith(color: AppColors.white),
            ),
            AppSpacing.h5,
            Text(
              formatDate(msg["createdAt"]),
              style: AppTextStyles.small.copyWith(color: AppColors.white.withAlpha(138)),
            ),
            if (isMe) ...[
              AppSpacing.h5,
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  msg["isRead"] == true ? "Seen ✓✓" : "Sent ✓",
                  style: AppTextStyles.small.copyWith(
                    color: msg["isRead"] == true ? AppColors.secondary : AppColors.white.withAlpha(138),
                    fontSize: 11,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: AppColors.white.withAlpha(179),
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        editingMessageId = msg["_id"];
                        controller.text = (msg["text"] ?? msg["message"] ?? "").toString();
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
                      if (!mounted) return;
                      CustomSnackbar.success(context, "Deleted");
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ================= TUTOR CARD =================
  Widget buildTutorRequestCard(Map msg) {
    final card = msg["connectCard"] ?? {};
    final isMe = msg["senderId"] is Map && msg["senderId"]["role"] == "student";

    final String imageString = (card["image"] ?? "").toString().trim();
    final bool isBase64 = imageString.startsWith("data:image");

    dynamic imageBytes;
    if (isBase64 && imageString.isNotEmpty) {
      try {
        final String pureBase64Str = imageString.split(',').last;
        imageBytes = base64Decode(pureBase64Str);
      } catch (e) {
        imageBytes = null;
      }
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: Responsive.contentWidth(context) * 0.82,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.cardFill : AppColors.white.withAlpha(15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.white.withAlpha(30)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withAlpha(51),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.black.withAlpha(30),
                borderRadius: BorderRadius.circular(AppGaps.radius),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.white.withAlpha(26),
                    backgroundImage: (imageString.isEmpty)
                        ? null
                        : (isBase64
                            ? (imageBytes != null ? MemoryImage(imageBytes) : null)
                            : (imageString.startsWith('http') ? NetworkImage(imageString) : null)),
                    child: (imageString.isEmpty ||
                            (isBase64 && imageBytes == null) ||
                            (!isBase64 && !imageString.startsWith('http')))
                        ? Icon(Icons.person, color: AppColors.white.withAlpha(138))
                        : null,
                  ),
                  AppSpacing.w10,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card["name"] ?? "",
                          style: AppTextStyles.subHeading.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          card["qualification"] ?? "",
                          style: AppTextStyles.body.copyWith(color: AppColors.white.withAlpha(179)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.h10,
            Text(
              msg["text"] ?? "",
              style: AppTextStyles.body.copyWith(color: AppColors.white, fontSize: 14,          // Matches the reduced normal message size
    height: 1.3,),
            ),
            AppSpacing.h5,
            Text(
              formatDate(msg["createdAt"]),
              style: AppTextStyles.small.copyWith(color: AppColors.white.withAlpha(138)),
            ),
            AppSpacing.h10,
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  final tutorId = card["tuterId"]?.toString();
                  if (tutorId == null) {
                    CustomSnackbar.error(context, "Tutor ID not found");
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TutorDetailsScreen(
                        tutorId: tutorId,
                        token: widget.token,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Tap to View Tutor Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (isMe) ...[
              AppSpacing.h5,
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  msg["isRead"] == true ? "Seen ✓✓" : "Sent ✓",
                  style: AppTextStyles.small.copyWith(
                    color: msg["isRead"] == true ? AppColors.secondary : AppColors.white.withAlpha(138),
                    fontSize: 11,
                  ),
                ),
              ),
              AppSpacing.h5,
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: AppColors.white.withAlpha(179),
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
                      if (!mounted) return;
                      CustomSnackbar.success(context, "Deleted");
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ================= MAIN UI =================
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();

    return PopScope(
      canPop: !showEmoji,
      onPopInvokedWithResult: (didPop, result) {
        if (showEmoji) {
          setState(() => showEmoji = false);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.appBarFill,
          elevation: 0,
          centerTitle: true,
          title: Text("Chat", style: AppTextStyles.subHeading),
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
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(15),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: AppColors.white.withAlpha(30)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            showEmoji ? Icons.keyboard : Icons.sentiment_satisfied_alt_outlined,
                            color: AppColors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              showEmoji = !showEmoji;
                              if (showEmoji) {
                                FocusScope.of(context).unfocus();
                              }
                            });
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller,
                            style: AppTextStyles.body.copyWith(color: AppColors.white),
                            onTap: () {
                              setState(() => showEmoji = false);
                            },
                            decoration: InputDecoration(
                              hintText: editingMessageId != null ? "Edit message..." : "Type message...",
                              hintStyle: AppTextStyles.body.copyWith(color: AppColors.white.withAlpha(138)),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.image, color: AppColors.white),
                          onPressed: pickImage,
                        ),
                        IconButton(
                          icon: Icon(
                            isRecording ? Icons.stop : Icons.mic,
                            color: isRecording ? Colors.red : AppColors.white,
                          ),
                          onPressed: () {
                            isRecording ? stopRecording() : startRecording();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            editingMessageId != null ? Icons.check_circle : Icons.send,
                            color: AppColors.primary,
                          ),
                          onPressed: handleSend,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (showEmoji)
                SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      controller.text += emoji.emoji;
                    },
                    config: const Config(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}