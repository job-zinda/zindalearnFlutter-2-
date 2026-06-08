// import 'package:flutter/material.dart';

// import '../models/course_model.dart';
// import '../services/home_service.dart';

// class CourseProvider with ChangeNotifier {

//   final HomeService _service = HomeService();

//   bool _isLoading = false;

//   bool get isLoading => _isLoading;

//   List<CourseModel> _courses = [];

//   List<CourseModel> get courses => _courses;

//   Future<void> fetchCourses(
//     String categoryId,
//   ) async {

//     try {

//       _isLoading = true;

//       notifyListeners();

//       final response =
//           await _service.getCoursesByCategory(
//         categoryId,
//       );
//       // debugPrint(response.toString());

//       _courses = response
//           .map<CourseModel>(
//             (e) => CourseModel.fromJson(e),
//           )
//           .toList();

//     } catch (error) {

//       // debugPrint(
//       //   "Course Error: $error",
//       // );

//       rethrow;

//     } finally {

//       _isLoading = false;

//       notifyListeners();
//     }
//   }

//   void clearCourses() {

//     _courses.clear();

//     notifyListeners();
//   }
// }


import 'package:flutter/material.dart';

import '../models/course_model.dart';
import '../services/home_service.dart';

class CourseProvider with ChangeNotifier {
  final HomeService _service = HomeService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CourseModel> _courses = [];
  List<CourseModel> get courses => _courses;

  // 1. Add an error string to track network state messages
  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  Future<void> fetchCourses(
    String categoryId,
  ) async {
    try {
      _isLoading = true;
      _errorMessage = ""; // Reset error message on a fresh attempt
      notifyListeners();

      final response = await _service.getCoursesByCategory(categoryId);

      _courses = response
          .map<CourseModel>(
            (e) => CourseModel.fromJson(e),
          )
          .toList();

    } catch (error) {
      debugPrint("Course Fetching Error: $error");
      
      // 2. Save the error message instead of rethrowing it
      _errorMessage = error.toString().replaceAll("Exception: ", "");
      
      // Clear old courses if the fetch failed, so the user doesn't see outdated info
      _courses = []; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearCourses() {
    _courses.clear();
    _errorMessage = "";
    notifyListeners();
  }
}