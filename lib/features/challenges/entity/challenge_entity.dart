import 'package:equatable/equatable.dart';

class Challenge extends Equatable {
  final String id;
  final String title;
  final String description;
  final String proTip;
  final int levelNumber;
  final List<Task> tasks;
  final int totalTasks;
  final int minTasksToPass;
  final int quizPassingScore;
  final int estimatedTime;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const Challenge({
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

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    proTip,
    levelNumber,
    tasks,
    totalTasks,
    minTasksToPass,
    quizPassingScore,
    estimatedTime,
    isActive,
    sortOrder,
    createdAt,
    updatedAt,
    createdBy,
  ];

  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    String? proTip,
    int? levelNumber,
    List<Task>? tasks,
    int? totalTasks,
    int? minTasksToPass,
    int? quizPassingScore,
    int? estimatedTime,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) => Challenge(
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
}

class Task extends Equatable {
  final String id;
  final String title;
  final int maxScore;
  final int passingScore;

  const Task({
    required this.id,
    required this.title,
    required this.maxScore,
    required this.passingScore,
  });

  @override
  List<Object?> get props => [id, title, maxScore, passingScore];

  Task copyWith({
    String? id,
    String? title,
    int? maxScore,
    int? passingScore,
  }) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    maxScore: maxScore ?? this.maxScore,
    passingScore: passingScore ?? this.passingScore,
  );
}
