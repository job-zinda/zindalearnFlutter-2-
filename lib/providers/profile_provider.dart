
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// import '../services/profile_service.dart';

// class ProfileProvider with ChangeNotifier {
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   Map<String, dynamic>? _profileData;
//   Map<String, dynamic>? get profileData => _profileData;

//   final ImagePicker _picker = ImagePicker();

//   File? _image;
//   File? get image => _image;

//   // ===================== GET PROFILE =====================
//   Future<(bool, dynamic)> getProfile({required String token}) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final res = await ProfileService.getProfile(token: token);

//       if (res["user"] != null) {
//         _profileData = res["user"];
//          print(
//     "PROFILE PHOTO: ${_profileData?["photo"]}",
//   );

//         if (_profileData != null &&
//             _profileData!["photo"] != null &&
//             _profileData!["photo"].toString().startsWith('http')) {
//           String originalUrl = _profileData!["photo"].toString();
//           if (originalUrl.contains('?v=')) {
//             originalUrl = originalUrl.split('?v=')[0];
//           }

//           //  THE MAGIC BULLET FIX: Evict both the raw URL and any current variants
//           // from Flutter's internal image engine cache memory.
//           await NetworkImage(originalUrl).evict();
//           if (_profileData!["photo"] != null) {
//             await NetworkImage(_profileData!["photo"].toString()).evict();
//           }

//           // Force a completely fresh timestamp token link
//           _profileData!["photo"] =
//               "$originalUrl?v=${DateTime.now().millisecondsSinceEpoch}";
//         }

//         return (true, res);
//       }

//       return (false, res["msg"] ?? "Failed");
//     } catch (e) {
//       return (false, "Error occurred");
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // ===================== UPDATE PROFILE =====================


// Future<(bool, dynamic)> updateProfile({
//   required String token,
//   required String name,
//   required String phone,
// }) async {
//   _isLoading = true;
//   notifyListeners();

//   try {
//     String? localFilePath;

//     if (_image != null) {
//       print("IMAGE SELECTED");
//       // Get the direct file system path instead of converting to base64
//       localFilePath = _image!.path;
//       print("IMAGE LOCAL PATH: $localFilePath");
//     } else {
//       print("NO IMAGE SELECTED");
//     }

   
//     final res = await ProfileService.updateProfile(
//       token: token,
//       name: name,
//       phone: phone,
//       filePath: localFilePath, // Passing the local path string here
//     );

   

   
//     if (res["user"] != null || res["msg"] == "Profile updated successfully") {
     
//       await getProfile(token: token);

//       return (true, res["msg"] ?? "Profile updated successfully");
//     }

//     return (false, res["msg"] ?? "Update failed");
//   } catch (e) {
  
//     return (false, "Error occurred");
//   } finally {
//     _isLoading = false;
//     notifyListeners();
//   }
// }
//   // ===================== DELETE ACCOUNT =====================
//   Future<(bool, dynamic)> deleteAccount({required String token}) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final res = await ProfileService.deleteAccount(token: token);

//       if (res["msg"] != null) {
//         return (true, res["msg"]);
//       }

//       return (false, "Delete failed");
//     } catch (e) {
//       return (false, "Error occurred");
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // ===================== PICK IMAGE (OPTIONAL) =====================
//   Future<void> pickImageFromGallery() async {
//     final picked = await _picker.pickImage(source: ImageSource.gallery);

//     if (picked != null) {
//       _image = File(picked.path);
//       notifyListeners();
//     }
//   }

//   Future<void> pickImageFromCamera() async {
//     final picked = await _picker.pickImage(source: ImageSource.camera);

//     if (picked != null) {
//       _image = File(picked.path);
//       notifyListeners();
//     }
//   }

//   void clearImage() {
//     _image = null;
//     notifyListeners();
//   }
// }


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
  Future<(bool, dynamic)> getProfile({required String token}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await ProfileService.getProfile(token: token);

      if (res["user"] != null) {
        _profileData = res["user"];

        if (_profileData != null &&
            _profileData!["photo"] != null &&
            _profileData!["photo"].toString().startsWith('http')) {
          String originalUrl = _profileData!["photo"].toString();
          if (originalUrl.contains('?v=')) {
            originalUrl = originalUrl.split('?v=')[0];
          }

          // Evict both the raw URL and any current variants from Flutter's internal image cache memory.
          await NetworkImage(originalUrl).evict();
          if (_profileData!["photo"] != null) {
            await NetworkImage(_profileData!["photo"].toString()).evict();
          }

          // Force a completely fresh timestamp token link to bypass aggressive image cache
          _profileData!["photo"] =
              "$originalUrl?v=${DateTime.now().millisecondsSinceEpoch}";
        }

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
      String? localFilePath;

      if (_image != null) {
        localFilePath = _image!.path;
      }

      final res = await ProfileService.updateProfile(
        token: token,
        name: name,
        phone: phone,
        filePath: localFilePath,
      );

      if (res["user"] != null || res["msg"] == "Profile updated successfully") {
        await getProfile(token: token);
        return (true, res["msg"] ?? "Profile updated successfully");
      }

      return (false, res["msg"] ?? "Update failed");
    } catch (e) {
      return (false, "Error occurred");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===================== DELETE ACCOUNT =====================
  Future<(bool, dynamic)> deleteAccount({required String token}) async {
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

  // ===================== PICK IMAGE =====================
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