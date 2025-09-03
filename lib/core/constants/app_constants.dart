// core/app_constants.dart
import 'package:flutter/material.dart';

/// App
const AppName = '3fitech Golf Learn';

/// Firebase project/app (update if you change your Firebase)
const mFirebaseAppId = '1:552392197011:android:ab575c967631768f989e66';

/// Optional: App icon hosted on Storage (keep if used in About/Splash)
const mAppIconUrl =
    'https://firebasestorage.googleapis.com/v0/b/$mFirebaseAppId/o/app_logo.png?alt=media&token=738b073d-c575-4a79-a257-de052dadd2e3';

/// Legal / Support (replace with your URLs)
const termsAndConditionURL = 'https://example.com/terms';
const privacyPolicy = 'https://example.com/privacy';
const supportURL = 'https://example.com/support';
const mailto = 'support@example.com';

/// Locale defaults
const defaultCountry = 'IN';
const defaultCountryCode = '+91';
const defaultLanguage = 'en';
const defaultTimezone = 'Asia/Kolkata';

/// RTL languages (if you localize to more)
const rtlLanguage = <String>['ar', 'ur'];

/// Firestore collections (Golf learning platform)
const USERS_COLLECTION = 'users';
const PUPILS_COLLECTION = 'pupils';
const COACHES_COLLECTION = 'coaches';
const SUBJECTS_COLLECTION = 'subjects';
const PLANS_COLLECTION = 'plans';
const COURSES_COLLECTION = 'courses';
const LESSONS_COLLECTION = 'lessons';
const QUIZZES_COLLECTION = 'quizzes';
const ENROLLMENTS_COLLECTION = 'enrollments';
const SESSIONS_COLLECTION = 'sessions';
const RECOMMENDATIONS_COLLECTION = 'recommendations';
const PROGRESS_REPORTS_COLLECTION = 'progressReports';
const NOTIFICATIONS_COLLECTION = 'notifications';
const DOWNLOADS_COLLECTION = 'downloads';
const PAYMENTS_COLLECTION = 'payments';
const ANALYTICS_EVENTS_COLLECTION = 'analyticsEvents';

/// Remote Config keys (paywall/preview)
const RC_DAILY_PREVIEW_LIMIT = 'daily_preview_limit';
const RC_SEARCH_LIMIT = 'search_limit';

/// SharedPreferences keys (quick access)
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const PREF_USER_ID = 'userId';
const PREF_USER_NAME = 'userDisplayName';
const PREF_USER_EMAIL = 'userEmail';
const PREF_USER_PHOTO = 'userPhotoUrl';
const PREF_USER_ROLE = 'userRole'; // guest | pupil | coach | admin
const PREF_EMAIL_VERIFIED = 'emailVerified';

// Add these critical flags
const PREF_SUBSCRIPTION_STATUS = 'subscriptionStatus'; // free|trial|active
const PREF_SUBSCRIPTION_TIER = 'subscriptionTier'; // free|basic|premium
const PREF_DAILY_LIMITS_RESET = 'dailyLimitsReset'; // for paywall logic
const PREF_LAST_SYNC = 'lastSyncTimestamp';
const PREF_OFFLINE_MODE = 'offlineMode';

/// Hive boxes & keys
const AUTH_BOX =
    'auth_box'; // stores { 'user': <json> } in our local data source

/// UI constants (optional)
const ThemeModeLight = 0;
const ThemeModeDark = 1;
const ThemeModeSystem = 2;

const FONT_SIZE_SMALL = 12.0;
const FONT_SIZE_MEDIUM = 16.0;
const FONT_SIZE_LARGE = 20.0;

/// Icons helper (if you end up mapping content types)
Icon getIconForContentType(String type) {
  switch (type.toLowerCase()) {
    case 'video':
      return const Icon(
        Icons.play_circle_outline,
        color: Colors.grey,
        size: 14,
      );
    case 'audio':
      return const Icon(Icons.audiotrack, color: Colors.grey, size: 14);
    case 'pdf':
      return const Icon(Icons.picture_as_pdf, color: Colors.grey, size: 14);
    case 'image':
      return const Icon(Icons.image_outlined, color: Colors.grey, size: 14);
    default:
      return const Icon(
        Icons.description_outlined,
        color: Colors.grey,
        size: 14,
      );
  }
}
