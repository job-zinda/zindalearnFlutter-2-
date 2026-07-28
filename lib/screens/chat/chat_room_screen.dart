import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
import 'package:share_plus/share_plus.dart';

class ChatRoomScreen extends StatefulWidget {
  final String roomId;
  final String token;

  final Map<String, dynamic>? tutor;

  final String currentUserId;

  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.token,
    required this.currentUserId,
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

  String? selectedMessageId;

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

  double _currentSpeed = 1.0;

  final Map<String, Duration> _loadedDurations = {};
  final Set<String> _fetchingDurations = {};

  void _toggleSpeed() {
    setState(() {
      if (_currentSpeed == 1.0) {
        _currentSpeed = 1.5;
      } else if (_currentSpeed == 1.5) {
        _currentSpeed = 2.0;
      } else {
        _currentSpeed = 1.0;
      }
    });

    audioPlayer.setPlaybackRate(_currentSpeed);
  }

  bool _isFirstLoad = true;

  void _fetchDurationSilently(String msgId, String url) {
    if (_loadedDurations.containsKey(msgId)) return;
    if (_fetchingDurations.contains(msgId)) return;

    _fetchingDurations.add(msgId);
    final player = AudioPlayer();

    player
        .setSourceUrl(url)
        .then((_) {
          return player.getDuration();
        })
        .then((d) {
          if (d != null && mounted) {
            setState(() {
              _loadedDurations[msgId] = d;
            });
          }
        })
        .catchError((e) {
          debugPrint("Silent duration fetch failed for $msgId: $e");
        })
        .whenComplete(() async {
          _fetchingDurations.remove(msgId);
          await player.stop(); // <--- Add this line before dispose
          await player.dispose();
        });
  }

  bool isMuted = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() async {
      if (!mounted) return;
      final chat = context.read<ChatProvider>();
      await chat.fetchMessages(widget.roomId, widget.token);
      if (!mounted) return;
      await chat.markAsRead(widget.roomId, widget.token);
      // scrollToBottom();
    });

    audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          currentlyPlayingMessageId = null;
        });
      }
    });

    // 1. Listen for total voice note length
    audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
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

