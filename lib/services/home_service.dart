// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class HomeService {
//   static const String baseUrl = 'https://zindalearnbackend.onrender.com/api';

//   /// BANNERS
//   Future<List<dynamic>> getBanners() async {
//     final response = await http.get(Uri.parse('$baseUrl/banner/all'));

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);

//       return data["banners"] ?? [];
//     }

//     throw Exception("Failed to load banners");
//   }

//   /// CATEGORIES
//   Future<List<dynamic>> getCategories() async {
//     final response = await http.get(Uri.parse('$baseUrl/category/all'));

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);

//       return data["categories"] ?? [];
//     }

//     throw Exception("Failed to load categories");
//   }

//   Future<List<dynamic>> getFeedbacks(String token) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/get/feedback/all'),

//       headers: {"Authorization": "Bearer $token", "token": token},
//     );

//     print("STATUS CODE: ${response.statusCode}");
//     print("BODY: ${response.body}");

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);

//       return data["data"] ?? [];
//     }

//     throw Exception("Failed to load feedbacks: ${response.statusCode}");
//   }

//   /// GET COURSES BY CATEGORY
//   Future<List<dynamic>> getCoursesByCategory(String categoryId) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/course/by-category/$categoryId'),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);

//       return data["courses"] ?? [];
//     }

//     throw Exception("Failed to load courses");
//   }

// Future<List<dynamic>> getSessionsByCategory(
//   String categoryId,
// ) async {

//   final courses =
//       await getCoursesByCategory(categoryId);

//   final oneToOneCourses =
//       courses.where((course) {

//     final name =
//         course["name"]
//             .toString()
//             .toLowerCase();

//     return name.contains("class");

//   }).toList();

//   final groupCourses =
//       courses.where((course) {

//     final name =
//         course["name"]
//             .toString()
//             .toLowerCase();

//     return !name.contains("class");

//   }).toList();

//   return [

//     {
//       "_id": "1",

//       "title": "One to One Session",

//       "courses": oneToOneCourses,
//     },

//     {
//       "_id": "2",

//       "title": "Group / Batch Session",

//       "courses": groupCourses,
//     },
//   ];
// }

// Future<List<dynamic>> getTutorsByCourse(
//   String courseId,
//   String token,
// ) async {

//   print("TOKEN: $token");

//   final response = await http.get(

//     Uri.parse('$baseUrl/tuter/by-course/$courseId'),

//     headers: {
//       "Authorization": "Bearer ${token.trim()}",
//       "Content-Type": "application/json",
//     },
//   );

//   print("STATUS: ${response.statusCode}");
//   print("BODY: ${response.body}");

//   if (response.statusCode == 200) {

//     final data = jsonDecode(response.body);

//     return data["tuters"] ?? [];
//   }

//   throw Exception("Failed to load tutors");
// }
// Future<Map<String, dynamic>> getTutorDetails(
//   String tutorId,
//   String token,
// ) async {

//   final response = await http.get(

//     Uri.parse(
//       '$baseUrl/tuter/$tutorId',
//     ),

//     headers: {
//       "Authorization": "Bearer ${token.trim()}",
//       "Content-Type": "application/json",
//     },
//   );

//   print("DETAIL STATUS: ${response.statusCode}");
//   print("DETAIL BODY: ${response.body}");

//   if (response.statusCode == 200) {

//     final data = jsonDecode(response.body);

//     return data["tuter"] ?? {};
//   }

//   throw Exception("Failed to load tutor details");
// }
// Future<List<dynamic>> getTutors(String? courseId, String token) async {
//   final url = courseId == null || courseId.isEmpty
//       ? "$baseUrl/tuter/all"
//       : "$baseUrl/tuter/by-course/$courseId";

//   final response = await http.get(
//     Uri.parse(url),
//     headers: {
//       "Authorization": "Bearer $token",
//     },
//   );

//   return jsonDecode(response.body)["tuters"];
// }

// /// ADD REVIEW
// Future<bool> submitReview({

//   required String tutorId,

//   required String token,

//   required double rating,

//   required String review,

// }) async {

//   try {

//     final response =
//         await http.post(

//       Uri.parse(
//         "https://zindalearnbackend.onrender.com/api/tuter/$tutorId/review",
//       ),

//       headers: {

//         "Authorization":
//             "Bearer $token",

//         "Content-Type":
//             "application/json",
//       },

//       body: jsonEncode({

//         "rating": rating,

//         "review": review,
//       }),
//     );

//     debugPrint(response.body);

//     return response.statusCode ==
//             200 ||
//         response.statusCode ==
//             201;

//   } catch (e) {

//     debugPrint(e.toString());

//     return false;
//   }
// }
// /// UPDATE REVIEW
// Future<bool> updateReview({
//   required String tutorId,
//   required String token,
//   required double rating,
//   required String review,
// }) async {

//   final response = await http.post(
//     Uri.parse(
//       "https://zindalearnbackend.onrender.com/api/tuter/$tutorId/review",
//     ),
//     headers: {
//       "Authorization": "Bearer $token",
//       "Content-Type": "application/json",
//     },
//     body: jsonEncode({
//       "rating": rating,
//       "review": review,
//     }),
//   );

