// import 'package:flutter/material.dart';

// import '../models/banner_model.dart';
// import '../models/category_model.dart';
// import '../models/feedback_model.dart';
// import '../services/home_service.dart';

// class HomeProvider with ChangeNotifier {
//   final HomeService _service = HomeService();

//   bool isLoading = false;

//   List<BannerModel> banners = [];
//   List<CategoryModel> categories = [];
//   List<FeedbackModel> feedbacks = [];

//   bool _hasLoaded = false;

//   Future<void> fetchHomeData(String token) async {

//   if (_hasLoaded) return;

//   try {

//     isLoading = true;
//     notifyListeners();

//     /// BANNERS
//     try {

//       final bannerData = await _service.getBanners();

//       banners = bannerData
//           .map((e) => BannerModel.fromJson(e))
//           .toList();

//       notifyListeners();

//     } catch (e) {

//       debugPrint("Banner Error: $e");
//     }

//     /// CATEGORIES
//     try {

//       final categoryData =
//           await _service.getCategories();

//       categories = categoryData
//           .map((e) => CategoryModel.fromJson(e))
//           .toList();

//       notifyListeners();

//     } catch (e) {

//       debugPrint("Category Error: $e");
//     }

//     /// FEEDBACKS
//     try {

//       final feedbackData =
//           await _service.getFeedbacks(token);

//       feedbacks = feedbackData
//           .map((e) => FeedbackModel.fromJson(e))
//           .toList();

//       notifyListeners();

//     } catch (e) {

//       debugPrint("Feedback Error: $e");
//     }

//     _hasLoaded = true;

//   } catch (e) {

//     debugPrint("Home error: $e");

//   } finally {

//     isLoading = false;
//     notifyListeners();
//   }
// }

//   Future<void> refreshHomeData(String token) async {
//     _hasLoaded = false;
//     await fetchHomeData(token);
//   }
// }

import 'package:flutter/material.dart';

import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../services/home_service.dart';

class HomeProvider with ChangeNotifier {
  final HomeService _service = HomeService();

  bool isLoading = false;
  String? errorMessage;

  List<BannerModel> banners = [];
  List<CategoryModel> categories = [];

  bool _hasLoaded = false;

  bool get hasContent => banners.isNotEmpty || categories.isNotEmpty;

  Future<void> fetchHomeData(String token) async {
    if (_hasLoaded) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait<List<dynamic>>([
        _service.getBanners(),
        _service.getCategories(),
      ]);

      banners = results[0]
          .map((e) => BannerModel.fromJson(e))
          .toList();
      categories = results[1]
          .map((e) => CategoryModel.fromJson(e))
          .toList();

      _hasLoaded = true;
    } catch (e) {
      debugPrint("Home error: $e");
      errorMessage =
          "Could not load home data. The server may be waking up — pull to retry.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshHomeData(String token) async {
    _hasLoaded = false;
    banners = [];
    categories = [];
    await fetchHomeData(token);
  }
}
