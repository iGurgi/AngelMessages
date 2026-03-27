/// Core navigation routes for the Angel Messages app
/// 
/// This enum defines all available routes in the application and provides
/// type-safe navigation with go_router integration.
enum AppRoute {
  /// Home screen showing daily angel message
  home,
  
  /// Settings screen for app configuration
  settings,
  
  /// Message detail screen for viewing specific message
  messageDetail;
  
  /// Returns the path for this route
  /// 
  /// Used by go_router for navigation and deep linking
  String get path {
    switch (this) {
      case AppRoute.home:
        return '/';
      case AppRoute.settings:
        return '/settings';
      case AppRoute.messageDetail:
        return '/message/:id';
    }
  }
  
  /// Returns the name for this route
  /// 
  /// Used by go_router for named navigation
  String get name {
    switch (this) {
      case AppRoute.home:
        return 'home';
      case AppRoute.settings:
        return 'settings';
      case AppRoute.messageDetail:
        return 'messageDetail';
    }
  }
}
