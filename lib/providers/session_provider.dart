import 'package:flutter/material.dart';

import '../models/session_model.dart';
import '../services/home_service.dart';

class SessionProvider with ChangeNotifier {
  final HomeService _service = HomeService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<SessionModel> _sessions = [];

  List<SessionModel> get sessions => _sessions;

  Future<void> fetchSessions(String categoryId) async {
    try {
      _isLoading = true;

      notifyListeners();

      final response = await _service.getSessionsByCategory(categoryId);

      _sessions = response
          .map<SessionModel>((e) => SessionModel.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }
}
