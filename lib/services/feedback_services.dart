import 'dart:convert';
import 'package:http/http.dart' as http;

class FeedbackService {
  static const baseUrl = "https://zindalearnbackend.onrender.com/api";

  /// SEND FEEDBACK
  static Future<Map<String, dynamic>> sendFeedback({
    required String token,
    required String message,
  }) async {
    final url = Uri.parse("$baseUrl/feedback");

    final res = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "message": message,
      }),
    );

    return jsonDecode(res.body);
  }

  /// MY FEEDBACK
  static Future<Map<String, dynamic>> getMyFeedback({
    required String token,
  }) async {
    final url = Uri.parse("$baseUrl/feedback/my");

    final res = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return jsonDecode(res.body);
  }

  /// ALL FEEDBACK (STUDENTS SAY)
 static Future<Map<String, dynamic>> getAllFeedback(String token) async {
  final response = await http.get(
    Uri.parse("https://zindalearnbackend.onrender.com/api/get/feedback/all"),

    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", // 🔥 VERY IMPORTANT
    },
  );

  print("STATUS CODE: ${response.statusCode}");
  print("BODY: ${response.body}");

  return jsonDecode(response.body);
}
}

