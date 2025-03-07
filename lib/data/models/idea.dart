// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:creator_planner/data/interfaces/base_model.dart';
import 'package:uuid/uuid.dart';

class Idea implements BaseModel<Idea> {
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final double order;
  final String title;
  final String? content;
  final List<String> tagIds;
  final int? targetViews;
  final List<String> prototypeIds;
  final List<String> researchIds;
  final List<String> taskScheduleIds;
  Idea({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? order,
    List<String>? tagIds,
    List<String>? prototypeIds,
    List<String>? researchIds,
    List<String>? taskScheduleIds,
    required this.title,
    this.content,
    this.targetViews,
  })  : id = id ?? Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        order = order ?? 1.0,
        tagIds = tagIds ?? [],
        prototypeIds = prototypeIds ?? [],
        researchIds = researchIds ?? [],
        taskScheduleIds = taskScheduleIds ?? [];

  @override
  Idea copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? order,
    String? title,
    String? content,
    List<String>? tagIds,
    int? targetViews,
    List<String>? prototypeIds,
    List<String>? researchIds,
    List<String>? taskScheduleIds,
  }) {
    return Idea(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      order: order ?? this.order,
      title: title ?? this.title,
      content: content != null
          ? content.isNotEmpty
              ? content
              : null
          : this.content,
      tagIds: tagIds != null
          ? List<String>.from(tagIds)
          : List<String>.from(this.tagIds),
      targetViews: targetViews ?? this.targetViews,
      prototypeIds: prototypeIds != null
          ? List<String>.from(prototypeIds)
          : List<String>.from(this.prototypeIds),
      researchIds: researchIds != null
          ? List<String>.from(researchIds)
          : List<String>.from(this.researchIds),
      taskScheduleIds: taskScheduleIds != null
          ? List<String>.from(taskScheduleIds)
          : List<String>.from(this.taskScheduleIds),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'order': order,
      'title': title,
      'content': content,
      'tagIds': tagIds,
      'targetViews': targetViews,
      'prototypeIds': prototypeIds,
      'researchIds': researchIds,
      'taskScheduleIds': taskScheduleIds,
    };
  }

  factory Idea.fromMap(Map<String, dynamic> map) {
    var idea = Idea(
      id: map['id'] is String ? map['id'] as String : map['id'].toString(),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
      order: map['order'] is num ? map['order'].toDouble() : 1.0,
      title: map['title'] is String
          ? map['title'] as String
          : map['title'].toString(),
      content: map['content'] != null ? map['content'] as String : null,
      tagIds: map['tagIds'] != null && map['tagIds'] is List
          ? List<String>.from(map['tagIds'] as List)
          : [],
      targetViews:
          map['targetViews'] != null ? map['targetViews'] as int : null,
      prototypeIds: map['prototypeIds'] != null && map['prototypeIds'] is List
          ? List<String>.from(map['prototypeIds'] as List)
          : [],
      researchIds: map['researchIds'] != null && map['researchIds'] is List
          ? List<String>.from(map['researchIds'] as List)
          : [],
      taskScheduleIds:
          map['taskScheduleIds'] != null && map['taskScheduleIds'] is List
              ? List<String>.from(map['taskScheduleIds'] as List)
              : [],
    );

    return idea;
  }

  @override
  String toJson() => json.encode(toMap());

  factory Idea.fromJson(String source) =>
      Idea.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Idea(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, order: $order, title: $title, content: $content, tagIds: $tagIds, targetViews: $targetViews, prototypeIds: $prototypeIds, researchIds: $researchIds, taskScheduleIds: $taskScheduleIds)';
  }

  @override
  bool operator ==(covariant Idea other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.order == order &&
        other.title == title &&
        other.content == content &&
        listEquals(other.tagIds, tagIds) &&
        other.targetViews == targetViews &&
        listEquals(other.prototypeIds, prototypeIds) &&
        listEquals(other.researchIds, researchIds) &&
        listEquals(other.taskScheduleIds, taskScheduleIds);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        order.hashCode ^
        title.hashCode ^
        content.hashCode ^
        tagIds.hashCode ^
        targetViews.hashCode ^
        prototypeIds.hashCode ^
        researchIds.hashCode ^
        taskScheduleIds.hashCode;
  }
}
