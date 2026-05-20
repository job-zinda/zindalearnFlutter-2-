import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApiService {
  static const String baseUrl = "https://zindalearnbackend.onrender.com/api";

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/login_user");

    try {
      final bool isEmail = email.contains("@");

      final bodyData = isEmail
          ? {"email": email.trim(), "pass": password.trim()}
          : {"phone": email.trim(), "pass": password.trim()};

      print("URL: $url");

      print("LOGIN BODY:");
      print(bodyData);

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      print("STATUS CODE: ${response.statusCode}");

      print("LOGIN RESPONSE: ${response.body}");

      // return jsonDecode(response.body);

      final data = jsonDecode(response.body);

if (response.statusCode == 200) {
  return data;
} else {
  return {
    "msg": data["msg"] ??
        "Something went wrong",
  };
}
    } catch (e) {
      print("LOGIN ERROR: $e");

      return {"msg": "Network error"};
    }
  }

  /// REGISTER
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String cpassword,
  }) async {
    final url = Uri.parse("$baseUrl/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "phone": phone,
        "pass": password,
        "cpass": cpassword,
      }),
    );

    return jsonDecode(response.body);
  }

  /// FORGOT PASSWORD (SEND OTP)
  static Future<Map<String, dynamic>> sendOtp({required String email}) async {
    final url = Uri.parse("$baseUrl/user_forgoat_password_send_otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      print("SEND OTP RESPONSE: ${response.body}");
      print("STATUS CODE: ${response.statusCode}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"msg": "Server error", "status": response.statusCode};
      }
    } catch (e) {
      return {"msg": "Network error: $e"};
    }
  }

  /// VERIFY OTP
  static Future<Map<String, dynamic>> verifyOtp({
    required String otp,
    required String email,
  }) async {
    final url = Uri.parse("$baseUrl/user_forgoat_password_verify_otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otp": otp}),
      );

      print("VERIFY OTP RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"msg": "Server error"};
      }
    } catch (e) {
      return {"msg": "Network error"};
    }
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/user_reset_password");

    try {
      final bodyData = {
        "email": email.trim(),
        "otp": otp.trim(),
        "newpass": password.trim(),
        "confirmpass": password.trim(),
      };

      print("FINAL RESET METHOD");
      print(bodyData);

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RAW RESPONSE: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print("RESET ERROR: $e");

      return {"msg": "Network error"};
    }
  }
}
