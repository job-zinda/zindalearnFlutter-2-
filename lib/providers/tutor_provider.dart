
import 'package:flutter/material.dart';

import '../models/tutor_model.dart';
import '../services/home_service.dart';

class TutorProvider with ChangeNotifier {
  final HomeService _service = HomeService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<TutorModel> _tutors = [];

  List<TutorModel> get tutors => _tutors;
  final String baseUrl = "https://zindalearnbackend.onrender.com/api";


Future<void> fetchTutors(String? courseId, String token) async {
  try {
    _isLoading = true;
    notifyListeners();

    final response = await _service.getTutors(courseId, token);

    _tutors = response
        .map<TutorModel>((e) => TutorModel.fromJson(e))
        .toList();

  } catch (e) {
    debugPrint("Tutor Error: $e");
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
}
