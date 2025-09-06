import 'package:bitesize_golf/features/auth/domain/entities/user_enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Mirrors the Firestore map users/{uid}/subscription
class Subscription extends Equatable {
  final SubscriptionStatus status;
  final SubscriptionTier tier;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool autoRenew;

  const Subscription({
    this.status = SubscriptionStatus.free,
    this.tier = SubscriptionTier.free,
    this.startDate,
    this.endDate,
    this.autoRenew = false,
  });

  @override
  List<Object?> get props => [status, tier, startDate, endDate, autoRenew];

  Subscription copyWith({
    SubscriptionStatus? status,
    SubscriptionTier? tier,
    DateTime? startDate,
    DateTime? endDate,
    bool? autoRenew,
  }) => Subscription(
    status: status ?? this.status,
    tier: tier ?? this.tier,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    autoRenew: autoRenew ?? this.autoRenew,
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
  );

  Map<String, dynamic> toJson() => {
    'status': status.name,
    'tier': tier.name,
    if (startDate != null) 'startDate': Timestamp.fromDate(startDate!),
    if (endDate != null) 'endDate': Timestamp.fromDate(endDate!),
    'autoRenew': autoRenew,
  };
}
