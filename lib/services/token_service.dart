import 'dart:convert';

import 'package:flutter/material.dart';

class TokenService {
  /// Checks whether the JWT token is expired.
  static bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');

      // A JWT must have 3 parts:
      // Header.Payload.Signature
      if (parts.length != 3) {
        return true;
      }

      final payload = parts[1];

      // JWT uses Base64Url encoding.
      final normalized = base64Url.normalize(payload);

      final decoded = utf8.decode(
        base64Url.decode(normalized),
      );

      final Map<String, dynamic> data =
          jsonDecode(decoded);

      final exp = data['exp'];

      if (exp == null) {
        return true;
      }

      final expiryDate =
          DateTime.fromMillisecondsSinceEpoch(
        exp * 1000,
      );

      final now = DateTime.now();

      debugPrint("TOKEN EXPIRY: $expiryDate");
      debugPrint("CURRENT TIME: $now");

      return now.isAfter(expiryDate);
    } catch (e) {
      debugPrint("TOKEN CHECK ERROR: $e");

      // If token cannot be decoded,
      // treat it as invalid.
      return true;
    }
  }

  /// Returns remaining time before token expires.
  static Duration? getRemainingTime(String token) {
    try {
      final parts = token.split('.');

      if (parts.length != 3) {
        return null;
      }

      final payload = parts[1];

      final normalized = base64Url.normalize(payload);

      final decoded = utf8.decode(
        base64Url.decode(normalized),
      );

      final Map<String, dynamic> data =
          jsonDecode(decoded);

      final exp = data['exp'];

      if (exp == null) {
        return null;
      }

      final expiryDate =
          DateTime.fromMillisecondsSinceEpoch(
        exp * 1000,
      );

      final remaining =
          expiryDate.difference(DateTime.now());

      return remaining.isNegative
          ? Duration.zero
          : remaining;
    } catch (e) {
      debugPrint("TOKEN REMAINING TIME ERROR: $e");
      return null;
    }
  }
}