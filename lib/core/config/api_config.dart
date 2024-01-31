import '../constant/enums.dart';
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
    LocalDatabase localDatabase = LocalDatabase();
    String? userRole = localDatabase.userRole;
    String? accessToken;
    if (userRole == UserRoles.guest.value) {
      accessToken = localDatabase.guest?.accessToken;
    } else if (userRole == UserRoles.member.value) {
      accessToken = localDatabase.member?.accessToken;
    }

    return {'Authorization': 'Bearer $accessToken'};
  }
}

class ApiEndpoints {
  ///API EndPoints..

  //1) Auth APIs...
  static const String validateMobile = 'validate_mobile';

  //11) Member Auth APIs...

  static const String login = 'login';
  static const String forgotPassword = 'forgot_password';
  static const String resetPassword = 'reset_password';
  static const String fetchProfile = 'fetch_profile';
  static const String treeView = 'tree_view';
  static const String pinnacleView = 'pinnacle_view';
  static const String selectABMember = 'select_A_B_members';
  static const String deleteUser = 'deleteUser';
  static const String sendOtp = 'send_otp';
  static const String verifyOtp = 'verify_otp';
  static const String fetchCategories = 'fetch_categories?type=';
  static const String fetchFeeds = 'fetch_feeds';
  static const String feedLike = 'feed_like';
  static const String feedUnLike = 'feed_unlike';

  static const String viewFeed = 'view_feed';
  static const String fetchQuestions = 'fetch_interest_questions?category_id=';
  static const String submitGuestInterest = 'submit_guest_interest';
  static const String updateLeadStatus = 'update_lead_status';
  static const String updateLeadPriority = 'update_lead_priority';
  static const String demoDone = 'demo_done';
  static const String fetchDemos = 'fetch_demos';

  static const String scheduledDemo = 'schedule_demo';

  // Lead apis
  static const String fetchLead = 'fetch_leads?';

  /// Guest Apis....
  static const String fetchJoiners = 'fetch_new_joinees';
  static const String fetchProduct = 'fetch_products?page=';
  static const String fetchProductDetail = 'fetch_product_details?product_id=';
  static const String fetchResources = 'fetch_resources';
  static const String fetchFeedCategories = 'fetch_feed_categories';
  static const String getComments = 'get_comments';
  static const String feedComment = 'feed_comment';
  static const String fetchResourceDetails = 'fetch_resources?page=1&category_id=';
  static const String editProfile = 'edit_profile';
  static const String fetchFaqs = 'fetch_faqs?category=';

  /// Common  Apis....
  static const String fetchBanner = 'fetch_banners';
  static const String state = 'fetch_states';
  static const String city = 'fetch_cities?state_id=';
  static const String fetchGuestProfile = 'fetch_profile';
}
