import 'package:equatable/equatable.dart';

class CoachStats extends Equatable {
  final int totalPupils;
  final int activePupils;
  final double averageImprovement;
  final double responseTime; // hours

  const CoachStats({
    this.totalPupils = 0,
    this.activePupils = 0,
    this.averageImprovement = 0.0,
    this.responseTime = 0.0,
  });

  @override
  List<Object?> get props => [
    totalPupils,
    activePupils,
    averageImprovement,
    responseTime,
  ];

  factory CoachStats.fromJson(Map<String, dynamic> json) => CoachStats(
    totalPupils: json['totalPupils'] ?? 0,
    activePupils: json['activePupils'] ?? 0,
    averageImprovement: (json['averageImprovement'] ?? 0.0).toDouble(),
    responseTime: (json['responseTime'] ?? 0.0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'totalPupils': totalPupils,
    'activePupils': activePupils,
    'averageImprovement': averageImprovement,
    'responseTime': responseTime,
  };
}
