import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart'; // Required for kIsWeb
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

class _ChatRoomScreenState extends State<ChatRoomScreen>
    with WidgetsBindingObserver {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode messageFocusNode = FocusNode();

  String? editingMessageId;
  bool showEmoji = false;

  List<File> selectedImages = [];
  final ImagePicker picker = ImagePicker();

  // Voice recording state variables
  final AudioRecorder audioRecord = AudioRecorder();
  bool isRecording = false;
  bool isPaused = false;
  String? audioPath;

  // Recording live feedback timer
  Timer? _recordingTimer;
  int _recordingSeconds = 0;

  final AudioPlayer audioPlayer = AudioPlayer();
  String? currentlyPlayingMessageId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() async {
      if (!mounted) return;
      final chat = context.read<ChatProvider>();
      await chat.fetchMessages(widget.roomId, widget.token);
      await chat.markAsRead(widget.roomId, widget.token);
      scrollBottom();
    });

    audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          currentlyPlayingMessageId = null;
        });
      }
    });
  }

  void scrollBottom() {
    Future.delayed(const Duration(milliseconds: 30), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _safelyStopRecordingOnBackground();
    }
  }

  Future<void> _safelyStopRecordingOnBackground() async {
    try {
      if (await audioRecord.isRecording()) {
        await audioRecord.stop();
        _stopTimer();
        setState(() {
          isRecording = false;
          isPaused = false;
        });
      }
    } catch (e) {
      debugPrint("Lifecycle audio termination log: $e");
    }
  }

  void _startTimer() {
    _recordingSeconds = 0;
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused) {
        setState(() {
          _recordingSeconds++;
        });
      }
    });
  }

  void _stopTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    _recordingSeconds = 0;
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> handleSend() async {
    final chat = context.read<ChatProvider>();

    // If the user presses Send directly while recording, stop recording and send immediately
    if (isRecording) {
      final path = await audioRecord.stop();
      _stopTimer();
      setState(() {
        isRecording = false;
        isPaused = false;
        audioPath = path;
      });
    }

    if (selectedImages.isNotEmpty) {
      final imagesToSend = List<File>.from(selectedImages);
      setState(() => selectedImages.clear());
      chat
          .sendImagesMessage(widget.roomId, imagesToSend, widget.token)
          .then((_) => scrollBottom());
      scrollBottom();
      return;
    }

    if (audioPath != null) {
      final fileToSend = File(audioPath!);
      setState(() => audioPath = null);
      chat
          .sendVoiceMessage(widget.roomId, fileToSend, widget.token)
          .then((_) => scrollBottom());
      scrollBottom();
      return;
    }

    final text = controller.text.trim();
    if (text.isEmpty) return;

    final String? currentEditId = editingMessageId;

    controller.clear();
    setState(() {
      showEmoji = false;
      editingMessageId = null;
    });

    try {
      if (currentEditId != null) {
        await chat.editMessage(
          currentEditId,
          text,
          widget.token,
          widget.roomId,
        );
        if (!mounted) return;
        CustomSnackbar.success(context, "Message updated successfully");
      } else {
        await chat.sendMessage(widget.roomId, text, widget.token);
      }
      scrollBottom();
    } catch (e) {
      debugPrint("Send/Edit execution error: $e");
    }
  }

  Future<void> pickImages() async {
    try {
      final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);
      if (images.isNotEmpty) {
        setState(() {
          selectedImages = images.map((img) => File(img.path)).toList();
        });
      }
    } catch (e) {
      debugPrint("Error picking multi-images: $e");
    }
  }

  Future<void> startRecording() async {
    try {
      if (kIsWeb) {
        CustomSnackbar.error(
          context,
          "Voice recording is handled natively on mobile devices",
        );
        return;
      }

      final hasPermission = await audioRecord.hasPermission();
      if (hasPermission) {
        final dir = await getTemporaryDirectory();
        audioPath =
            "${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a";

        if (await audioRecord.isRecording()) {
          await audioRecord.stop();
        }

        await audioRecord.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 64000,
            sampleRate: 44100,
          ),
          path: audioPath!,
        );

        setState(() {
          isRecording = true;
          isPaused = false;
        });
        _startTimer();
      } else {
        CustomSnackbar.error(context, "Microphone permission denied");
      }
    } catch (e) {
      debugPrint("Error starting recording: $e");
    }
  }

  Future<void> pauseRecording() async {
    try {
      await audioRecord.pause();
      setState(() => isPaused = true);
    } catch (e) {
      debugPrint("Error pausing recording: $e");
    }
  }

  Future<void> resumeRecording() async {
    try {
      await audioRecord.resume();
      setState(() => isPaused = false);
    } catch (e) {
      debugPrint("Error resuming recording: $e");
    }
  }

  Future<void> cancelRecording() async {
    try {
      await audioRecord.stop();
      _stopTimer();
      setState(() {
        isRecording = false;
        isPaused = false;
        audioPath = null;
      });
    } catch (e) {
      debugPrint("Error canceling recording: $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _recordingTimer?.cancel();
    audioRecord.dispose();
    audioPlayer.dispose();
    controller.dispose();
    scrollController.dispose();
    messageFocusNode.dispose();
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

  // ================= DYNAMIC MESSAGE FILTER & RENDERER =================
  Widget buildNormalMessage(Map msg) {
    final isMe = msg["senderId"] is Map && msg["senderId"]["role"] == "student";
    final String textContent = (msg["text"] ?? msg["message"] ?? "")
        .toString()
        .trim();
    final String msgId = msg["_id"]?.toString() ?? UniqueKey().toString();

    final String msgType = (msg["messageType"] ?? msg["type"] ?? "text")
        .toString()
        .toLowerCase();
    final List attachments = msg["files"] ?? msg["attachments"] ?? [];

    List<String> cloudFileUrls = [];
    String backendMimeType = "";

    if (attachments.isNotEmpty) {
      for (var file in attachments) {
        if (file is Map) {
          String url = (file["url"] ?? file["path"] ?? "").toString();
          if (url.isNotEmpty) cloudFileUrls.add(url);
          backendMimeType = (file["mimeType"] ?? "").toString().toLowerCase();
        } else if (file != null) {
          cloudFileUrls.add(file.toString());
        }
      }
    } else if (textContent.startsWith("http://") ||
        textContent.startsWith("https://")) {
      cloudFileUrls.add(textContent);
    }

    final String firstUrlLower = cloudFileUrls.isNotEmpty
        ? cloudFileUrls.first.toLowerCase()
        : "";

    final bool isVoice =
        msgType == "voice" ||
        msgType == "audio" ||
        backendMimeType.contains("audio") ||
        firstUrlLower.contains(".m4a") ||
        firstUrlLower.contains(".mp3") ||
        firstUrlLower.contains(".aac") ||
        firstUrlLower.contains(".wav") ||
        (firstUrlLower.contains("cloudinary") &&
            firstUrlLower.contains("/video/upload/") &&
            firstUrlLower.endsWith(".mp4"));

    final bool isCloudImage =
        !isVoice &&
        (msgType == "image" ||
            msgType == "file_image" ||
            cloudFileUrls.isNotEmpty);
    final bool isPlayingThis = currentlyPlayingMessageId == msgId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: Responsive.contentWidth(context) * 0.78,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.cardFill : AppColors.white.withAlpha(15),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.white.withAlpha(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCloudImage && cloudFileUrls.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cloudFileUrls.map((url) {
                  return Container(
                    constraints: BoxConstraints(
                      maxWidth: cloudFileUrls.length == 1
                          ? (Responsive.contentWidth(context) * 0.7)
                          : (Responsive.contentWidth(context) * 0.32),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            opaque: false,
                            barrierDismissible: true,
                            pageBuilder: (context, _, __) =>
                                ImageZoomViewer(imageUrl: url),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox(
                              height: 100,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.broken_image,
                                color: Colors.white,
                                size: 40,
                              ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              AppSpacing.h5,
            ],
            if (isVoice && cloudFileUrls.isNotEmpty) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isPlayingThis
                          ? Icons.stop_circle
                          : Icons.play_circle_fill,
                      color: AppColors.primary,
                      size: 34,
                    ),
                    onPressed: () async {
                      if (isPlayingThis) {
                        await audioPlayer.stop();
                        setState(() => currentlyPlayingMessageId = null);
                      } else {
                        await audioPlayer.stop();
                        setState(() => currentlyPlayingMessageId = msgId);
                        try {
                          await audioPlayer.play(
                            UrlSource(cloudFileUrls.first),
                          );
                        } catch (e) {
                          debugPrint("Playback error: $e");
                          setState(() => currentlyPlayingMessageId = null);
                        }
                      }
                    },
                  ),
                  AppSpacing.w5,
                  Text(
                    isPlayingThis ? "Playing..." : "Voice Note",
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              AppSpacing.h5,
            ],

            if (!isCloudImage && !isVoice && textContent.isNotEmpty) ...[
              Text(
                textContent,
                style: AppTextStyles.body.copyWith(color: AppColors.white),
              ),
              AppSpacing.h5,
            ],

            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  formatDate(msg["createdAt"]),
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.white.withAlpha(138),
                    fontSize: 10,
                  ),
                ),
                if (isMe) ...[
                  AppSpacing.w5,
                  Text(
                    msg["isRead"] == true ? "✓✓" : "✓",
                    style: TextStyle(
                      color: msg["isRead"] == true
                          ? AppColors.secondary
                          : AppColors.white.withAlpha(138),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),

            if (isMe) ...[
              AppSpacing.h20,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isVoice && !isCloudImage)
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: AppColors.white.withAlpha(150),
                        size: 16,
                      ),
                      onPressed: () {
                        setState(() {
                          editingMessageId = msg["_id"];
                          controller.text = textContent;
                        });
                        messageFocusNode.requestFocus();
                      },
                    ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                      size: 16,
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

  // ================= TUTOR REQUEST CARD =================
  Widget buildTutorRequestCard(Map msg) {
    final card = msg["connectCard"] ?? {};
    final isMe = msg["senderId"] is Map && msg["senderId"]["role"] == "student";
    final String textContent = (msg["text"] ?? "").toString();

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
                              ? (imageBytes != null
                                    ? MemoryImage(imageBytes)
                                    : null)
                              : (imageString.startsWith('http')
                                    ? NetworkImage(imageString)
                                    : null)),
                    child:
                        (imageString.isEmpty ||
                            (isBase64 && imageBytes == null) ||
                            (!isBase64 && !imageString.startsWith('http')))
                        ? Icon(
                            Icons.person,
                            color: AppColors.white.withAlpha(138),
                          )
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
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.white.withAlpha(179),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.h10,
            Text(
              textContent,
              style: AppTextStyles.body.copyWith(
                color: AppColors.white,
                fontSize: 14,
                height: 1.3,
              ),
            ),
            AppSpacing.h5,

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatDate(msg["createdAt"]),
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.white.withAlpha(138),
                    fontSize: 10,
                  ),
                ),
                if (isMe) ...[
                  AppSpacing.w5,
                  Text(
                    msg["isRead"] == true ? "✓✓" : "✓",
                    style: TextStyle(
                      color: msg["isRead"] == true
                          ? AppColors.secondary
                          : AppColors.white.withAlpha(138),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
            AppSpacing.h10,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
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
                if (isMe)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: AppColors.white.withAlpha(150),
                          size: 16,
                        ),
                        onPressed: () {
                          setState(() {
                            editingMessageId = msg["_id"];
                            controller.text = textContent;
                          });
                          messageFocusNode.requestFocus();
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                          size: 16,
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
            ),
          ],
        ),
      ),
    );
  }

  // ================= VIEW DESIGNS =================
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

              // ================= IMAGE STAGED PREVIEW ABOVE CHAT BAR =================
              if (selectedImages.isNotEmpty || audioPath != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha(24),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.white.withAlpha(20)),
                  ),
                  child: Row(
                    children: [
                      if (selectedImages.isNotEmpty) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            selectedImages.first,
                            height: 45,
                            width: 45,
                            fit: BoxFit.cover,
                          ),
                        ),
                        AppSpacing.w15,
                        Expanded(
                          child: Text(
                            selectedImages.length > 1
                                ? "${selectedImages.length} Images Selected"
                                : "1 Image Selected",
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ] else if (audioPath != null) ...[
                        const Icon(
                          Icons.mic,
                          color: AppColors.secondary,
                          size: 26,
                        ),
                        AppSpacing.w15,
                        Expanded(
                          child: Text(
                            "Voice note ready to send",
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedImages.clear();
                            audioPath = null;
                          });
                        },
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.redAccent.withAlpha(40),
                          child: const Icon(
                            Icons.close,
                            color: Colors.redAccent,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // ================= STANDARD BOTTOM CHAT BAR / WHATSAPP RECORDING BAR =================
              Container(
                margin: const EdgeInsets.fromLTRB(10, 2, 10, 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(15),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: AppColors.white.withAlpha(30)),
                ),
                child: isRecording
                    ? Row(
                        children: [
                          // 1. Live Red Blinking Mic and Time Counter
                          const Icon(
                            Icons.fiber_manual_record,
                            color: Colors.red,
                            size: 18,
                          ),
                          AppSpacing.w10,
                          Text(
                            _formatDuration(_recordingSeconds),
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),

                          // 2. WhatsApp-style Pause/Resume recording icon toggle
                          IconButton(
                            icon: Icon(
                              isPaused ? Icons.play_arrow : Icons.pause,
                              color: AppColors.secondary,
                            ),
                            onPressed: () {
                              isPaused ? resumeRecording() : pauseRecording();
                            },
                          ),

                          // 3. Delete/Trash icon to abort completely
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                            onPressed: cancelRecording,
                          ),

                          // 4. Send button inside recording bar
                          IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: AppColors.primary,
                            ),
                            onPressed: handleSend,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              showEmoji
                                  ? Icons.keyboard
                                  : Icons.sentiment_satisfied_alt_outlined,
                              color: AppColors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                showEmoji = !showEmoji;
                                if (showEmoji) {
                                  FocusScope.of(context).unfocus();
                                } else {
                                  messageFocusNode.requestFocus();
                                }
                              });
                            },
                          ),
                          Expanded(
                            child: TextField(
                              controller: controller,
                              focusNode: messageFocusNode,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.white,
                              ),
                              onTap: () => setState(() => showEmoji = false),
                              decoration: InputDecoration(
                                hintText: editingMessageId != null
                                    ? "Edit message..."
                                    : "Type message...",
                                hintStyle: AppTextStyles.body.copyWith(
                                  color: AppColors.white.withAlpha(138),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.image,
                              color: AppColors.white,
                            ),
                            onPressed: pickImages,
                          ),
                          if (!kIsWeb)
                            IconButton(
                              icon: const Icon(
                                Icons.mic,
                                color: AppColors.white,
                              ),
                              onPressed: startRecording,
                            ),
                          IconButton(
                            icon: Icon(
                              editingMessageId != null
                                  ? Icons.check_circle
                                  : Icons.send,
                              color: AppColors.primary,
                            ),
                            onPressed: handleSend,
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
                    config: Config(
                      height: 256,
                      checkPlatformCompatibility: true,
                      emojiViewConfig: EmojiViewConfig(
                        backgroundColor: AppColors.background,
                        columns: 7,
                        emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
                      ),
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

// ================= FULL SCREEN IMAGE ZOOM VIEWER (EXTRACTED) =================
class ImageZoomViewer extends StatelessWidget {
  final String imageUrl;

  const ImageZoomViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withAlpha(230),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            },
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, color: Colors.white, size: 60),
          ),
        ),
      ),
    );
  }
}
