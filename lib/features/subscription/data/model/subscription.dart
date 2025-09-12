// features/subscription/data/model/subscription.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../../auth/data/entities/user_enums.dart';

/// Enhanced subscription model for golf learning app
class Subscription extends Equatable {
  final SubscriptionStatus status;
  final SubscriptionTier tier;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool autoRenew;
  final int maxUnlockedLevels;

  const Subscription({
    this.status = SubscriptionStatus.free,
    this.tier = SubscriptionTier.free,
    this.startDate,
    this.endDate,
    this.autoRenew = false,
    this.maxUnlockedLevels = 3, // Free tier gets first 3 levels
  });

  @override
  List<Object?> get props => [
    status,
    tier,
    startDate,
    endDate,
    autoRenew,
    maxUnlockedLevels,
  ];

  // Computed properties
  bool get isActive => status == SubscriptionStatus.active;
  bool get isFree => tier == SubscriptionTier.free;
  bool get isPremium => tier == SubscriptionTier.premium;
  bool get isExpired => endDate != null && DateTime.now().isAfter(endDate!);

  // Check if a specific level is unlocked
  bool canAccessLevel(int level) => level <= maxUnlockedLevels;

  // Factory constructors for different tiers
  factory Subscription.free() => const Subscription(
    status: SubscriptionStatus.active,
    tier: SubscriptionTier.free,
    maxUnlockedLevels: 3,
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
    maxUnlockedLevels: 10, // Premium gets all levels
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
  );

  Subscription copyWith({
    SubscriptionStatus? status,
    SubscriptionTier? tier,
    DateTime? startDate,
    DateTime? endDate,
    bool? autoRenew,
    int? maxUnlockedLevels,
  }) => Subscription(
    status: status ?? this.status,
    tier: tier ?? this.tier,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    autoRenew: autoRenew ?? this.autoRenew,
    maxUnlockedLevels: maxUnlockedLevels ?? this.maxUnlockedLevels,
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
  );

  Map<String, dynamic> toJson() => {
    'status': status.name,
    'tier': tier.name,
    if (startDate != null) 'startDate': Timestamp.fromDate(startDate!),
    if (endDate != null) 'endDate': Timestamp.fromDate(endDate!),
    'autoRenew': autoRenew,
    'maxUnlockedLevels': maxUnlockedLevels,
  };
}

enum SubscriptionPlanType { monthly, annual }

class SubscriptionPlan extends Equatable {
  final SubscriptionPlanType type;
  final String title;
  final String price;
  final String description;
  final int unlockedLevels;
  final String saveText;
  final bool isRecommended;

  const SubscriptionPlan({
    required this.type,
    required this.title,
    required this.price,
    required this.description,
    required this.unlockedLevels,
    this.saveText = '',
    this.isRecommended = false,
  });

  @override
  List<Object?> get props => [
    type,
    title,
    price,
    description,
    unlockedLevels,
    saveText,
    isRecommended,
  ];

  // Static plan definitions
  static const monthly = SubscriptionPlan(
    type: SubscriptionPlanType.monthly,
    title: 'Monthly',
    price: '£15.00',
    description: 'Monthly subscription',
    unlockedLevels: 5,
  );

  static const annual = SubscriptionPlan(
    type: SubscriptionPlanType.annual,
    title: 'Annual',
    price: '£144.00',
    description: 'Annual subscription',
    unlockedLevels: 10,
    saveText: 'Save 20%',
    isRecommended: true,
  );

  static List<SubscriptionPlan> get allPlans => [monthly, annual];

  // JSON serialization (if needed for future use)
  Map<String, dynamic> toJson() => {
    'type': type.name,
    'title': title,
    'price': price,
    'description': description,
    'unlockedLevels': unlockedLevels,
    'saveText': saveText,
    'isRecommended': isRecommended,
  };

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlan(
        type: SubscriptionPlanType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => SubscriptionPlanType.monthly,
        ),
        title: json['title'] ?? '',
        price: json['price'] ?? '',
        description: json['description'] ?? '',
        unlockedLevels: json['unlockedLevels'] ?? 0,
        saveText: json['saveText'] ?? '',
        isRecommended: json['isRecommended'] ?? false,
      );
}
