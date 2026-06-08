import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedbackService {
  static const String baseUrl = "https://api.zindalearn.com/api";

 
  /// SAFE JSON CHECK
 
  // static dynamic _safeDecode(http.Response res) {
  //   /// HTML RESPONSE
  //   if (res.body.startsWith("<")) {
  //     throw Exception("Server returned HTML instead of JSON");
  //   }

  //   return jsonDecode(res.body);
  // }
static dynamic _safeDecode(http.Response res) {

  debugPrint(
    "STATUS CODE: ${res.statusCode}",
  );

  if (res.body.startsWith("<")) {
    throw Exception(
      "Server returned HTML instead of JSON",
    );
  }

  return jsonDecode(res.body);
}
  static Future<Map<String, dynamic>> getAllUsersFeedback(String token) async {
    try {
      final res = await http
          .get(
            Uri.parse("$baseUrl/get/feedback/all"),
            headers: {"Authorization": "Bearer $token"},
          )
          .timeout(const Duration(seconds: 60));

      return _safeDecode(res);
    } catch (e) {


      throw Exception("Connection problem / Render server sleeping");
    }
  }

  static Future<Map<String, dynamic>> getMyFeedback(String token) async {
    try {
      final res = await http
          .get(
            Uri.parse("$baseUrl/feedback/my"),
            headers: {"Authorization": "Bearer $token"},
          )
          .timeout(const Duration(seconds: 60));

      return _safeDecode(res);
    } catch (e) {
      // print("MY FEEDBACK ERROR: $e");

      throw Exception("Network Error");
    }
  }

  static Future sendFeedback({
    required String token,
    required String message,
    required int rating,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse("$baseUrl/feedback"),

            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },

            body: jsonEncode({"message": message, "rating": rating}),
          )
          .timeout(const Duration(seconds: 60));

      return _safeDecode(res);
    } catch (e) {
      throw Exception("Send Feedback Failed");
    }
  }

  static Future<bool> updateFeedback({
    required String token,
    required String id,
    required String message,
    required int rating,
  }) async {
    final url = "https://api.zindalearn.com/api/feedback";

    final res = await http.put(
      Uri.parse(url),

      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "id": id, //  IMPORTANT: send id in BODY
        "message": message,
        "rating": rating,
      }),
    );

    return res.statusCode == 200;
  }

  static Future<bool> deleteFeedback({
    required String token,
    required String id,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/feedback/my"),

        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
     

      return false;
    }
  }
}
