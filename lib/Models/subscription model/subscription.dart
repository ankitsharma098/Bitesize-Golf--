import 'package:cloud_firestore/cloud_firestore.dart';

/* ================================================================
   Main subscription object that is stored inside a user doc
   ================================================================ */
class Subscription {
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
    this.maxUnlockedLevels = 3,
  });

  /* ---------------- computed helpers ---------------- */
  bool get isActive => status == SubscriptionStatus.active;
  bool get isFree => tier == SubscriptionTier.free;
  bool get isPremium => tier == SubscriptionTier.premium;
  bool get isExpired => endDate != null && DateTime.now().isAfter(endDate!);
  bool canAccessLevel(int level) => level <= maxUnlockedLevels;

  /* ---------------- factories ---------------- */
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
    maxUnlockedLevels: 10,
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

  /* ---------------- Firestore ---------------- */
  Map<String, dynamic> toFirestore() => {
    'status': status.name,
    'tier': tier.name,
    if (startDate != null) 'startDate': Timestamp.fromDate(startDate!),
    if (endDate != null) 'endDate': Timestamp.fromDate(endDate!),
    'autoRenew': autoRenew,
    'maxUnlockedLevels': maxUnlockedLevels,
  };

  factory Subscription.fromFirestore(Map<String, dynamic> json) => Subscription(
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

  /* ---------------- copyWith ---------------- */
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
}

/* ================================================================
   Plan objects are only used client-side (never stored in Firestore)
   ================================================================ */
enum SubscriptionPlanType { monthly, annual }

class SubscriptionPlan {
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
}

/* ================================================================
   Enums used above
   ================================================================ */
enum SubscriptionStatus { free, active, cancelled, expired }

enum SubscriptionTier { free, trial, premium }