//   debugPrint(response.body);

//   return response.statusCode == 200 || response.statusCode == 201;
// }
// Future<bool> deleteReview({
//   required String tutorId,
//   required String token,
// }) async {

//   final response = await http.delete(
//     Uri.parse(
//       "https://zindalearnbackend.onrender.com/api/tuter/$tutorId/review",
//     ),
//     headers: {
//       "Authorization": "Bearer $token",
//     },
//   );

//   return response.statusCode == 200;
// }


// }
import 'dart:convert';
import 'package:flutter/material.dart';

import '../core/network/http_client.dart';

class HomeService {
  static const String baseUrl = 'https://zindalearnbackend.onrender.com/api';

  /// BANNERS
  Future<List<dynamic>> getBanners() async {
    final response = await AppHttp.get(Uri.parse('$baseUrl/banner/all'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["banners"] ?? [];
    }

    throw Exception("Failed to load banners");
  }

  /// CATEGORIES
  Future<List<dynamic>> getCategories() async {
    final response = await AppHttp.get(Uri.parse('$baseUrl/category/all'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["categories"] ?? [];
    }

    throw Exception("Failed to load categories");
  }

  Future<List<dynamic>> getFeedbacks(String token) async {
    final response = await AppHttp.get(
      Uri.parse('$baseUrl/get/feedback/all'),
      headers: {"Authorization": "Bearer $token", "token": token},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["data"] ?? [];
    }

    throw Exception("Failed to load feedbacks: ${response.statusCode}");
  }

  /// GET COURSES BY CATEGORY
  Future<List<dynamic>> getCoursesByCategory(String categoryId) async {
    final response = await AppHttp.get(
      Uri.parse('$baseUrl/course/by-category/$categoryId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["courses"] ?? [];
    }

    throw Exception("Failed to load courses");
  }

Future<List<dynamic>> getSessionsByCategory(
  String categoryId,
) async {

  final courses =
      await getCoursesByCategory(categoryId);

  final oneToOneCourses =
      courses.where((course) {

    final name =
        course["name"]
            .toString()
            .toLowerCase();

    return name.contains("class");

  }).toList();

  final groupCourses =
      courses.where((course) {

    final name =
        course["name"]
            .toString()
            .toLowerCase();

    return !name.contains("class");

  }).toList();

  return [

    {
      "_id": "1",

      "title": "One to One Session",

      "courses": oneToOneCourses,
    },

    {
      "_id": "2",

      "title": "Group / Batch Session",

      "courses": groupCourses,
    },
  ];
}

Future<List<dynamic>> getTutorsByCourse(
  String courseId,
  String token,
) async {

  final response = await AppHttp.get(
    Uri.parse('$baseUrl/tuter/by-course/$courseId'),
    headers: {
      "Authorization": "Bearer ${token.trim()}",
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {

    final data = jsonDecode(response.body);

    return data["tuters"] ?? [];
  }

  throw Exception("Failed to load tutors");
}
Future<Map<String, dynamic>> getTutorDetails(
  String tutorId,
  String token,
) async {

  final response = await AppHttp.get(
    Uri.parse('$baseUrl/tuter/$tutorId'),
    headers: {
      "Authorization": "Bearer ${token.trim()}",
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {

    final data = jsonDecode(response.body);

    return data["tuter"] ?? {};
  }

  throw Exception("Failed to load tutor details");
}
Future<List<dynamic>> getTutors(String? courseId, String token) async {
  final url = courseId == null || courseId.isEmpty
      ? "$baseUrl/tuter/all"
      : "$baseUrl/tuter/by-course/$courseId";

  final response = await AppHttp.get(
    Uri.parse(url),
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  return jsonDecode(response.body)["tuters"];
}

/// ADD REVIEW
Future<bool> submitReview({

  required String tutorId,

  required String token,

  required double rating,

  required String review,

}) async {

  try {

    final response = await AppHttp.post(
      Uri.parse(
        "https://zindalearnbackend.onrender.com/api/tuter/$tutorId/review",
      ),

      headers: {

        "Authorization":
            "Bearer $token",

        "Content-Type":
            "application/json",
      },

      body: jsonEncode({

        "rating": rating,

        "review": review,
      }),
    );

    debugPrint(response.body);

    return response.statusCode ==
            200 ||
        response.statusCode ==
            201;

  } catch (e) {

    debugPrint(e.toString());

    return false;
  }
}
/// UPDATE REVIEW
Future<bool> updateReview({
  required String tutorId,
  required String token,
  required double rating,
  required String review,
}) async {

  final response = await AppHttp.post(
    Uri.parse(
      "https://zindalearnbackend.onrender.com/api/tuter/$tutorId/review",
    ),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "rating": rating,
      "review": review,
    }),
  );

  return response.statusCode == 200 || response.statusCode == 201;
}
Future<bool> deleteReview({
  required String tutorId,
  required String token,
}) async {

  final response = await AppHttp.delete(
    Uri.parse(
      "https://zindalearnbackend.onrender.com/api/tuter/$tutorId/review",
    ),
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  return response.statusCode == 200;
}


}
