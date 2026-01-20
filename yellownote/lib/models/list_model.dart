import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'list_model.g.dart';

@HiveType(typeId: 2)
class ListModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late List<ChecklistItem> items;

  @HiveField(3)
  late DateTime createdAt;

  @HiveField(4)
  late DateTime updatedAt;

  @HiveField(5)
  late String userId;

  @HiveField(6)
  String? projectId;

  ListModel({
    String? id,
    required this.title,
    List<ChecklistItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.userId = '',
    this.projectId,
  }) {
    this.id = id ?? const Uuid().v4();
    this.items = items ?? [];
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
  }

  ListModel copyWith({
    String? id,
    String? title,
    List<ChecklistItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    String? projectId,
  }) {
    return ListModel(
      id: id ?? this.id,
      title: title ?? this.title,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      projectId: projectId ?? this.projectId,
    );
  }

  int get completedCount {
    return items.where((item) => item.isCompleted).length;
  }

  int get totalCount {
    return items.length;
  }

  double get progress {
    if (items.isEmpty) return 0.0;
    return completedCount / totalCount;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
      'projectId': projectId,
    };
  }

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      id: json['id'] as String,
      title: json['title'] as String,
      items: (json['items'] as List)
          .map((item) => ChecklistItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as String? ?? '',
      projectId: json['projectId'] as String?,
    );
  }
}

@HiveType(typeId: 3)
class ChecklistItem extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String text;

  @HiveField(2)
  late bool isCompleted;

  ChecklistItem({
    String? id,
    required this.text,
    this.isCompleted = false,
  }) {
    this.id = id ?? const Uuid().v4();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isCompleted': isCompleted,
    };
  }

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'] as String,
      text: json['text'] as String,
      isCompleted: json['isCompleted'] as bool,
    );
  }
}