Future<void> _downloadVoiceNote(String url) async {
  try {
    // Download to a temporary location first — this folder is always
    // writable without special permissions, but is not user-visible.
    final tempDir = await getTemporaryDirectory();
    final extension = url.contains('.m4a') ? 'm4a' : 'aac';
    final tempPath =
        "${tempDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.$extension";

    await Dio().download(url, tempPath);
    if (!mounted) return;

    // Hand the file to the native share sheet so the user can pick
    // exactly where it goes — Downloads, Files, Drive, WhatsApp, etc.
    // This is the standard, permission-free way to deliver a real,
    // user-visible file on modern Android/iOS.
    await Share.shareXFiles(
      [XFile(tempPath)],
      text: "Voice note",
    );
  } catch (e) {
    debugPrint("Voice note download error: $e");
    if (!mounted) return;
    CustomSnackbar.error(context, "Failed to download audio file");
  }
}
  Future<void> _safelyStopRecordingOnBackground() async {
    try {
      if (await audioRecord.isRecording()) {
        await audioRecord.stop();
        _stopTimer();
        if (!mounted) return;
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
      if (!isPaused && mounted) {
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

  bool _isMyMessage(Map msg) {
    if (msg["isTemp"] == true) return true;

    final sender = msg["senderId"];
    if (sender is Map) {
      final senderId = sender["_id"]?.toString();
      if (senderId != null) return senderId == widget.currentUserId;
      // Fallback for backends that only embed a role, not the sender doc's id.
      return sender["role"] == "student";
    }
    if (sender != null) {
      return sender.toString() == widget.currentUserId;
    }
    return false;
  }

  Future<void> handleSend() async {
    final chat = context.read<ChatProvider>();

    // If the user presses Send directly while recording, stop recording and send immediately
    if (isRecording) {
      final path = await audioRecord.stop();
      _stopTimer();
      if (!mounted) return;
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
          .then((_) => scrollToBottom());
      scrollToBottom();
      return;
    }

    if (audioPath != null) {
      final fileToSend = File(audioPath!);

      setState(() => audioPath = null);
      chat
          .sendVoiceMessage(widget.roomId, fileToSend, widget.token)
          .then((_) => scrollToBottom());
      scrollToBottom();
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
      scrollToBottom();
    } catch (e) {
      debugPrint("Send/Edit execution error: $e");
    }
  }

  Future<void> pickImages() async {
    try {
      final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);
      if (images.isNotEmpty && mounted) {
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
      if (!mounted) return;

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

        if (!mounted) return;
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
      if (!mounted) return;
      setState(() => isPaused = true);
    } catch (e) {
      debugPrint("Error pausing recording: $e");
    }
  }

  Future<void> resumeRecording() async {
    try {
      await audioRecord.resume();
      if (!mounted) return;
      setState(() => isPaused = false);
    } catch (e) {
      debugPrint("Error resuming recording: $e");
    }
  }

  Future<void> cancelRecording() async {
    try {
      await audioRecord.stop();
      _stopTimer();
      if (!mounted) return;
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

  Map<String, dynamic>? _latestConnectCard(List messages) {
    for (final msg in messages.reversed) {
      if (msg is Map && msg["messageType"] == "connect_card") {
        final card = msg["connectCard"];
        if (card is Map) return Map<String, dynamic>.from(card);
      }
    }
    return null;
  }

  bool _isCardAssigned(Map<String, dynamic>? card) {
    if (card == null) return false;
    if (card["assigned"] == true) return true;
    final phone = (card["phone"] ?? "").toString().trim();
    final email = (card["email"] ?? "").toString().trim();
    return phone.isNotEmpty || email.isNotEmpty;
  }

  // ================= DYNAMIC MESSAGE FILTER & RENDERER =================
  Widget buildNormalMessage(Map msg) {
    final bool isMe = _isMyMessage(msg);

    final String textContent = (msg["text"] ?? msg["message"] ?? "")
        .toString()
        .trim();
    final String msgId = msg["_id"]?.toString() ?? UniqueKey().toString();
    final String msgType = (msg["messageType"] ?? msg["type"] ?? "text")
        .toString()
        .toLowerCase();
    final List attachments = msg["files"] ?? msg["attachments"] ?? [];
    final bool isTemp = msg["isTemp"] == true;
    final bool isSelected = selectedMessageId == msgId;

    List<Map<String, dynamic>> structuredFiles = [];
    List<String> cloudFileUrls = [];
    String backendMimeType = "";
    String backendFileType = "";

    if (attachments.isNotEmpty) {
      for (var file in attachments) {
        if (file is Map) {
          structuredFiles.add(Map<String, dynamic>.from(file));
          String url = (file["path"] ?? file["url"] ?? "").toString();
          if (url.isNotEmpty) cloudFileUrls.add(url);
          backendMimeType = (file["mimeType"] ?? "").toString().toLowerCase();
          backendFileType = (file["fileType"] ?? "").toString().toLowerCase();
        } else if (file != null) {
          cloudFileUrls.add(file.toString());
          structuredFiles.add({"path": file.toString()});
        }
      }
    } else if (msg["fileUrl"] != null && msg["fileUrl"].toString().isNotEmpty) {
      cloudFileUrls.add(msg["fileUrl"].toString());
      structuredFiles.add({"path": msg["fileUrl"].toString()});
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
        firstUrlLower.contains(".wav");
    final bool isCloudImage =
        !isVoice &&
        (msgType == "image" ||
            msgType == "file_image" ||
            msgType == "file" ||
            backendFileType == "image" ||
            backendMimeType.contains("image") ||
            firstUrlLower.contains(".jpg") ||
            firstUrlLower.contains(".jpeg") ||
            firstUrlLower.contains(".png") ||
            firstUrlLower.contains(".webp"));
    final bool isPlayingThis = currentlyPlayingMessageId == msgId;

    final double singleImageWidth = (Responsive.contentWidth(context) * 0.68)
        .clamp(0.0, 380.0);
    final double multiImageWidth = (Responsive.contentWidth(context) * 0.3)
        .clamp(0.0, 170.0);

    return GestureDetector(
      onLongPress: () {
        if (isMe && !isTemp) setState(() => selectedMessageId = msgId);
      },
      onTap: () {
        if (selectedMessageId != null) setState(() => selectedMessageId = null);
      },
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: Responsive.contentWidth(context) * 0.75,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.secondary.withAlpha(50)
                : (isMe ? AppColors.cardFill : AppColors.white.withAlpha(15)),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 4),
              bottomRight: Radius.circular(isMe ? 4 : 16),
            ),
            border: Border.all(
              color: isSelected
                  ? AppColors.secondary
                  : AppColors.white.withAlpha(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // IMAGE SECTION WITH DELETE SUPPORT
              if (isCloudImage && structuredFiles.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: structuredFiles.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> fileMap = entry.value;
                    final String url = (fileMap["path"] ?? "").toString();
                    final String? origName = fileMap["originalName"]
                        ?.toString();
                    final int? fileSizeNum = fileMap["size"] != null
                        ? int.tryParse(fileMap["size"].toString())
                        : null;

                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque: false,
                                barrierDismissible: true,
                                pageBuilder: (context, _, _) =>
                                    ImageZoomViewer(imageUrl: url),
                              ),
                            );
                          },
                          child: Container(
                            width: structuredFiles.length == 1
                                ? singleImageWidth
                                : multiImageWidth,
                            height: 190,
                            decoration: BoxDecoration(
                              color: AppColors.white.withAlpha(10),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Builder(
                                builder: (context) {
                                  if (isMe) {
                                    final String? cached = context
                                        .read<ChatProvider>()
                                        .getLocalPath(origName, fileSizeNum);
                                    if (cached != null &&
                                        File(cached).existsSync()) {
                                      return Image.file(
                                        File(cached),
                                        fit: BoxFit.cover,
                                      );
                                    }
                                  }
                                  return Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                    errorBuilder: (context, error, stack) =>
                                        const Icon(
                                          Icons.broken_image,
                                          color: Colors.white54,
                                        ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                ],
                    );
                  }).toList(),
                ),
                AppSpacing.h5,
              ],
              if (isVoice && cloudFileUrls.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // PLAY BUTTON
                          IconButton(
                            icon: Icon(
                              isTemp
                                  ? Icons.cloud_upload_outlined
                                  : (isPlayingThis
                                        ? Icons.stop_circle
                                        : Icons.play_circle_fill),
                              color: isTemp
                                  ? AppColors.white.withAlpha(100)
                                  : AppColors.primary,
                              size: 34,
                            ),
                            onPressed: isTemp
                                ? null
                                : () async {
                                    if (isPlayingThis) {
                                      await audioPlayer.stop();
                                      if (!mounted) return;
                                      setState(
                                        () => currentlyPlayingMessageId = null,
                                      );
                                    } else {
                                      await audioPlayer.play(
                                        UrlSource(cloudFileUrls.first),
                                      );
                                      await audioPlayer.setPlaybackRate(
                                        _currentSpeed,
                                      );

                                      audioPlayer.getDuration().then((d) {
                                        if (d != null && mounted) {
                                          setState(() {
                                            _loadedDurations[msgId] = d;
                                          });
                                        }
                                      });
                                      if (!mounted) return;
                                      setState(
                                        () => currentlyPlayingMessageId = msgId,
                                      );
                                    }
                                  },
                          ),
                          // SPEAKER MUTE/UNMUTE ICON
                          IconButton(
                            icon: Icon(
                              isMuted ? Icons.volume_off : Icons.volume_up,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () async {
                              setState(() {
                                isMuted = !isMuted;
                              });
                              await audioPlayer.setVolume(isMuted ? 0.0 : 1.0);
                            },
                          ),

                          // PROGRESS BAR / WHATSAPP STYLE DURATION
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 4,
                                      ),
                                      trackHeight: 2,
                                    ),
                                    child: Slider(
                                      min: 0.0,
                                      max:
                                          isPlayingThis &&
                                              _duration.inMilliseconds > 0
                                          ? _duration.inMilliseconds.toDouble()
                                          : 1.0,
                                      value: isPlayingThis
                                          ? _position.inMilliseconds
                                                .toDouble()
                                                .clamp(
                                                  0.0,
                                                  _duration.inMilliseconds
                                                      .toDouble(),
                                                )
                                          : 0.0,
                                      activeColor: AppColors.primary,
                                      inactiveColor: Colors.white30,
                                      onChanged: (value) async {
                                        if (isPlayingThis) {
                                          await audioPlayer.seek(
                                            Duration(
                                              milliseconds: value.toInt(),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Builder(
                                    builder: (context) {
                                      String label;
                                      if (isPlayingThis) {
                                        label =
                                            "${_formatDuration(_position.inSeconds)} / ${_formatDuration(_duration.inSeconds)}";
                                      } else if (isTemp) {
                                        label = _formatDuration(
                                          _recordingSeconds,
                                        );
                                      } else if (_loadedDurations.containsKey(
                                        msgId,
                                      )) {
                                        label = _formatDuration(
                                          _loadedDurations[msgId]!.inSeconds,
                                        );
                                      } else {
                                        // Silent fetch triggered once, safely,
                                        // after this frame is done building.
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                              _fetchDurationSilently(
                                                msgId,
                                                cloudFileUrls.first,
                                              );
                                            });
                                        label = "00:00";
                                      }
                                      return Text(
                                        label,
                                        style: AppTextStyles.small.copyWith(
                                          color: Colors.white70,
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 3-DOT OPTIONS POPUP MENU
                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 20,
                            ),
                            color: Colors.grey[900],
                            onSelected: (value) {
                              if (value == 'speed') {
                                _toggleSpeed();
                              } else if (value == 'download') {
                                _downloadVoiceNote(cloudFileUrls.first);
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                value: 'speed',
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.speed,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Speed (${_currentSpeed}x)",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'download',
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.download,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Download",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AppSpacing.h5,
              ],
              // TEXT SECTION — now shown as a caption alongside image/voice too,
              // instead of being dropped when the message has an attachment.
              if (textContent.isNotEmpty) ...[
                Text(
                  textContent,
                  style: AppTextStyles.body.copyWith(color: AppColors.white),
                ),
                AppSpacing.h5,
              ],
              // TIMESTAMP
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isTemp) ...[
                    Icon(
                      Icons.access_time_rounded,
                      color: AppColors.white.withAlpha(120),
                      size: 11,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    formatDate(msg["createdAt"]),
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.white.withAlpha(138),
                      fontSize: 10,
                    ),
                  ),
                  if (isMe && !isTemp) ...[
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
              // MESSAGE ACTION ROW
              if (isSelected && isMe && !isTemp) ...[
                const Divider(color: Colors.white24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isVoice && !isCloudImage)
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            editingMessageId = msg["_id"];
                            controller.text = textContent;
                            selectedMessageId = null;
                          });
                          messageFocusNode.requestFocus();
                        },
                      ),
              
                    IconButton(
  icon: const Icon(
    Icons.delete,
    color: Colors.redAccent,
    size: 18,
  ),
  onPressed: () async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardFill,
        title: const Text(
          "Delete message?",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          isCloudImage && structuredFiles.length > 1
              ? "This will delete all ${structuredFiles.length} photos in this message."
              : "This message will be deleted for everyone.",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    if (!mounted) return;

    await context.read<ChatProvider>().deleteMessage(
      msg["_id"],
      widget.roomId,
      widget.token,
    );
    if (!mounted) return;
    setState(() => selectedMessageId = null);
    CustomSnackbar.success(context, "Deleted");
  },
),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ================= TUTOR REQUEST CARD =================
  Widget buildTutorRequestCard(Map msg) {
    final card = msg["connectCard"] ?? {};
    final bool isMe = _isMyMessage(msg);
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

    final String cardTutorId = (card["tuterId"] ?? card["tutorId"] ?? "")
        .toString();
    final bool isAssigned = cardTutorId.isNotEmpty
        ? context.read<ChatProvider>().isTutorAssigned(cardTutorId)
        : false;

    final String phone = (card["phone"] ?? "").toString().trim();
    final String email = (card["email"] ?? "").toString().trim();

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

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (isAssigned ? Colors.green : Colors.orange).withAlpha(
                  40,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isAssigned ? Colors.green : Colors.orange,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isAssigned ? Icons.check_circle : Icons.hourglass_top,
                    size: 14,
                    color: isAssigned
                        ? Colors.greenAccent
                        : Colors.orangeAccent,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isAssigned
                        ? "Tutor assigned — chat directly"
                        : "Pending admin confirmation",
                    style: AppTextStyles.small.copyWith(
                      color: isAssigned
                          ? Colors.greenAccent
                          : Colors.orangeAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
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

            // CONTACT INFO — only shown once the admin has assigned this
            // tutor, per the phone/email appearing on the connect card.
            if (isAssigned && (phone.isNotEmpty || email.isNotEmpty)) ...[
              if (phone.isNotEmpty)
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 14,
                      color: AppColors.white.withAlpha(179),
                    ),
                    AppSpacing.w5,
                    Text(
                      phone,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.white.withAlpha(220),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              if (email.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.email,
                      size: 14,
                      color: AppColors.white.withAlpha(179),
                    ),
                    AppSpacing.w5,
                    Text(
                      email,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.white.withAlpha(220),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
              AppSpacing.h10,
            ],

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

    // Only run the jump logic if we have messages
    if (provider.messages.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!scrollController.hasClients) return;

        final isAtBottom =
            scrollController.position.pixels >=
            (scrollController.position.maxScrollExtent - 100);

        // JUMP IF: It's the first time loading OR the user is already at the bottom
        if (_isFirstLoad || isAtBottom) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);

          if (_isFirstLoad) {
            setState(() => _isFirstLoad = false);
          }
        }
      });
    }

    final bool isDesktop = Responsive.isDesktop(context);
    final bool isTablet = Responsive.isTablet(context);
    // Scale chat-bar chrome and emoji picker height with device class instead
    // of using one fixed value everywhere.
    final EdgeInsets chatBarMargin = isDesktop
        ? const EdgeInsets.fromLTRB(24, 4, 24, 16)
        : isTablet
        ? const EdgeInsets.fromLTRB(16, 3, 16, 12)
        : const EdgeInsets.fromLTRB(10, 2, 10, 10);
    final double emojiPickerHeight = isDesktop ? 320 : (isTablet ? 280 : 250);

    final Map<String, dynamic>? latestCard = _latestConnectCard(
      provider.messages,
    );
    final bool isAssigned = latestCard != null
        ? _isCardAssigned(latestCard)
        : false;
    final String? headerTutorName = isAssigned
        ? (latestCard?["name"]?.toString() ?? widget.tutor?["name"]?.toString())
        : widget.tutor?["name"]?.toString();

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
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                // Before assignment we're really talking to Admin about a
                // requested tutor; after assignment it's a direct tutor chat.
                isAssigned
                    ? (headerTutorName ?? "Chat")
                    : (latestCard != null
                          ? "Admin"
                          : (headerTutorName ?? "Chat")),
                style: AppTextStyles.subHeading,
              ),
              if (latestCard != null)
                Text(
                  isAssigned
                      ? "Chatting directly with tutor"
                      : "Discussing request for ${headerTutorName ?? 'tutor'}",
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.white.withAlpha(150),
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ),
        body: ResponsiveBody(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
         
              Expanded(
                child: provider.isLoadingMessages
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        key: const PageStorageKey('chat_list_key'),
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
                margin: chatBarMargin,
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
                  height: emojiPickerHeight,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      controller.text += emoji.emoji;
                    },
                    config: Config(
                      height: emojiPickerHeight,
                      checkPlatformCompatibility: true,
                      emojiViewConfig: EmojiViewConfig(
                        backgroundColor: AppColors.background,
                        columns: isDesktop ? 10 : (isTablet ? 9 : 7),
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
