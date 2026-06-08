import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zindaonlineschool/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _isConfirmPasswordVisible = false;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  String? _emailForReset;
  String? _storedOtp;

  String? _userId;
  String? get userId => _userId;

  void setUserId(String id) {
  _userId = id;
  notifyListeners();
}

  // getters
  String? get emailForReset => _emailForReset;
  String? get storedOtp => _storedOtp;

  void togglePassword() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

Future<(bool, dynamic)> login({
  required String email,
  required String password,
}) async {

  _isLoading = true;
  notifyListeners();

  try {

    final res = await AuthApiService.login(
      email: email,
      password: password,
    );

    // print("FULL RESPONSE = $res");

   if (res["token"] != null) {

  final prefs =
      await SharedPreferences.getInstance();

  await prefs.setString(
    "token",
    res["token"],
  );



  // print("student = ${res["student"]}");
  // print("user = ${res["user"]}");
  // print("data = ${res["data"]}");
  // print("root = ${res["_id"]}");

  _userId =
      res["student"]?["_id"]?.toString() ??
      res["user"]?["id"]?.toString() ??   // ← FIXED HERE
      res["data"]?["_id"]?.toString() ??
      res["_id"]?.toString() ??
      "";

  // print("EXTRACTED USER ID = $_userId");

  if (_userId != null &&
      _userId!.trim().isNotEmpty) {

    await prefs.setString(
      "userId",
      _userId!,
    );

  }

  await loadUser();

  return (true, res);
}

    return (
      false,
      {"msg":res["msg"] ?? "Login failed"},
    );

  } catch(e){

    // print("LOGIN ERROR = $e");

    return (
      false,
      {"msg":"Something went wrong"},
    );

  } finally {

    _isLoading = false;
    notifyListeners();
  }
}


Future<void> loadUser() async {

  final prefs =
      await SharedPreferences.getInstance();

  _userId =
      prefs.getString("userId");



  notifyListeners();
}
  // ---------------- REGISTER ----------------
  Future<(bool, dynamic)> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String cpassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await AuthApiService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        cpassword: cpassword,
      );

      // print(res);

      if (res["msg"] == "Registration successful") {
        return (true, res["msg"]);
      }

      return (false, res["msg"] ?? "Register failed");
    } catch (e) {
      return (false, "Something went wrong");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------- FORGOT PASSWORD ----------------
  Future<(bool, dynamic)> sendOtp(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await AuthApiService.sendOtp(email: email);

      if (res["msg"] == "OTP sent to email") {
        _emailForReset = email;
        return (true, res["msg"]);
      }

      return (false, res["msg"] ?? "Failed to send OTP");
    } catch (e) {
      return (false, "Error occurred");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------- VERIFY OTP ----------------
  Future<(bool, dynamic)> verifyOtp({
    required String email,
    required String otp,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await AuthApiService.verifyOtp(email: email, otp: otp);

      // print(res);

      if (res["msg"] == "OTP verified") {
        _storedOtp = otp;
        return (true, res["msg"]);
      }

      return (false, res["msg"] ?? "Invalid OTP");
    } catch (e) {
      return (false, "Error occurred");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------- RESET PASSWORD ----------------
  Future<(bool, dynamic)> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await AuthApiService.resetPassword(
        email: email,
        otp: otp,
        password: password,
      );

      // print(res);

      if (res["msg"] == "Password reset successful") {
        return (true, res["msg"]);
      }

      return (false, res["msg"] ?? "Reset failed");
    } catch (e) {
      return (false, "Error occurred");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> logout() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   await prefs.clear();

  //   notifyListeners();
  // }

  Future<void> logout() async {

  final prefs =
      await SharedPreferences.getInstance();

  await prefs.clear();

  _userId = "";

  notifyListeners();
}
}

