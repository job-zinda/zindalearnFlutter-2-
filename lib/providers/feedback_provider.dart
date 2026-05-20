import 'package:flutter/material.dart';
import 'package:zindaonlineschool/services/feedback_services.dart';

class FeedbackProvider with ChangeNotifier {

  bool _isLoading = false;
  bool get isLoading => _isLoading;
List<Map<String, dynamic>> _allFeedback = [];
List<Map<String, dynamic>> get allFeedback => _allFeedback;

Future<void> fetchAllFeedback(String token) async {
  _isLoading = true;
  notifyListeners();

  try {
    final res = await FeedbackService.getAllFeedback(token);

    if (res["feedbacks"] != null) {
      _allFeedback =
          List<Map<String, dynamic>>.from(res["feedbacks"]);
    } else {
      _allFeedback = [];
    }

  } catch (e) {
    print("ERROR: $e");
    _allFeedback = [];
  }

  _isLoading = false;
  notifyListeners();
}
}