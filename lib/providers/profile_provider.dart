import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/profile_service.dart';

class ProfileProvider with ChangeNotifier {

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _profileData;
  Map<String, dynamic>? get profileData => _profileData;

  final ImagePicker _picker = ImagePicker();

  File? _image;
  File? get image => _image;

  // ===================== GET PROFILE =====================
  Future<(bool, dynamic)> getProfile({
    required String token,
  }) async {

    _isLoading = true;
    notifyListeners();

    try {
      final res = await ProfileService.getProfile(token: token);

      if (res["user"] != null) {
        _profileData = res["user"];
        return (true, res);
      }

      return (false, res["msg"] ?? "Failed");

    } catch (e) {
      return (false, "Error occurred");

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===================== UPDATE PROFILE =====================
  Future<(bool, dynamic)> updateProfile({
    required String token,
    required String name,
    required String phone,
  }) async {

    _isLoading = true;
    notifyListeners();

    try {

      String? base64Image;

      if (_image != null) {
        base64Image = base64Encode(await _image!.readAsBytes());
      }

      final res = await ProfileService.updateProfile(
        token: token,
        name: name,
        phone: phone,
        photo: base64Image,
      );

      if (res["msg"] != null) {
        await getProfile(token: token); // refresh UI
        return (true, res["msg"]);
      }

      return (false, "Update failed");

    } catch (e) {
      return (false, "Error occurred");

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===================== DELETE ACCOUNT =====================
  Future<(bool, dynamic)> deleteAccount({
    required String token,
  }) async {

    _isLoading = true;
    notifyListeners();

    try {
      final res = await ProfileService.deleteAccount(token: token);

      if (res["msg"] != null) {
        return (true, res["msg"]);
      }

      return (false, "Delete failed");

    } catch (e) {
      return (false, "Error occurred");

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===================== PICK IMAGE (OPTIONAL) =====================
  Future<void> pickImageFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      _image = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> pickImageFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      _image = File(picked.path);
      notifyListeners();
    }
  }

  void clearImage() {
    _image = null;
    notifyListeners();
  }
}