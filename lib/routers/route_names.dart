class RouteName {
  static String onboardingScreen = 'onboarding';
  static String loginScreen = 'login';
  static String signupScreen = 'signup';
  static String homeScreen = 'home';
  static String cartScreen = 'cart';
  static String chatScreen = 'chat';
  static String profileScreen = 'profile';
}

extension ToPath on String {
  String toPath() => '/$this';
}
