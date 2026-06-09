// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;

// class ProfileService {

//   static const String baseUrl =
//       "https://api.zindalearn.com/api";

//   /// ================= GET PROFILE =================
//   static Future<Map<String, dynamic>> getProfile({
//     required String token,
//   }) async {

//     final url = Uri.parse("$baseUrl/my_profile");

//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//       );

//       // print(response.body);

//       return jsonDecode(response.body);

//     } catch (e) {
//       return {
//         "msg": "Network error",
//       };
//     }
//   }

//   /// ================= UPDATE PROFILE =================
//   // static Future<Map<String, dynamic>> updateProfile({
//   //   required String token,
//   //   required String name,
//   //   required String phone,
//   //   String? photo,
//   // }) async {

//   //   final url = Uri.parse("$baseUrl/update_my_profile");

//   //   try {
//   //     final response = await http.put(
//   //       url,
//   //       headers: {
//   //         "Authorization": "Bearer $token",
//   //         "Content-Type": "application/json",
//   //       },
//   //       body: jsonEncode({
//   //         "name": name,
//   //         "phone": phone,
//   //         "photo": photo,
//   //       }),
//   //     );

//   //     // print(response.body);

//   //     return jsonDecode(response.body);

//   //   } catch (e) {
//   //     return {
//   //       "msg": "Network error",
//   //     };
//   //   }
//   // }

// //   static Future<Map<String, dynamic>> updateProfile({
// //   required String token,
// //   required String name,
// //   required String phone,
// //   String? photo,
// // }) async {

// //   final url = Uri.parse("$baseUrl/update_my_profile");

// //   try {

// //     final body = {
// //       "name": name,
// //       "phone": phone,
// //       "photo": photo,
// //     };

// //     print("REQUEST BODY:");
// //     print(body);
// //     print("PHOTO LENGTH: ${photo?.length}");

// //     final response = await http.put(
// //       url,
// //       headers: {
// //         "Authorization": "Bearer $token",
// //         "Content-Type": "application/json",
// //       },
// //       body: jsonEncode(body),
// //     );

// //     print("UPDATE STATUS: ${response.statusCode}");
// //     print("UPDATE BODY: ${response.body}");

// //     return jsonDecode(response.body);

// //   } catch (e) {
// //     print("UPDATE ERROR: $e");

// //     return {
// //       "msg": "Network error",
// //     };
// //   }
// // }

// static Future<Map<String, dynamic>> updateProfile({
//     required String token,
//     required String name,
//     required String phone,
//     String? filePath, // Pass the local file path string here instead of a base64 string
//   }) async {
//     final url = Uri.parse("$baseUrl/update_my_profile");

//     try {
//       // Create a multipart request instead of a standard JSON request
//       final request = http.MultipartRequest("PUT", url);

//       // Add authorization headers
//       request.headers.addAll({
//         "Authorization": "Bearer $token",
//       });

//       // Add text/form fields
//       request.fields["name"] = name;
//       request.fields["phone"] = phone;

//       // Attach the image file if it exists locally
//       if (filePath != null && filePath.isNotEmpty) {
//         final file = File(filePath);
//         if (await file.exists()) {
//           request.files.add(
//             await http.MultipartFile.fromPath(
//               "photo", // This MUST match the string inside your backend's .single("photo")
//               file.path,
//               contentType: http.MediaType("image", "jpeg"), // Explicitly define content type
//             ),
//           );
//           print("MULTIPART: Attached image file from path: ${file.path}");
//         } else {
//           print("MULTIPART WARNING: Provided file path does not exist on disk.");
//         }
//       }

//       print("SENDING MULTIPART REQUEST TO: $url");
      
//       // Send the multipart request stream to the server
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       print("UPDATE STATUS: ${response.statusCode}");
//       print("UPDATE BODY: ${response.body}");

//       return jsonDecode(response.body);
//     } catch (e) {
//       print("UPDATE ERROR: $e");
//       return {
//         "msg": "Network error",
//       };
//     }
//   }

//   /// ================= DELETE ACCOUNT =================
//   static Future<Map<String, dynamic>> deleteAccount({
//     required String token,
//   }) async {

//     final url = Uri.parse("$baseUrl/delete_my_account");

//     try {
//       final response = await http.delete(
//         url,
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//       );

//       // print(response.body);

//       return jsonDecode(response.body);

//     } catch (e) {
//       return {
//         "msg": "Network error",
//       };
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProfileService {
  static const String baseUrl = "https://api.zindalearn.com/api";

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
    String? filePath,
  }) async {
    final url = Uri.parse("$baseUrl/update_my_profile");

    try {
      final request = http.MultipartRequest("PUT", url);

      request.headers.addAll({
        "Authorization": "Bearer $token",
      });

      request.fields["name"] = name;
      request.fields["phone"] = phone;

      if (filePath != null && filePath.isNotEmpty) {
        final file = File(filePath);
        if (await file.exists()) {
          request.files.add(
            await http.MultipartFile.fromPath(
              "photo",
              file.path,
              contentType: MediaType("image", "jpeg"),
            ),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

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

      return jsonDecode(response.body);
    } catch (e) {
      return {
        "msg": "Network error",
      };
    }
  }
}