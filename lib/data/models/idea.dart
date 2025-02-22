import 'package:uuid/uuid.dart';

class Idea {
  // key
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // input : 필수
  final String title;
  final String? content;
  // input : 선택
  final List<String> tagIds;
  final int? targetViews;
  final List<String> prototypeIds;
  final List<String> researchIds;
  final List<String> taskScheduleIds;

  Idea(
      {String? id,
      DateTime? createdAt,
      DateTime? updatedAt,
      required this.title,
      this.content,
      List<String>? tagIds,
      this.targetViews,
      List<String>? prototypeIds,
      List<String>? researchIds,
      List<String>? taskScheduleIds})
      : id = id ?? Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        tagIds = tagIds ?? [],
        prototypeIds = prototypeIds ?? [],
        researchIds = researchIds ?? [],
        taskScheduleIds = taskScheduleIds ?? [];
}