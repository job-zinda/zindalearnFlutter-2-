import 'package:flutter/material.dart';

import '../models/course_model.dart';
import '../services/home_service.dart';

class CourseProvider with ChangeNotifier {

  final HomeService _service = HomeService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<CourseModel> _courses = [];

  List<CourseModel> get courses => _courses;

  Future<void> fetchCourses(
    String categoryId,
  ) async {

    try {

      _isLoading = true;

      notifyListeners();

      final response =
          await _service.getCoursesByCategory(
        categoryId,
      );
      debugPrint(response.toString());

      _courses = response
          .map<CourseModel>(
            (e) => CourseModel.fromJson(e),
          )
          .toList();

    } catch (error) {

      debugPrint(
        "Course Error: $error",
      );

      rethrow;

    } finally {

      _isLoading = false;

      notifyListeners();
    }
  }

  void clearCourses() {

    _courses.clear();

    notifyListeners();
  }
}