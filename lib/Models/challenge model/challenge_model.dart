import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeModel {
  final String id;
  final String title;
  final String description;
  final String proTip;
  final int levelNumber;
  final List<TaskModel> tasks;
  final int totalTasks;
  final int minTasksToPass;
  final int quizPassingScore;
  final int estimatedTime;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.proTip,
    required this.levelNumber,
    required this.tasks,
    required this.totalTasks,
    required this.minTasksToPass,
    required this.quizPassingScore,
    required this.estimatedTime,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  factory ChallengeModel.create({
    required String id,
    required String title,
    required String description,
    required String proTip,
    required int levelNumber,
    required List<TaskModel> tasks,
    required int totalTasks,
    required int minTasksToPass,
    required int quizPassingScore,
    required int estimatedTime,
    bool isActive = true,
    int sortOrder = 0,
    String createdBy = '',
  }) {
    final now = DateTime.now();
    return ChallengeModel(
      id: id,
      title: title,
      description: description,
      proTip: proTip,
      levelNumber: levelNumber,
      tasks: tasks,
      totalTasks: totalTasks,
      minTasksToPass: minTasksToPass,
      quizPassingScore: quizPassingScore,
      estimatedTime: estimatedTime,
      isActive: isActive,
      sortOrder: sortOrder,
      createdAt: now,
      updatedAt: now,
      createdBy: createdBy,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'title': title,
    'description': description,
    'proTip': proTip,
    'levelNumber': levelNumber,
    'tasks': tasks.map((e) => e.toFirestore()).toList(),
    'totalTasks': totalTasks,
    'minTasksToPass': minTasksToPass,
    'quizPassingScore': quizPassingScore,
    'estimatedTime': estimatedTime,
    'isActive': isActive,
    'sortOrder': sortOrder,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
    'createdBy': createdBy,
  };

  factory ChallengeModel.fromFirestore(Map<String, dynamic> json) =>
      ChallengeModel(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        proTip: json['proTip'] ?? '',
        levelNumber: json['levelNumber'] ?? 1,
        tasks:
            (json['tasks'] as List<dynamic>?)
                ?.map((e) => TaskModel.fromFirestore(e))
                .toList() ??
            [],
        totalTasks: json['totalTasks'] ?? 0,
        minTasksToPass: json['minTasksToPass'] ?? 0,
        quizPassingScore: json['quizPassingScore'] ?? 0,
        estimatedTime: json['estimatedTime'] ?? 0,
        isActive: json['isActive'] ?? true,
        sortOrder: json['sortOrder'] ?? 0,
        createdAt: _toDateTime(json['createdAt']),
        updatedAt: _toDateTime(json['updatedAt']),
        createdBy: json['createdBy'] ?? '',
      );

  ChallengeModel copyWith({
    String? id,
    String? title,
    String? description,
    String? proTip,
    int? levelNumber,
    List<TaskModel>? tasks,
    int? totalTasks,
    int? minTasksToPass,
    int? quizPassingScore,
    int? estimatedTime,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) => ChallengeModel(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    proTip: proTip ?? this.proTip,
    levelNumber: levelNumber ?? this.levelNumber,
    tasks: tasks ?? this.tasks,
    totalTasks: totalTasks ?? this.totalTasks,
    minTasksToPass: minTasksToPass ?? this.minTasksToPass,
    quizPassingScore: quizPassingScore ?? this.quizPassingScore,
    estimatedTime: estimatedTime ?? this.estimatedTime,
    isActive: isActive ?? this.isActive,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    createdBy: createdBy ?? this.createdBy,
  );

  static DateTime _toDateTime(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.parse(v);
    return DateTime.now();
  }
}

/* -------------------------------------------------- */
class TaskModel {
  final String id;
  final String title;
  final int maxScore;
  final int passingScore;

  const TaskModel({
    required this.id,
    required this.title,
    required this.maxScore,
    required this.passingScore,
  });

  factory TaskModel.create({
    required String id,
    required String title,
    required int maxScore,
    required int passingScore,
  }) => TaskModel(
    id: id,
    title: title,
    maxScore: maxScore,
    passingScore: passingScore,
  );

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'title': title,
    'maxScore': maxScore,
    'passingScore': passingScore,
  };

  factory TaskModel.fromFirestore(Map<String, dynamic> json) => TaskModel(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    maxScore: json['maxScore'] ?? 0,
    passingScore: json['passingScore'] ?? 0,
  );

  TaskModel copyWith({
    String? id,
    String? title,
    int? maxScore,
    int? passingScore,
  }) => TaskModel(
    id: id ?? this.id,
    title: title ?? this.title,
    maxScore: maxScore ?? this.maxScore,
    passingScore: passingScore ?? this.passingScore,
  );
}
