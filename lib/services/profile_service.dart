import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ProfileService {

  static const String baseUrl =
      "https://zindalearnbackend.onrender.com/api";

  /// GET PROFILE
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

  /// UPDATE PROFILE
  static Future<Map<String, dynamic>> updateProfile({
    required String token,
    required String name,
    required String phone,
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

  /// DELETE ACCOUNT
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

  /// UPLOAD PROFILE PHOTO
  static Future<Map<String, dynamic>> uploadProfilePhoto({
    required String token,
    required File imageFile,
  }) async {

    final url = Uri.parse("$baseUrl/upload_profile_photo");

    try {

      var request = http.MultipartRequest(
        "POST",
        url,
      );

      request.headers["Authorization"] = "Bearer $token";

      request.files.add(
        await http.MultipartFile.fromPath(
          "profile",
          imageFile.path,
        ),
      );

      final streamedResponse = await request.send();

      final response =
          await http.Response.fromStream(streamedResponse);

      print(response.body);

      return jsonDecode(response.body);

    } catch (e) {

      return {
        "msg": "Upload failed",
      };
    }
  }
}