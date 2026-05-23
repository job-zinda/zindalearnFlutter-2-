import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileService {

  static const String baseUrl =
      "https://zindalearnbackend.onrender.com/api";

  /// ================= GET PROFILE =================
  static Future<Map<String, dynamic>> getProfile({
    required String token,
  }) async {

    final url = Uri.parse("$baseUrl/my_profile");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print(response.body);

      return jsonDecode(response.body);

    } catch (e) {
      return {
        "msg": "Network error",
      };
    }
  }

  /// ================= UPDATE PROFILE =================
  static Future<Map<String, dynamic>> updateProfile({
    required String token,
    required String name,
    required String phone,
    String? photo,
  }) async {

    final url = Uri.parse("$baseUrl/update_my_profile");

    try {
      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "phone": phone,
          if (photo != null) "photo": photo,
        }),
      );

      print(response.body);

      return jsonDecode(response.body);

    } catch (e) {
      return {
        "msg": "Network error",
      };
    }
  }

  /// ================= DELETE ACCOUNT =================
  static Future<Map<String, dynamic>> deleteAccount({
    required String token,
  }) async {

    final url = Uri.parse("$baseUrl/delete_my_account");

    try {
      final response = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print(response.body);

      return jsonDecode(response.body);

    } catch (e) {
      return {
        "msg": "Network error",
      };
    }
  }
}