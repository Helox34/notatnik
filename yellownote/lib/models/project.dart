import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
class Project extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String description;

  @HiveField(3)
  late int totalLists;

  @HiveField(4)
  late int totalNotes;

  @HiveField(5)
  late int completedTasks;

  @HiveField(6)
  late int totalTasks;

  @HiveField(7)
  late DateTime createdAt;

  @HiveField(8)
  late DateTime updatedAt;

  @HiveField(9)
  late String userId;

  Project({
    String? id,
    required this.title,
    required this.description,
    this.totalLists = 0,
    this.totalNotes = 0,
    this.completedTasks = 0,
    this.totalTasks = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.userId = '',
  }) {
    this.id = id ?? const Uuid().v4();
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
  }

  double get progress {
    if (totalTasks == 0) return 0.0;
    return completedTasks / totalTasks;
  }

  int get progressPercentage {
    return (progress * 100).round();
  }

  Project copyWith({
    String? id,
    String? title,
    String? description,
    int? totalLists,
    int? totalNotes,
    int? completedTasks,
    int? totalTasks,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      totalLists: totalLists ?? this.totalLists,
      totalNotes: totalNotes ?? this.totalNotes,
      completedTasks: completedTasks ?? this.completedTasks,
      totalTasks: totalTasks ?? this.totalTasks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'totalLists': totalLists,
      'totalNotes': totalNotes,
      'completedTasks': completedTasks,
      'totalTasks': totalTasks,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      totalLists: json['totalLists'] as int,
      totalNotes: json['totalNotes'] as int,
      completedTasks: json['completedTasks'] as int,
      totalTasks: json['totalTasks'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as String? ?? '',
    );
  }
}
