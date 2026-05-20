class ApiConstants {

  static const String baseUrl =
      'https://zindalearnbackend.onrender.com/api/';

  static const String login =
      '${baseUrl}login_user';

  static const String register =
      '${baseUrl}register';

  static const String forgotPassword =
      '${baseUrl}user_forgoat_password_send_otp';

  static const String verifyOtp =
      '${baseUrl}user_forgoat_password_verify_otp';

  static const String resetPassword =
      '${baseUrl}user_reset_password';
}