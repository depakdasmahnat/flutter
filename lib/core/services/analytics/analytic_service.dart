import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnalyticService {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  static trackScreen({
    required GoRouterState state,
  }) {
    debugPrint('Screen => ${state.name}');
    if (state.name != null) {
      logScreenView(screenName: state.name);
      setCurrentScreen(screenName: state.name);
    }
  }

  static void logScreenView({
    String? screenClass,
    String? screenName,
    AnalyticsCallOptions? callOptions,
  }) {
    analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
      callOptions: callOptions,
    );
  }

  static void setCurrentScreen({
    required String? screenName,
    AnalyticsCallOptions? callOptions,
  }) {
    analytics.setCurrentScreen(
      screenName: screenName,
      callOptions: callOptions,
    );
  }

  static void trackButtonClicked(String buttonName) {
    analytics.logEvent(
      name: 'button_clicked',
      parameters: {'button_name': buttonName},
    );
  }

  static logEvent({
    required String event,
    Map<String, Object?>? parameters,
    AnalyticsCallOptions? callOptions,
  }) {
    analytics.logEvent(
      name: event,
      parameters: parameters,
      callOptions: callOptions,
    );
  }

  static void setUserSubscriptionStatus(String status) {
    analytics.setUserProperty(
      name: 'subscription_status',
      value: status,
    );
  }

// Add more tracking functions as needed
}
