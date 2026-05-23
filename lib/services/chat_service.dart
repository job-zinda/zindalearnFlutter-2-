import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  String baseUrl = "https://zindalearnbackend.onrender.com/api";

  /// CONNECT REQUEST
  Future connectRequest(String tutorId, String token) async {
    final res = await http.post(
      Uri.parse("$baseUrl/chat/connect-request/$tutorId"),
      headers: {"Authorization": "Bearer $token"},
    );

    return jsonDecode(res.body);
  }

  /// ROOMS
  Future getChatRooms(String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/chat/rooms"),
      headers: {"Authorization": "Bearer $token"},
    );

    return jsonDecode(res.body)["rooms"];
  }

  /// MESSAGES
  Future getMessages(String roomId, String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/chat/messages/$roomId"),
      headers: {"Authorization": "Bearer $token"},
    );

    return jsonDecode(res.body)["messages"];
  }

  /// SEND MESSAGE
  // Future sendMessage(String roomId, String msg, String token) async {
  //   await http.post(
  //     Uri.parse("$baseUrl/chat/message/$roomId"),
  //     headers: {"Authorization": "Bearer $token"},
  //     body: {"message": msg},
  //   );
  // }
  Future sendMessage(
    String roomId,
    String msg,
    String token,
) async {

  final res = await http.post(

    Uri.parse(
      "$baseUrl/chat/message/$roomId",
    ),

    headers: {

      "Authorization":
          "Bearer $token",

      "Content-Type":
          "application/json",
    },

    body: jsonEncode({

      "text": msg,

      // OR use "message"
      // if backend expects that
    }),
  );

  print(
    "SEND STATUS: ${res.statusCode}",
  );

  print(
    "SEND BODY: ${res.body}",
  );
}

  /// MARK AS READ
  Future markAsRead(String roomId, String token) async {
    await http.put(
      Uri.parse("$baseUrl/chat/read/$roomId"),
      headers: {"Authorization": "Bearer $token"},
    );
  }
Future editMessage(
  String messageId,
  String message,
  String token,
) async {
final res = await http.patch(
  Uri.parse("$baseUrl/chat/message/$messageId"),
  headers: {
    "Authorization": "Bearer $token",
    "Content-Type": "application/json",
  },
  body: jsonEncode({"message": message}),
);

  return jsonDecode(res.body);
}

  ///  DELETE MESSAGE
  Future deleteMessage(
    String messageId,
    String token,
  ) async {
    final res = await http.delete(
      Uri.parse("$baseUrl/chat/message/$messageId"),
      headers: {"Authorization": "Bearer $token"},
    );

    return jsonDecode(res.body);
  }
}