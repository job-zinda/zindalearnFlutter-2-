class Validators {

  static String? required(
      String? value,
      String field,
      ) {

    if (value == null ||
        value.trim().isEmpty) {

      return "$field is required";
    }

    return null;
  }

  static String? email(String? value) {

    if (value == null ||
        value.trim().isEmpty) {

      return "Email is required";
    }

    final emailRegex =
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailRegex.hasMatch(
        value.trim(),
    )) {

      return
      "Enter a valid email address";
    }

    return null;
  }

  static String? password(
      String? value,
      ) {

    if (value == null ||
        value.trim().isEmpty) {

      return "Password is required";
    }

    if (value.length < 6) {

      return
      "Password must be at least 6 characters";
    }

    if (value.length > 20) {

      return
      "Password must be less than 20 characters";
    }

    return null;
  }

  static String? confirmPassword(
      String? value,
      String password,
      ) {

    if (value == null ||
        value.trim().isEmpty) {

      return
      "Confirm password is required";
    }

    if (value.trim() !=
        password.trim()) {

      return
      "Passwords do not match";
    }

    return null;
  }

  static String? phone(String? value) {

    if (value == null ||
        value.trim().isEmpty) {

      return
      "Phone number is required";
    }

    final normalized =
    value.trim().replaceAll(' ', '');

    if (!RegExp(
        r'^\d{10}$',
    ).hasMatch(normalized)) {

      return
      "Enter a valid 10 digit phone number";
    }

    return null;
  }
}