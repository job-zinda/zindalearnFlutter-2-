import 'dart:io';

import 'package:flutter/material.dart';
import '../services/profile_service.dart';

class ProfileProvider with ChangeNotifier {

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Map<String, dynamic>? _profileData;

  Map<String, dynamic>? get profileData => _profileData;

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
}