class HiveBoxes {
  // Separate boxes for different data types - better performance and management
  static const String authBox = 'auth_box';
  static const String userProfileBox = 'user_profile_box';
  static const String contentCacheBox = 'content_cache_box';
  static const String progressBox = 'progress_box';
  static const String settingsBox = 'settings_box';
  static const String analyticsBox = 'analytics_box';
}

class HiveKeys {
  // Auth box keys
  static const String userCredentials = 'user_credentials';
  static const String tokenData = 'token_data';

  // User profile box keys
  static const String pupilProfile = 'pupil_profile';
  static const String coachProfile = 'coach_profile';
  static const String assignedCoach = 'assigned_coach';

  // Content cache box keys
  static const String enrolledCourses = 'enrolled_courses';
  static const String bookmarkedLessons = 'bookmarked_lessons';
  static const String downloadedContent = 'downloaded_content';
  static const String recentlyViewed = 'recently_viewed';

  // Progress box keys
  static const String learningProgress = 'learning_progress';
  static const String streakData = 'streak_data';
  static const String achievements = 'achievements';
  static const String sessionHistory = 'session_history';

  // Settings box keys
  static const String appPreferences = 'app_preferences';
  static const String notificationSettings = 'notification_settings';
  static const String playbackSettings = 'playback_settings';
}
