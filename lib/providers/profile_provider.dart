import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/profile_service.dart';

class ProfileProvider with ChangeNotifier {

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Map<String, dynamic>? _profileData;

  Map<String, dynamic>? get profileData => _profileData;
  File? _image;
File? get image => _image;

final ImagePicker _picker = ImagePicker();

  /// GET PROFILE
  Future<(bool, dynamic)> getProfile({
    required String token,
  }) async {

    _isLoading = true;
    notifyListeners();

    try {

      final res =
          await ProfileService.getProfile(token: token);

      if (res["user"] != null) {

        _profileData = res["user"];

        return (true, res);
      }

      return (false, res["msg"]);

    } catch (e) {

      return (false, "Error occurred");

    } finally {

      _isLoading = false;
      notifyListeners();
    }
  }

  /// UPDATE PROFILE
  Future<(bool, dynamic)> updateProfile({
    required String token,
    required String name,
    required String phone,
  }) async {

    _isLoading = true;
    notifyListeners();

    try {

      final res =
          await ProfileService.updateProfile(
        token: token,
        name: name,
        phone: phone,
      );

      if (res["msg"] != null) {
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

  /// DELETE ACCOUNT
  Future<(bool, dynamic)> deleteAccount({
    required String token,
  }) async {

    _isLoading = true;
    notifyListeners();

    try {

      final res =
          await ProfileService.deleteAccount(
        token: token,
      );

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

  /// UPLOAD PROFILE PHOTO
  Future<(bool, dynamic)> uploadProfilePhoto({
    required String token,
    required File imageFile,
  }) async {

    _isLoading = true;
    notifyListeners();

    try {

      final res =
          await ProfileService.uploadProfilePhoto(
        token: token,
        imageFile: imageFile,
      );

      if (res["msg"] != null) {
        return (true, res["msg"]);
      }

      return (false, "Upload failed");

    } catch (e) {

      return (false, "Error occurred");

    } finally {

      _isLoading = false;
      notifyListeners();
    }
  }


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

Future<(bool, dynamic)> uploadProfileImage({
  required String token,
}) async {
  if (_image == null) {
    return (false, "No image selected");
  }

  _isLoading = true;
  notifyListeners();

  try {
    final res = await ProfileService.uploadProfilePhoto(
      token: token,
      imageFile: _image!,
    );

    if (res["msg"] != null) {
      await getProfile(token: token); // 🔥 refresh profile
      return (true, res["msg"]);
    }

    return (false, "Upload failed");
  } catch (e) {
    return (false, "Error occurred");
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}




}