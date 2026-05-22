import 'package:flutter/material.dart';
import '../services/feedback_services.dart';

class FeedbackProvider with ChangeNotifier {

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _allFeedback = [];

  List<Map<String, dynamic>> get allFeedback =>
      _allFeedback;

  /// =========================
  /// ALL USERS FEEDBACK
  /// HOME SCREEN
  /// =========================
  Future<void> fetchAllUsersFeedback(
      String token) async {

    _isLoading = true;
    notifyListeners();

    try {

      final res =
          await FeedbackService.getAllUsersFeedback(
              token);

      if (res["feedbacks"] != null) {

        _allFeedback =
            List<Map<String, dynamic>>.from(
                res["feedbacks"]);

      } else {

        _allFeedback = [];
      }

    } catch (e) {

      print("ALL FEEDBACK ERROR: $e");

      _allFeedback = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// =========================
  /// MY FEEDBACK
  /// SETTINGS SCREEN
  /// =========================
  Future<void> fetchMyFeedback(
      String token) async {

    _isLoading = true;
    notifyListeners();

    try {

      final res =
          await FeedbackService.getMyFeedback(
              token);

      if (res["feedback"] != null) {

        _allFeedback = [
          Map<String, dynamic>.from(
              res["feedback"])
        ];

      } else {

        _allFeedback = [];
      }

    } catch (e) {

      print("MY FEEDBACK ERROR: $e");

      _allFeedback = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// SEND
Future<bool> sendFeedback({
  required String token,
  required String message,
  required int rating,
}) async {

  try {

    final res = await FeedbackService.sendFeedback(
      token: token,
      message: message,
      rating: rating,
    );

    if (res != null) {

      await fetchMyFeedback(token);

      return true;
    }

    return false;

  } catch (e) {

    print("SEND FEEDBACK ERROR: $e");

    return false;
  }
}
  /// UPDATE
Future<bool> updateFeedback({
  required String token,
  required String id,
  required String message,
  required int rating,
}) async {

  final success = await FeedbackService.updateFeedback(
    token: token,
    id: id,
    message: message,
    rating: rating,
  );

  if (success) {
    await fetchMyFeedback(token);
  }

  return success;
}
  /// DELETE
Future<void> deleteFeedback({
  required String token,
  required String id,
}) async {

  try {

    await FeedbackService.deleteFeedback(
      token: token,
      id: id,
    );

    /// remove locally
    _allFeedback.removeWhere(
      (item) => item["_id"] == id,
    );

    notifyListeners();

  } catch (e) {

    print("DELETE ERROR: $e");
  }
}
}