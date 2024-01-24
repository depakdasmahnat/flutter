import '../services/database/local_database.dart';

class ApiConfig {
  ///API Configurations..

  static const domainName = 'https://api.gtp.proapp.in';
  static const String version = '/api/v1/';
  static const String baseUrl = '$domainName$version';
  static const String mapsBaseUrl = 'https://maps.googleapis.com/maps/api';

  static const String privacyPolicyUrl = '${baseUrl}privacy-policy';
  static const String aboutUsUrl = '${baseUrl}about-us';
  static const String contactUsUrl = '${baseUrl}contact-us';
  static const String supportUrl = '${baseUrl}support';

  static const String termsAndConditionsUrl = '${baseUrl}terms-conditions';

  static Map<String, String> defaultHeaders() {
    return {'Authorization': 'Bearer ${LocalDatabase().accessToken}'};
  }
}

class ApiEndpoints {
  ///API EndPoints..

  //1) Auth APIs...
  static const String validateMobile = 'validate_mobile';
  static const String sendOtp = 'send_otp';
  static const String verifyOtp = 'verify_otp';
  static const String fetchCategories = 'fetch_categories?type=';
  static const String fetchQuestions = 'fetch_interest_questions?category_id=';
  static const String submitGuestInterest = 'submit_guest_interest';

/// Geust Apis....
   static const String fetchJoiners = 'fetch_new_joinees';

/// Common  Apis....
    static const String fetchBanner = 'fetch_banners';
}
