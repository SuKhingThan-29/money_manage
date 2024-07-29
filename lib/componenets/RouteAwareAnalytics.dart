import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

// A Navigator observer that notifies RouteAwares of changes to state of their Route
final routeObserver = RouteObserver<PageRoute>();

mixin RouteAwareAnalytics<T extends StatefulWidget> on State<T>
implements RouteAware {
  late FirebaseAnalytics analytics;
  AnalyticsRoute get route;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {}

  @override
  void didPopNext() {
    // Called when the top route has been popped off,
    // and the current route shows up.
    _setCurrentScreen(route);
  }

  @override
  void didPush() {
    // Called when the current route has been pushed.
    _setCurrentScreen(route);
  }

  @override
  void didPushNext() {}

  Future<void> _setCurrentScreen(AnalyticsRoute analyticsRoute) {
    print('Setting current screen to $analyticsRoute');
    return analytics.setCurrentScreen(
      screenName: screenName(analyticsRoute),
      screenClassOverride: screenClass(analyticsRoute),
    );
  }
}
enum AnalyticsRoute { home }

String screenClass(AnalyticsRoute route) {
  switch (route) {
    case AnalyticsRoute.home:
      return 'available_homes';
  }
  throw ArgumentError.notNull('route');
}

String screenName(AnalyticsRoute route) {
  switch (route) {
    case AnalyticsRoute.home:
      return '/Home_Page';
  }
  throw ArgumentError.notNull('route');
}