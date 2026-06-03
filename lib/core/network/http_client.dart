// import 'package:http/http.dart' as http;

// /// Shared HTTP helpers with timeouts so the UI does not hang forever.
// class AppHttp {
//   static const Duration timeout = Duration(seconds: 90);

//   static Future<http.Response> get(
//     Uri url, {
//     Map<String, String>? headers,
//   }) {
//     return http.get(url, headers: headers).timeout(timeout);
//   }

//   static Future<http.Response> post(
//     Uri url, {
//     Map<String, String>? headers,
//     Object? body,
//   }) {
//     return http
//         .post(url, headers: headers, body: body)
//         .timeout(timeout);
//   }

//   static Future<http.Response> delete(
//     Uri url, {
//     Map<String, String>? headers,
//   }) {
//     return http.delete(url, headers: headers).timeout(timeout);
//   }
// }

import 'dart:async';
import 'package:http/http.dart' as http;

class AppHttp {

  static const Duration timeoutDuration =
      Duration(seconds: 90);

  static Future<http.Response> get(
    Uri url, {
    Map<String,String>? headers,
  }) async {

    return await http
        .get(
          url,
          headers: headers,
        )
        .timeout(timeoutDuration);
  }

  static Future<http.Response> post(
    Uri url,{
    Map<String,String>? headers,
    Object? body,
  }) async {

    return await http
        .post(
          url,
          headers: headers,
          body: body,
        )
        .timeout(timeoutDuration);
  }

  static Future<http.Response> put(
    Uri url,{
    Map<String,String>? headers,
    Object? body,
  }) async {

    return await http
        .put(
          url,
          headers: headers,
          body: body,
        )
        .timeout(timeoutDuration);
  }

  static Future<http.Response> delete(
    Uri url,{
    Map<String,String>? headers,
  }) async {

    return await http
        .delete(
          url,
          headers: headers,
        )
        .timeout(timeoutDuration);
  }
}