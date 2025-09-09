import 'package:bitesize_golf/features/auth/domain/entities/user_enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Enhanced subscription model for golf learning app
class Subscription extends Equatable {
  final SubscriptionStatus status;
  final SubscriptionTier tier;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool autoRenew;

  // Learning content access
  final int maxUnlockedLevels;
  //final List<String> accessibleFeatures; // e.g., ['video_lessons', 'quizzes', 'progress_tracking', 'coach_feedback']

  // // Usage limits
  // final int maxDailyLessons;
  // final int maxQuizzesPerDay;
  // final bool unlimitedPractice;

  // Additional features
  // final bool adFree;
  // final bool offlineDownloads;
  // final int maxStoredVideos;
  // final bool prioritySupport;

  const Subscription({
    this.status = SubscriptionStatus.free,
    this.tier = SubscriptionTier.free,
    this.startDate,
    this.endDate,
    this.autoRenew = false,
    this.maxUnlockedLevels = 3, // Free tier gets first 3 levels
    //this.accessibleFeatures = const ['basic_lessons', 'basic_quizzes'],
    // this.hasCoachAccess = false,
    // this.hasAdvancedAnalytics = false,
    // this.hasPremiumContent = false,
    // this.maxDailyLessons = 3,
    // this.maxQuizzesPerDay = 5,
    // this.unlimitedPractice = false,
    // this.adFree = false,
    // this.offlineDownloads = false,
    // this.maxStoredVideos = 0,
    // this.prioritySupport = false,
  });

  @override
  List<Object?> get props => [
    status, tier, startDate, endDate, autoRenew,
    maxUnlockedLevels,
    // accessibleFeatures, hasCoachAccess,
    // hasAdvancedAnalytics, hasPremiumContent, maxDailyLessons,
    // maxQuizzesPerDay, unlimitedPractice, adFree, offlineDownloads,
    // maxStoredVideos, prioritySupport,
  ];

  // Computed properties
  bool get isActive => status == SubscriptionStatus.active;
  bool get isFree => tier == SubscriptionTier.free;
  bool get isPremium => tier == SubscriptionTier.premium;
  bool get isExpired => endDate != null && DateTime.now().isAfter(endDate!);

  // Check if a specific level is unlocked
  bool canAccessLevel(int level) => level <= maxUnlockedLevels;

  // Check if a feature is accessible
  // bool hasFeature(String feature) => accessibleFeatures.contains(feature);
  //
  // // Check daily usage limits
  // bool canTakeMoreLessons(int todayCount) =>
  //     unlimitedPractice || todayCount < maxDailyLessons;
  //
  // bool canTakeMoreQuizzes(int todayCount) =>
  //     unlimitedPractice || todayCount < maxQuizzesPerDay;

  // Factory constructors for different tiers
  factory Subscription.free() => const Subscription(
    status: SubscriptionStatus.active,
    tier: SubscriptionTier.free,
    maxUnlockedLevels: 3,
    // accessibleFeatures: ['basic_lessons', 'basic_quizzes', 'progress_tracking'],
    // maxDailyLessons: 3,
    // maxQuizzesPerDay: 5,
  );

  factory Subscription.premium({
    required DateTime startDate,
    required DateTime endDate,
    bool autoRenew = false,
  }) => Subscription(
    status: SubscriptionStatus.active,
    tier: SubscriptionTier.premium,
    startDate: startDate,
    endDate: endDate,
    autoRenew: autoRenew,
    maxUnlockedLevels: 10, // Unlimited levels
    // accessibleFeatures: [
    //   'basic_lessons',
    //   'premium_lessons',
    //   'video_lessons',
    //   'quizzes',
    //   'advanced_quizzes',
    //   'progress_tracking',
    //   'detailed_analytics',
    //   'coach_feedback',
    //   'community_features',
    //   'custom_practice',
    // ],
    // hasCoachAccess: true,
    // hasAdvancedAnalytics: true,
    // hasPremiumContent: true,
    // maxDailyLessons: 999,
    // maxQuizzesPerDay: 999,
    // unlimitedPractice: true,
    // adFree: true,
    // offlineDownloads: true,
    // maxStoredVideos: 50,
    // prioritySupport: true,
  );

