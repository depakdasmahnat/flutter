import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticService {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
}
