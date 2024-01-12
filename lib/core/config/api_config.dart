import '../services/database/local_database.dart';

class ApiConfig {
  ///API Configurations..

  static const domainName = 'https://api.emuvv.proapp.in';
  static const String version = '/api/v1';
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
  static const String sendOtp = '/send-otp';
  static const String verifyOtp = '/verify-otp';
  static const String register = '/register';
  static const String registerVehicle = '/register-vehicle';
  static const String updateVehicle = '/vehicle-edit';

  static String myVehicles = '/my-vehicle';

  static String fetchProfile = '/profile';

  static const String editProfile = '/edit-profile';

  static const String verifyEmail = '/email';
  static const String emailRegister = '/email-register';
  static const String registerEmailVehicle = '/email-register-vehicle';
  static const String verifyPassword = '/verify-password';

  //2) Get Vehicles APIs...

  static const String cars = '/data/car-list';
  static const String bikes = '/data/bike-list';
  static const String carBrands = '/data/car-brands-list';
  static const String bikeBrands = '/data/bike-brands-list';
}
