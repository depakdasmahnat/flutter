import 'package:intl/intl.dart';

class Validator {
  /// Name Validator.
  static String? nameValidator(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Name'} is required';
    }
    if (value.length < 3) {
      return '${fieldName ?? 'Name'} must be at least 3 characters long';
    }
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'Please enter a valid ${fieldName ?? 'name'}';
    }
    return null;
  }

  ///Full Name
  static String? fullNameValidator(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'First name'} is required';
    }
    if (value.length < 3) {
      return 'First name must be at least 3 characters.';
    }
    // final parts = value.split(' ');
    // if (parts.length < 2) {
    //   return 'Please enter your ${fieldName ?? 'full name'}';
    // }
    // for (var part in parts) {
    //   if (part.length < 2) {
    //     return 'Each word in your ${fieldName ?? 'full name'} must be at least 2 characters long';
    //   }
    //   if (!RegExp(r'^[a-zA-Z]+$').hasMatch(part)) {
    //     return 'Please enter a valid ${fieldName ?? 'full name'}';
    //   }
    // }
    return null;
  }

  ///last  Name
  // static String? lastNameValidator(String? value, [String? fieldName]) {
  //   if(value!.length<3){
  //     return 'Last name must be at least 3 characters.';
  //   }
  //   // final parts = value.split(' ');
  //   // if (parts.length < 2) {
  //   //   return 'Please enter your ${fieldName ?? 'full name'}';
  //   // }
  //   // for (var part in parts) {
  //   //   if (part.length < 2) {
  //   //     return 'Each word in your ${fieldName ?? 'full name'} must be at least 2 characters long';
  //   //   }
  //   //   if (!RegExp(r'^[a-zA-Z]+$').hasMatch(part)) {
  //   //     return 'Please enter a valid ${fieldName ?? 'full name'}';
  //   //   }
  //   // }
  //   return null;
  // }
  static String? flocationValidation(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Location'} is required';
    }
    if (value.length < 3) {
      return 'Location  must be at least 3 characters.';
    }

    return null;
  }

  /// UserName Validator.
  static String? userNameValidator(String? value, {int minLength = 3, int maxLength = 30}) {
    if (value?.isEmpty == true) {
      return 'Username is required';
    }

    final usernameRegExp = RegExp(r'^[a-z][a-z\d._]{1,28}[a-z\d]$');
    if (!usernameRegExp.hasMatch(value!)) {
      if (!RegExp(r'^[a-z]').hasMatch(value)) {
        return 'Username must start with a letter (a-z)';
      } else if (!RegExp(r'[a-z\d]$').hasMatch(value)) {
        return 'Username must end with a letter or a number';
      } else if (!RegExp(r'^[a-z][a-z\d._]*[a-z\d]$').hasMatch(value)) {
        return 'Username can only contain (a-z), (0-9), (.), (_)';
      } else if (value.length < minLength || value.length > maxLength) {
        return 'The username must be between $minLength and $maxLength characters long';
      } else {
        return 'Invalid username';
      }
    }

    return null;
  }

  /// Validates that a value is not null or empty.
  static String? requiredValidator(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Field'} is required';
    }
    return null;
  }

  /// Validates that an email has a valid format.
  static String? emailValidator(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Email'} is Required';
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Invalid ${fieldName ?? 'email'} format';
    }
    return null;
  }

  /// Validates that a value is a valid number format.
  static String? phoneNumberValidator(
    String? value,
    int limit, [
    String? fieldName,
  ]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'mobile no'} is required';
    }

    if (value.length < limit) {
      return 'Complete ${fieldName ?? 'mobile no'} is required';
    }

    if (int.tryParse(value) == null) {
      return 'Invalid ${fieldName ?? 'number'} format';
    }
    return null;
  }

  /// Validates that a value is a valid number format.
  static String? numberValidator(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Mobile no'} is required';
    }
    if (double.tryParse(value) == null) {
      return 'Invalid ${fieldName ?? 'mobile'} number';
    }
    return null;
  }

  /// Referral code validation .
  static String? referralValidator(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Referral code'} is required';
    }
    // if (double.tryParse(value) == null) {
    //   return 'Invalid referral code';
    // }
    return null;
  }

  /// Validates that a value is a valid alphanumeric format.
  static String? alphanumericValidator(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Value'} is required';
    }

    // Check if the value contains only alphanumeric characters
    if (!isAlphanumeric(value)) {
      return 'Invalid ${fieldName ?? 'alphanumeric'} format';
    }

    return null;
  }

  /// Helper function to check if a string contains only alphanumeric characters.
  static bool isAlphanumeric(String value) {
    final alphanumericRegExp = RegExp(r'^[a-zA-Z0-9]+$');
    return alphanumericRegExp.hasMatch(value);
  }

  /// Validates that a password is at least 8 characters long.
  static String? passwordValidator(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Password'} is required';
    }
    if (value.length < 8) {
      return '${fieldName ?? 'Password'} must be at least 8 characters long';
    }
    return null;
  }

  /// Validates a Strong password.
  static String? strongPasswordValidator(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Password'} is required.';
    }

    if (value.length < 8) {
      return '${fieldName ?? 'Password'} must be at least 8 characters long.';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return '${fieldName ?? 'Password'} must contain at least one uppercase letter.';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return '${fieldName ?? 'Password'} must contain at least one lowercase letter.';
    }

    if (!value.contains(RegExp(r'\d'))) {
      return '${fieldName ?? 'Password'} must contain at least one digit.';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return '${fieldName ?? 'Password'} must contain at least one special character.';
    }

    return null; // If all conditions are met, the password is strong.
  }

  /// Validates that two values match (typically used for password confirmation).
  static String? confirmPasswordValidator(String? value1, String? value2, [String? fieldName]) {
    if (value1 != value2) {
      return '${fieldName ?? 'Passwords'} do not match';
    }
    return null;
  }

  /// Validates that a value is a valid URL format.
  static String? urlValidator(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'URL'} is required';
    }
    if (!Uri.parse(value).isAbsolute) {
      return 'Invalid ${fieldName ?? 'URL'} format';
    }
    return null;
  }

  /// Validates that a value contains only numeric characters.
  static String? numericValidator(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Field'} is required';
    }
    final isNumeric = double.tryParse(value) != null;
    if (!isNumeric) {
      return '${fieldName ?? 'Field'} must contain only numeric characters';
    }
    return null;
  }

  /// Validates that a value contains only alphabetic characters.
  static String? alphaValidator(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Field'} is required';
    }
    final isAlpha = RegExp(r'^[a-zA-Z]+$').hasMatch(value);
    if (!isAlpha) {
      return '${fieldName ?? 'Field'} must contain only alphabetic characters';
    }
    return null;
  }

  /// Validates that a value is a valid date format.
  static String? dateValidator(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Date'} is required';
    }
    try {
      DateFormat.yMd().parseStrict(value);
    } catch (_) {
      return 'Invalid ${fieldName ?? 'date'} format';
    }
    return null;
  }

  /// guest login screen id no validation
  static String? idNo(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Number'} is required';
    }
    // if (double.tryParse(value) == null) {
    //   return 'Invalid ${fieldName ?? 'number'} format';
    // }
    return null;
  }
}
