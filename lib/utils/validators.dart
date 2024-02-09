import 'package:intl/intl.dart';

class Validator {
  /// Validates that a value is not null or empty.
  static String? requiredValidator(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates that an email has a valid format.
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is Required';
    }
    if (!RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  /// Validates that a value is a valid number format.
  static String? numberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number is required';
    }
    if (double.tryParse(value) == null) {
      return 'Invalid number format';
    }
    return null;
  }

  static String? validateUSAPhoneNumber(String? value) {
    final phoneNumberPattern = RegExp(r'^\(\d{3}\) \d{3}-\d{4}$');

    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    } else if (!phoneNumberPattern.hasMatch(value)) {
      return 'Invalid phone number format. Eg (123) 456-7890';
    }

    return null; // Return null if the input is valid.
  }

  static String? extractNumbersFromString(String? input) {
    if (input == null) {
      return null; // Handle null input gracefully.
    }

    final RegExp regex = RegExp(r'\d+');
    final Iterable<Match> matches = regex.allMatches(input);
    final List<String> numbers = matches.map((match) => match.group(0)!).toList();

    return numbers.isNotEmpty ? numbers.join('') : null;
  }

  /// Validates Sales Price is not grater then Mrp Price.
  static String? validatePrices(String salesPrice, String mrpPrice) {
    if (mrpPrice.isEmpty) {
      return 'Mrp price is Required';
    } else if (salesPrice.isEmpty) {
      return 'Sales price is Required';
    }

    double sales, mrp;
    try {
      sales = double.parse(salesPrice);
      mrp = double.parse(mrpPrice);
    } catch (e) {
      return 'Error parsing price';
    }

    if (sales > mrp) {
      return 'Sales price cannot be greater than MRP price';
    }

    return null;
  }

  /// Validates that a password is at least 8 characters long.
  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  /// Validates that two values match (typically used for password confirmation).
  static String? confirmPasswordValidator(String? value1, String? value2) {
    if (value1 != value2) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateRegexPassword(String? password) {
    if (password == null) {
      return "Password cannot be null.";
    }

    // Define the regular expressions for each requirement
    RegExp capitalRegex = RegExp(r'[A-Z]');
    RegExp smallRegex = RegExp(r'[a-z]');
    RegExp numericRegex = RegExp(r'[0-9]');
    RegExp specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    // Check the length of the password
    if (password.length < 8) {
      return "Password should have at least 8 characters.";
    }

    // Check for the presence of each requirement
    if (!capitalRegex.hasMatch(password)) {
      return "Password should have at least one capital letter.";
    }
    if (!smallRegex.hasMatch(password)) {
      return "Password should have at least one small letter.";
    }
    if (!numericRegex.hasMatch(password)) {
      return "Password should have at least one numeric letter.";
    }
    if (!specialCharRegex.hasMatch(password)) {
      return "Password should have at least one special character.";
    }

    // If all requirements are met, return null (no error message)
    return null;
  }

  /// Validates that a value is a valid URL format.
  static String? urlValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }
    if (!Uri.parse(value).isAbsolute) {
      return 'Invalid URL format';
    }
    return null;
  }

  /// Validates that a value contains only numeric characters.
  static String? numericValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field is required';
    }
    final isNumeric = double.tryParse(value) != null;
    if (!isNumeric) {
      return 'Field must contain only numeric characters';
    }
    return null;
  }

  /// Validates that a value contains only numeric characters.
  static String? otpValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }

    final isNumeric = int.tryParse(value) != null;
    if (!isNumeric) {
      return 'OTP must contain only numeric values';
    }

    return null;
  }

  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field is required';
    }
    final hasNumbers = RegExp(r'\d').hasMatch(value);
    if (hasNumbers) {
      return 'Field must not contain numbers';
    }
    return null;
  }

  /// Validates that a value contains only alphabetic characters.
  static String? alphaValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field is required';
    }
    final isAlpha = RegExp(r'^[a-zA-Z]+$').hasMatch(value);
    if (!isAlpha) {
      return 'Field must contain only alphabetic characters';
    }
    return null;
  }

  /// Validates that a value contains only alphanumeric characters.
  static String? alphaNumericValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field is required';
    }
    final isAlphaNumeric = RegExp(r'^[a-zA-Z\d]+$').hasMatch(value);
    if (!isAlphaNumeric) {
      return 'Field must contain only alphanumeric characters';
    }
    return null;
  }

  /// Validates that a value is a valid date format (yyyy-MM-dd).
  static String? dateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }

    final format = DateFormat('yyyy-MM-dd');
    try {
      format.parse(value);
      return null;
    } catch (e) {
      return 'Invalid date format. Please use yyyy-MM-dd format';
    }
  }

  /// Validates that SSN is Valid.

  static String? validateSSN(String? value) {
    // Define the regular expression pattern for SSN validation
    final ssnPattern = RegExp(r"^(?!000|666|9\d\d)\d{3}(-)?\d{2}(-)\d{4}$");

    if (value == null || value.isEmpty) {
      return "SSN Number is Required";
    }

    // Check if the SSN matches the pattern
    if (ssnPattern.hasMatch(value)) {
      return null; // Valid SSN
    } else {
      return "Invalid SSN";
    }
  }

  ///Validate federal tax identification number (TIN)
  static String? validateTIN(String? value) {
    // Define the regular expression pattern for EIN validation
    final einPattern = RegExp(r"^\d{3}-\d{2}-\d{4}$");
    if (value?.isEmpty == true) {
      return "Federal Tax Number is Required";
    }
    // Check if the TIN matches the EIN pattern
    if (einPattern.hasMatch(value!)) {
      return null;
    } else {
      return "Invalid TIN";
    }
  }
}
