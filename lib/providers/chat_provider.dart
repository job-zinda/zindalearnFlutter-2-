
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zindaonlineschool/services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _service = ChatService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _requestSent = false;
  bool get requestSent => _requestSent;

  List<dynamic> _rooms = [];
  List<dynamic> get rooms => _rooms;

  List<dynamic> _messages = [];
  List<dynamic> get messages => _messages;

  bool _isLoadingMessages = false;
bool get isLoadingMessages => _isLoadingMessages;


  List<dynamic> _assignedTutors = [];
List<dynamic> get assignedTutors => _assignedTutors;

bool _isLoadingAssignedTutors = false;
bool get isLoadingAssignedTutors => _isLoadingAssignedTutors;

  // WHATSAPP OPTIMIZATION CACHE: Tracks filename strings AND sizes to paths
  final Map<String, String> _localPathCacheByName = {};
  final Map<int, String> _localPathCacheBySize = {};

  /// Helper method to safely read our local cache paths from anywhere
  String? getLocalPath(String? name, int? size) {
    if (name != null && _localPathCacheByName.containsKey(name)) {
      return _localPathCacheByName[name];
    }
    if (size != null && _localPathCacheBySize.containsKey(size)) {
      return _localPathCacheBySize[size];
    }
    return null;
  }

  /// CONNECT TUTOR
  Future<Map<String, dynamic>?> connectTutor(String tutorId, String token) async {
    try {
      _isLoading = true;
      notifyListeners();

      final res = await _service.connectRequest(tutorId, token);

      if (res != null && res["room"] != null) {
        _requestSent = true;
        await fetchRooms(token);
      }

      return res;
    } catch (e) {
      debugPrint("Connect error: $e");
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// GET ROOMS
  Future<void> fetchRooms(String token) async {
    try {
      final res = await _service.getChatRooms(token);
      _rooms = res ?? [];
      notifyListeners();
    } catch (e) {
      debugPrint("Room error: $e");
    }
  }

  /// GET MESSAGES
  // Future<void> fetchMessages(String roomId, String token) async {
  //   try {
  //     final res = await _service.getMessages(roomId, token);
  //     _messages = res ?? [];
  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint("Message error: $e");
  //   }
  // }

/// GET MESSAGES
Future<void> fetchMessages(String roomId, String token) async {
  try {
    _isLoadingMessages = true;
    _messages = [];
    notifyListeners();

    final res = await _service.getMessages(roomId, token);
    _messages = res ?? [];
  } catch (e) {
    debugPrint("Message error: $e");
  } finally {
    _isLoadingMessages = false;
    notifyListeners();
  }
}
  /// SEND MESSAGE
  Future<void> sendMessage(String roomId, String message, String token) async {
    try {
      await _service.sendMessage(roomId, message, token);
      await Future.delayed(const Duration(milliseconds: 200));
      final updated = await _service.getMessages(roomId, token);
      _messages = List.from(updated ?? []);
      notifyListeners();
    } catch (e) {
      debugPrint("Send error: $e");
    }
  }

  /// EDIT MESSAGE
  Future<void> editMessage(String messageId, String message, String token, String roomId) async {
    try {
      await _service.editMessage(messageId, message, token);
      final updated = await _service.getMessages(roomId, token);
      _messages = updated ?? [];
      notifyListeners();
    } catch (e) {
      debugPrint("Edit error: $e");
    }
  }

  /// DELETE MESSAGE
  Future<void> deleteMessage(String messageId, String roomId, String token) async {
    try {
      await _service.deleteMessage(messageId, token);
      final updated = await _service.getMessages(roomId, token);
      _messages = updated ?? [];
      notifyListeners();
    } catch (e) {
      debugPrint("Delete error: $e");
    }
  }




  /// MARK AS READ
  Future<void> markAsRead(String roomId, String token) async {
    try {
      await _service.markAsRead(roomId, token);
    } catch (e) {
      debugPrint("Read error: $e");
    }
  }

  /// SEND IMAGE MESSAGE (Complete Identity Preservation)
  Future<void> sendImagesMessage(String roomId, List<File> images, String token) async {
    if (images.isEmpty) return;

    final String tempId = "temp_${DateTime.now().microsecondsSinceEpoch}";
    final String timestamp = DateTime.now().toIso8601String();
    final List<Map<String, dynamic>> localFilesArray = [];

    for (File file in images) {
      final int fileSize = file.lengthSync();
      final String fileNameStr = file.path.split('/').last; // e.g. "scaled_38.jpg"

      // Cache using both keys for absolute certainty
      _localPathCacheByName[fileNameStr] = file.path;
      _localPathCacheBySize[fileSize] = file.path;

      localFilesArray.add({
        "path": file.path, 
        "originalName": fileNameStr,
        "fileType": "image",
        "mimeType": "image/jpeg",
        "size": fileSize 
      });
    }

    final Map<String, dynamic> tempCombinedMessage = {
      "_id": tempId,
      "roomId": roomId,
      "messageType": "file", 
      "text": "", 
      "createdAt": timestamp,
      "isSender": true,
      "isTemp": true,
      "files": localFilesArray
    };

    try {
      _messages = [..._messages, tempCombinedMessage];
      notifyListeners();

      final success = await _service.sendImages(roomId, images, token);

      if (success) {
        final updated = await _service.getMessages(roomId, token);
        _messages = updated ?? [];
      } else {
        _messages.removeWhere((msg) => msg["_id"] == tempId);
      }
    } catch (e) {
      debugPrint("Images provider failure: $e");
      _messages.removeWhere((msg) => msg["_id"] == tempId);
    } finally {
      notifyListeners();
    }
  }

  /// SEND VOICE MESSAGE
  Future<void> sendVoiceMessage(String roomId, File audioFile, String token) async {
    if (!audioFile.existsSync()) return;

    final String tempId = "temp_${DateTime.now().microsecondsSinceEpoch}";
    final Map<String, dynamic> tempVoice = {
      "_id": tempId,
      "roomId": roomId,
      "messageType": "audio",
      "text": "Voice message",
      "fileUrl": audioFile.path,
      "createdAt": DateTime.now().toIso8601String(),
      "isSender": true,
      "isTemp": true,
    };

    try {
      _messages.add(tempVoice);
      notifyListeners();

      final success = await _service.sendImages(roomId, [audioFile], token);

      if (success) {
        final updated = await _service.getMessages(roomId, token);
        _messages = updated ?? [];
      } else {
        _messages.removeWhere((msg) => msg["_id"] == tempId);
      }
    } catch (e) {
      debugPrint("Voice file streaming error: $e");
      _messages.removeWhere((msg) => msg["_id"] == tempId);
    } finally {
      notifyListeners();
    }
  }
Future<void> fetchAssignedTutors(String token) async {
  try {
    _isLoadingAssignedTutors = true;
    notifyListeners();
    _assignedTutors = await _service.getAssignedTutors(token);
  } catch (e) {
    debugPrint("Assigned tutors error: $e");
  } finally {
    _isLoadingAssignedTutors = false;
    notifyListeners();
  }
}
/// Fetches or creates the direct room for a specific assigned tutor
Future<Map<String, dynamic>?> getStudentTutorRoom(
  String tutorId,
  String token,
) async {
  try {
    // 1. Call backend to get or create the student-tutor room
    final room = await _service.getStudentTutorRoom(tutorId, token);

    // 2. Refresh local room list in background
    fetchRooms(token);

    return room;
  } catch (e) {
    debugPrint("Student-tutor room provider error: $e");
    return null;
  }
}

/// Checked by TutorDetailsScreen to decide "Send Request" vs "Chat with Tutor".
bool isTutorAssigned(String tutorId) {
  return _assignedTutors.any((t) {
    if (t is! Map) return false;
    final id = t["_id"] ?? t["id"] ?? t["tuterId"] ?? t["tutorId"];
    return id?.toString() == tutorId;
  });
}

}