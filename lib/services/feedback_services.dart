import 'dart:convert';
import 'package:http/http.dart' as http;

class FeedbackService {

  static const String baseUrl =
      "https://zindalearnbackend.onrender.com/api";

  /// =========================
  /// SAFE JSON CHECK
  /// =========================
  static dynamic _safeDecode(http.Response res) {

    print("STATUS CODE: ${res.statusCode}");
    print("BODY: ${res.body}");

    /// HTML RESPONSE
    if (res.body.startsWith("<")) {
      throw Exception(
        "Server returned HTML instead of JSON",
      );
    }

    return jsonDecode(res.body);
  }

  /// =========================
  /// GET ALL USERS FEEDBACK
  /// =========================
  static Future<Map<String, dynamic>>
      getAllUsersFeedback(String token) async {

    final res = await http.get(
      Uri.parse("$baseUrl/get/feedback/all"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return _safeDecode(res);
  }

  /// =========================
  /// GET MY FEEDBACK
  /// =========================
  static Future<Map<String, dynamic>>
      getMyFeedback(String token) async {

    final res = await http.get(
      Uri.parse("$baseUrl/feedback/my"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return _safeDecode(res);
  }

  /// =========================
  /// SEND FEEDBACK
  /// =========================
  static Future sendFeedback({
    required String token,
    required String message,
    required int rating,
  }) async {

    final res = await http.post(
      Uri.parse("$baseUrl/feedback"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "message": message,
        "rating": rating,
      }),
    );

    return _safeDecode(res);
  }

  /// =========================
  /// UPDATE FEEDBACK
  /// =========================
  /// UPDATE FEEDBACK
static Future<bool> updateFeedback({
  required String token,
  required String id,
  required String message,
  required int rating,
}) async {

  final url = "https://zindalearnbackend.onrender.com/api/feedback";

  print("UPDATE URL: $url");
  print("EDIT ID: $id");

  final res = await http.put(
    Uri.parse(url),

    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },

    body: jsonEncode({
      "id": id,          // ✅ IMPORTANT: send id in BODY
      "message": message,
      "rating": rating,
    }),
  );

  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return res.statusCode == 200;
}
  /// =========================
  /// DELETE FEEDBACK
  /// =========================
 static Future<bool> deleteFeedback({
  required String token,
  required String id,
}) async {

  try {

    final response = await http.delete(
      Uri.parse("$baseUrl/feedback/my"),

      headers: {
        "Authorization": "Bearer $token",
      },
    );

    print("DELETE STATUS: ${response.statusCode}");
    print("DELETE BODY: ${response.body}");

    if (response.statusCode == 200 ||
        response.statusCode == 201) {

      return true;
    }

    return false;

  } catch (e) {

    print("DELETE ERROR: $e");

    return false;
  }
}
}