// lib/route/app_routes.dart
class RouteNames {
  // Welcome & Auth
  static const letStart = '/letStart';
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const otpVerify = '/otp-verify';
  static const resetPassword = '/reset-password';

  // Profile Completion
  static const completeProfile = '/complete-profile';
  static const completeProfileCoach = '/complete-profile/coach';
  static const completeProfilePupil = '/complete-profile/pupil';

  // Main App (Role-based)
  static const mainScreen = '/main';
  static const coachHome = '/coach/home';
  static const pupilHome = '/pupil/home';
  static const guestHome = '/guest/home';

  // Auth sub-routes
  static const emailVerification = '/email-verification';

  // Common
  static const profile = '/profile';
  static const settings = '/settings';
}
