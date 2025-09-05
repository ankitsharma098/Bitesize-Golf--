import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Mirrors the Firestore map users/{uid}/subscription
class Subscription extends Equatable {
  final String status; // free | trial | active | expired | canceled
  final String tier; // free | basic | premium
  final DateTime? startDate;
  final DateTime? endDate;
  final bool autoRenew;

  const Subscription({
    this.status = 'free',
    this.tier = 'free',
    this.startDate,
    this.endDate,
    this.autoRenew = false,
  });

  @override
  List<Object?> get props => [status, tier, startDate, endDate, autoRenew];

  Subscription copyWith({
    String? status,
    String? tier,
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
    status: json['status'] ?? 'free',
    tier: json['tier'] ?? 'free',
    startDate: (json['startDate'] as Timestamp?)?.toDate(),
    endDate: (json['endDate'] as Timestamp?)?.toDate(),
    autoRenew: json['autoRenew'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'tier': tier,
    if (startDate != null) 'startDate': Timestamp.fromDate(startDate!),
    if (endDate != null) 'endDate': Timestamp.fromDate(endDate!),
    'autoRenew': autoRenew,
  };
}
