
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zindaonlineschool/services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  // If this line still shows an error, check the exact spelling inside chat_service.dart
  final ChatService _service = ChatService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _requestSent = false;
  bool get requestSent => _requestSent;

  List<dynamic> _rooms = [];
  List<dynamic> get rooms => _rooms;

  List<dynamic> _messages = [];
  List<dynamic> get messages => _messages;

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
  Future<void> fetchMessages(String roomId, String token) async {
    try {
      final res = await _service.getMessages(roomId, token);
      _messages = res ?? [];
      notifyListeners();
    } catch (e) {
      debugPrint("Message error: $e");
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
  // Future<void> editMessage(String messageId, String message, String token, String roomId) async {
  //   try {
  //     await _service.editMessage(messageId, message, token);
  //     final updated = await _service.getMessages(roomId, token);
  //     _messages = updated ?? [];
  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint("Edit error: $e");
  //   }
  // }
  Future<void> editMessage(String messageId, String message, String token, String roomId) async {
  try {
    // 1. Tell the backend to update
    await _service.editMessage(messageId, message, token);
    
    // 2. Update the message locally in memory instantly
    final index = _messages.indexWhere((msg) => msg["_id"] == messageId);
    if (index != -1) {
      _messages[index]["text"] = message;
      _messages[index]["message"] = message;
    }

    // 3. Trigger UI update right away and stop here
    notifyListeners();
    
  } catch (e) {
    debugPrint("Edit error: $e");
    rethrow; 
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

  /// NO BASE64 IMAGE UPLOAD
  Future<void> sendImagesMessage(String roomId, List<File> images, String token) async {
    if (images.isEmpty) return;
    try {
      _isLoading = true;
      notifyListeners();

      final success = await _service.sendImages(roomId, images, token);

      if (success) {
        await Future.delayed(const Duration(milliseconds: 200));
        await fetchMessages(roomId, token);
      }
    } catch (e) {
      debugPrint("Images provider failure: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
/// Sends a raw audio recording file directly to the Cloudinary backend structure
  Future<void> sendVoiceMessage(String roomId, File audioFile, String token) async {
    if (!audioFile.existsSync()) return;
    try {
      _isLoading = true;
      notifyListeners();

      // 🛠️ CRITICAL FIX: Bypass Base64 translation.
      // Pass the audio file directly into the multi-part loader array, 
      // exactly like how you process images!
      final success = await _service.sendImages(roomId, [audioFile], token);

      if (success) {
        // A short delay gives Cloudinary time to complete processing before fetching fresh logs
        await Future.delayed(const Duration(milliseconds: 300));
        await fetchMessages(roomId, token);
      }
    } catch (e) {
      debugPrint("Voice file streaming error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  }