  factory Subscription.trial({
    required DateTime startDate,
    required DateTime endDate,
  }) => Subscription(
    status: SubscriptionStatus.active,
    tier: SubscriptionTier.trial,
    startDate: startDate,
    endDate: endDate,
    maxUnlockedLevels: 10,
    // accessibleFeatures: [
    //   'basic_lessons',
    //   'premium_lessons',
    //   'video_lessons',
    //   'quizzes',
    //   'progress_tracking',
    //   'coach_feedback',
    // ],
    // hasCoachAccess: true,
    // hasAdvancedAnalytics: true,
    // hasPremiumContent: true,
    // maxDailyLessons: 10,
    // maxQuizzesPerDay: 15,
    // unlimitedPractice: false,
    // adFree: true,
    // offlineDownloads: true,
    // maxStoredVideos: 10,
    // prioritySupport: false,
  );

  Subscription copyWith({
    SubscriptionStatus? status,
    SubscriptionTier? tier,
    DateTime? startDate,
    DateTime? endDate,
    bool? autoRenew,
    int? maxUnlockedLevels,
    List<String>? accessibleFeatures,
    bool? hasCoachAccess,
    bool? hasAdvancedAnalytics,
    bool? hasPremiumContent,
    int? maxDailyLessons,
    int? maxQuizzesPerDay,
    bool? unlimitedPractice,
    bool? adFree,
    bool? offlineDownloads,
    int? maxStoredVideos,
    bool? prioritySupport,
  }) => Subscription(
    status: status ?? this.status,
    tier: tier ?? this.tier,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    autoRenew: autoRenew ?? this.autoRenew,
    maxUnlockedLevels: maxUnlockedLevels ?? this.maxUnlockedLevels,
    // accessibleFeatures: accessibleFeatures ?? this.accessibleFeatures,
    // hasCoachAccess: hasCoachAccess ?? this.hasCoachAccess,
    // hasAdvancedAnalytics: hasAdvancedAnalytics ?? this.hasAdvancedAnalytics,
    // hasPremiumContent: hasPremiumContent ?? this.hasPremiumContent,
    // maxDailyLessons: maxDailyLessons ?? this.maxDailyLessons,
    // maxQuizzesPerDay: maxQuizzesPerDay ?? this.maxQuizzesPerDay,
    // unlimitedPractice: unlimitedPractice ?? this.unlimitedPractice,
    // adFree: adFree ?? this.adFree,
    // offlineDownloads: offlineDownloads ?? this.offlineDownloads,
    // maxStoredVideos: maxStoredVideos ?? this.maxStoredVideos,
    // prioritySupport: prioritySupport ?? this.prioritySupport,
  );

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    status: SubscriptionStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => SubscriptionStatus.free,
    ),
    tier: SubscriptionTier.values.firstWhere(
      (e) => e.name == json['tier'],
      orElse: () => SubscriptionTier.free,
    ),
    startDate: (json['startDate'] as Timestamp?)?.toDate(),
    endDate: (json['endDate'] as Timestamp?)?.toDate(),
    autoRenew: json['autoRenew'] ?? false,
    maxUnlockedLevels: json['maxUnlockedLevels'] ?? 3,
    // accessibleFeatures: List<String>.from(json['accessibleFeatures'] ?? ['basic_lessons', 'basic_quizzes']),
    // hasCoachAccess: json['hasCoachAccess'] ?? false,
    // hasAdvancedAnalytics: json['hasAdvancedAnalytics'] ?? false,
    // hasPremiumContent: json['hasPremiumContent'] ?? false,
    // maxDailyLessons: json['maxDailyLessons'] ?? 3,
    // maxQuizzesPerDay: json['maxQuizzesPerDay'] ?? 5,
    // unlimitedPractice: json['unlimitedPractice'] ?? false,
    // adFree: json['adFree'] ?? false,
    // offlineDownloads: json['offlineDownloads'] ?? false,
    // maxStoredVideos: json['maxStoredVideos'] ?? 0,
    // prioritySupport: json['prioritySupport'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'status': status.name,
    'tier': tier.name,
    if (startDate != null) 'startDate': Timestamp.fromDate(startDate!),
    if (endDate != null) 'endDate': Timestamp.fromDate(endDate!),
    'autoRenew': autoRenew,
    'maxUnlockedLevels': maxUnlockedLevels,
    // 'accessibleFeatures': accessibleFeatures,
    // 'hasCoachAccess': hasCoachAccess,
    // 'hasAdvancedAnalytics': hasAdvancedAnalytics,
    // 'hasPremiumContent': hasPremiumContent,
    // 'maxDailyLessons': maxDailyLessons,
    // 'maxQuizzesPerDay': maxQuizzesPerDay,
    // 'unlimitedPractice': unlimitedPractice,
    // 'adFree': adFree,
    // 'offlineDownloads': offlineDownloads,
    // 'maxStoredVideos': maxStoredVideos,
    // 'prioritySupport': prioritySupport,
  };
}
