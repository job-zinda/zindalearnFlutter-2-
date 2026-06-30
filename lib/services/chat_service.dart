
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class ChatService {
  String baseUrl = "https://api.zindalearn.com/api";

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
  Future<void> sendMessage(
    String roomId,
    String msg,
    String token, {
    String messageType = "text",
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/chat/message/$roomId");

      final Map<String, dynamic> bodyData = {
        "text": msg,
        "messageType": messageType,
      };

      final res = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(bodyData),
      );

      debugPrint("SEND MESSAGE STATUS: ${res.statusCode}");
    } catch (e) {
      debugPrint("Error in sendMessage service: $e");
    }
  }

  /// MARK AS READ
  Future markAsRead(String roomId, String token) async {
    await http.put(
      Uri.parse("$baseUrl/chat/read/$roomId"),
      headers: {"Authorization": "Bearer $token"},
    );
  }

  /// EDIT MESSAGE
  Future editMessage(String messageId, String message, String token) async {
    final res = await http.post(
      Uri.parse("$baseUrl/chat/message/$messageId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"message": message}),
    );
    return jsonDecode(res.body);
  }

  /// DELETE MESSAGE
  Future deleteMessage(String messageId, String token) async {
    final res = await http.delete(
      Uri.parse("$baseUrl/chat/message/$messageId"),
      headers: {"Authorization": "Bearer $token"},
    );
    return jsonDecode(res.body);
  }

  /// UPLOAD TO CLOUD STORAGE (High efficiency audio file pipeline)
  Future<String?> uploadToCloudStorage(File file, {bool isImage = false}) async {
    try {
      if (isImage) {
        // (Your working ImgBB image logic if needed)
        return null;
      } else {
        // Fast, direct streaming endpoint for physical voice notes
        final url = Uri.parse("https://tmpfiles.org/api/v1/upload");
        var request = http.MultipartRequest("POST", url);

        // Standard direct form key setup
        request.files.add(await http.MultipartFile.fromPath('file', file.path));

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        debugPrint("AUDIO CLOUD STORAGE RESPONSE: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);
          if (data != null && data["data"] != null && data["data"]["url"] != null) {
            return data["data"]["url"].toString();
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint("Cloud voice note storage upload failed: $e");
      return null;
    }
  }

 /// SEND IMAGE / VOICE FILES
Future<bool> sendImages(
  String roomId,
  List<File> files,
  String token,
) async {
  try {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/chat/file-message/$roomId"),
    );

    request.headers["Authorization"] = "Bearer $token";

    for (File file in files) {
      // 1. Determine the extension (e.g., '.jpg', '.png')
      String extension = path.extension(file.path).toLowerCase();
      
      // 2. Map the extension to the correct type/subtype for Multer
      String type = "image";
      String subtype = "jpeg"; // default fallback
      
      if (extension == ".png") {
        subtype = "png";
      } else if (extension == ".gif") {
        subtype = "gif";
      } else if (extension == ".webp") {
        subtype = "webp";
      } else if (extension == ".mp3" || extension == ".m4a" || extension == ".wav") {
        type = "audio";
        subtype = extension.replaceAll('.', '');
      }

      // 3. Attach the file with the explicit proper MediaType
      request.files.add(
        await http.MultipartFile.fromPath(
          "files",
          file.path,
          contentType: MediaType(type, subtype), 
        ),
      );
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    debugPrint("UPLOAD STATUS : ${response.statusCode}");
    debugPrint("UPLOAD RESPONSE : $responseBody");

    return response.statusCode == 200 || response.statusCode == 201;

  } catch (e) {
    debugPrint("UPLOAD ERROR : $e");
    return false;
  }
}
}