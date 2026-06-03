// import 'dart:convert';

// import 'package:http/http.dart' as AppHttp;

// class TutorService {

//  static const String baseUrl = 'https://zindalearnbackend.onrender.com/api';
  

// Future<List<dynamic>> getTutorsByCourse(
//   String courseId,
//   String token,
// ) async {

//   final response = await AppHttp.get(
//     Uri.parse('$baseUrl/tuter/by-course/$courseId'),
//     headers: {
//       "Authorization": "Bearer ${token.trim()}",
//       "Content-Type": "application/json",
//     },
//   );

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

//   final response = await AppHttp.get(
//     Uri.parse('$baseUrl/tuter/$tutorId'),
//     headers: {
//       "Authorization": "Bearer ${token.trim()}",
//       "Content-Type": "application/json",
//     },
//   );

//   if (response.statusCode == 200) {

//     final data = jsonDecode(response.body);

//     return data["tuter"] ?? {};
//   }

//   throw Exception("Failed to load tutor details");
// }
// // Future<List<dynamic>> getTutors(String? courseId, String token) async {
// //   final url = courseId == null || courseId.isEmpty
// //       ? "$baseUrl/tuter/all"
// //       : "$baseUrl/tuter/by-course/$courseId";

// //   final response = await AppHttp.get(
// //     Uri.parse(url),
// //     headers: {
// //       "Authorization": "Bearer $token",
// //     },
// //   );

// //   return jsonDecode(response.body)["tuters"];
// // }
// // List<dynamic>? _cachedTutors;

// // Future<List<dynamic>> getTutors(
// //   String? courseId,
// //   String token,
// // ) async {

// //   if(_cachedTutors != null){
// //     return _cachedTutors!;
// //   }

// //   final url =
// //       courseId == null || courseId.isEmpty
// //       ? "$baseUrl/tuter/all"
// //       : "$baseUrl/tuter/by-course/$courseId";

// //   final response =
// //       await AppHttp.get(
// //         Uri.parse(url),
// //         headers:{
// //           "Authorization":"Bearer $token",
// //         },
// //       );

// //   final data =
// //       jsonDecode(response.body)["tuters"];

// //   _cachedTutors = data;

// //   return data;
// // }
// // Future<List<dynamic>> getTutors(
// //   String? courseId,
// //   String token,
// // ) async {

// //   final stopwatch = Stopwatch()..start();

// //   final url = courseId == null || courseId.isEmpty
// //       ? "$baseUrl/tuter/all"
// //       : "$baseUrl/tuter/by-course/$courseId";

// //   print("START API");

// //   final response = await AppHttp.get(
// //     Uri.parse(url),
// //     headers: {
// //       "Authorization":"Bearer $token",
// //     },
// //   );

// //   print(
// //     "API TIME: ${stopwatch.elapsed.inSeconds}s",
// //   );

// //   return jsonDecode(
// //     response.body,
// //   )["tuters"];
// // }
// Future<List<dynamic>> getTutors(
//     String? courseId,
//     String token,
// ) async {

//   final stopwatch = Stopwatch()..start();

//   final url =
//       courseId == null || courseId.isEmpty
//       ? "$baseUrl/tuter/all"
//       : "$baseUrl/tuter/by-course/$courseId";

//   print("CALLING API: $url");

//   final response = await AppHttp.get(
//     Uri.parse(url),

//     headers: {
//       "Authorization":"Bearer $token",
//     },
//   );

//   stopwatch.stop();

//   print(
//     "TUTOR API TIME: ${stopwatch.elapsed.inSeconds} sec"
//   );

//   if(response.statusCode==200){

//     return jsonDecode(response.body)["tuters"];
//   }

//   throw Exception("Tutor API Failed");
// }

// }