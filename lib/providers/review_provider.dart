import 'package:flutter/material.dart';

import '../services/home_service.dart';

class ReviewProvider with ChangeNotifier {

  final HomeService _service =
      HomeService();

  bool _isLoading = false;

  bool get isLoading =>
      _isLoading;

  double _rating = 0;

  double get rating =>
      _rating;

  final TextEditingController
      reviewController =
      TextEditingController();

  /// UPDATE STAR
  void updateRating(
    double value,
  ) {

    _rating = value;

    notifyListeners();
  }

  /// SET OLD REVIEW
  void setExistingReview({

    required String review,

    required double rating,

  }) {

    reviewController.text =
        review;

    _rating = rating;

    notifyListeners();
  }

  /// ADD REVIEW
  Future<bool> submitReview({

    required String tutorId,

    required String token,

  }) async {

    if (_rating == 0 ||
        reviewController.text
            .trim()
            .isEmpty) {

      return false;
    }

    _isLoading = true;

    notifyListeners();

    try {

      final success =
          await _service
              .submitReview(

        tutorId: tutorId,

        token: token,

        rating: _rating,

        review:
            reviewController.text
                .trim(),
      );

      return success;

    } catch (e) {

      debugPrint(
        e.toString(),
      );

      return false;

    } finally {

      _isLoading = false;

      notifyListeners();
    }
  }

  /// UPDATE REVIEW
  Future<bool> updateReview({
  required String tutorId,
  required String reviewId,
  required String token,
}) async {

  _isLoading = true;
  notifyListeners();

  try {
    return await _service.updateReview(
      tutorId: tutorId,
      // reviewId: reviewId,
      token: token,
      rating: _rating,
      review: reviewController.text.trim(),
    );
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  /// CLEAR
  void clearReview() {

    _rating = 0;

    reviewController.clear();

    notifyListeners();
  }
}