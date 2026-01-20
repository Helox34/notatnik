import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'diary_entry.g.dart';

@HiveType(typeId: 4)
class DiaryEntry extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String content;

  @HiveField(3)
  late DateTime date;

  @HiveField(4)
  late DateTime createdAt;

  @HiveField(5)
  late DateTime updatedAt;

  @HiveField(6)
  late String userId;

  DiaryEntry({
    String? id,
    required this.title,
    required this.content,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.userId = '',
  }) {
    this.id = id ?? const Uuid().v4();
    this.date = date ?? DateTime.now();
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
  }

  DiaryEntry copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
    };
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as String? ?? '',
    );
  }
}
