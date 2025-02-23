import 'package:uuid/uuid.dart';

// id
// createdAt
// updatedAt
// title
// content
// tagIds
// targetViews
// prototypeIds
// researchIds
// taskScheduleIds

/*
? idea.dart
- 모델 Idea{}
- 생성자 & 초기화 Idea():
- JSON 필드 IdeaField {}
? firestore_service.dart

*/

class Idea {
  // key
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // input
  final String title;
  final String? content;
  final List<String> tagIds;
  final int? targetViews;
  // input (확장)
  final List<String> prototypeIds;
  final List<String> researchIds;
  final List<String> taskScheduleIds;

//* 생성자
  Idea(
      { // key
      String? id,
      DateTime? createdAt,
      DateTime? updatedAt,
      // input
      required this.title,
      this.content,
      List<String>? tagIds,
      this.targetViews,
      // input (확장)
      List<String>? prototypeIds,
      List<String>? researchIds,
      List<String>? taskScheduleIds})
//* 초기화
      :
        // key
        id = id ?? Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        // input
        tagIds = tagIds ?? [],
        prototypeIds = prototypeIds ?? [],
        researchIds = researchIds ?? [],
        taskScheduleIds = taskScheduleIds ?? [];
}

//* JSON String 필드
class IdeaField {
  static const String collection = 'ideas';
  // key
  static const String id = 'id';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  // input
  static const String title = 'title';
  static const String content = 'content';
  static const String tagIds = 'tagIds';
  static const String targetViews = 'targetViews';
  // input (확장)
  static const String prototypeIds = 'prototypeIds';
  static const String researchIds = 'researchIds';
  static const String taskScheduleIds = 'taskScheduleIds';
}