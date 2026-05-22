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

  /// CONNECT TUTOR
  Future<Map<String, dynamic>?> connectTutor(
      String tutorId, String token) async {
    try {
      _isLoading = true;
      notifyListeners();

      final res = await _service.connectRequest(tutorId, token);

      if (res != null && res["room"] != null) {
        _requestSent = true;
        await fetchRooms(token);
        notifyListeners();
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
      _rooms = res;
      notifyListeners();
    } catch (e) {
      debugPrint("Room error: $e");
    }
  }

  /// GET MESSAGES
  Future<void> fetchMessages(String roomId, String token) async {
    try {
      final res = await _service.getMessages(roomId, token);
      _messages = res;
      notifyListeners();
    } catch (e) {
      debugPrint("Message error: $e");
    }
  }

  /// SEND MESSAGE
//   Future<void> sendMessage(
//   String roomId,
//   String message,
//   String token,
// ) async {
//   try {
//     await _service.sendMessage(roomId, message, token);

//     final updated = await _service.getMessages(roomId, token);

//     _messages = updated;

//     notifyListeners();
//   } catch (e) {
//     debugPrint("Send error: $e");
//   }
// }

// Future<void> sendMessage(
//   String roomId,
//   String message,
//   String token,
// ) async {
//   try {
//     await _service.sendMessage(roomId, message, token);

//     ///  FORCE REFRESH AFTER SEND
//     final updated = await _service.getMessages(roomId, token);

//     _messages = List.from(updated); // IMPORTANT (force rebuild copy)

//     notifyListeners();

//   } catch (e) {
//     debugPrint("Send error: $e");
//   }
// }
Future<void> sendMessage(
  String roomId,
  String message,
  String token,
) async {
  try {
    await _service.sendMessage(roomId, message, token);

    ///  SMALL DELAY FIX (VERY IMPORTANT IN CHAT APPS)
    await Future.delayed(const Duration(milliseconds: 200));

    final updated = await _service.getMessages(roomId, token);

    _messages = List.from(updated); //
    notifyListeners();

  } catch (e) {
    debugPrint("Send error: $e");
  }
}

Future<void> editMessage(
  String messageId,
  String message,
  String token,
  String roomId,
) async {
  try {
    await _service.editMessage(messageId, message, token);

    final updated = await _service.getMessages(roomId, token);

    _messages = updated;

    notifyListeners();
  } catch (e) {
    debugPrint("Edit error: $e");
  }
}

/// DELETE MESSAGE
Future<void> deleteMessage(
  String messageId,
  String roomId,
  String token,
) async {
  try {
    await _service.deleteMessage(messageId, token);

    
    final updated = await _service.getMessages(roomId, token);

    _messages = updated;

    notifyListeners();
  } catch (e) {
    debugPrint("Delete error: $e");
  }
}
}