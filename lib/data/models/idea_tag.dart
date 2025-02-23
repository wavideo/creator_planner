// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uuid/uuid.dart';

class IdeaTag {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String name;
  final String? description;

  IdeaTag({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.name,
    this.description,
  })  : id = id ?? Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  IdeaTag copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? description,
  }) {
    return IdeaTag(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'name': name,
      'description': description,
    };
  }

  factory IdeaTag.fromMap(Map<String, dynamic> map) {
    return IdeaTag(
      id: map['id'] as String,
      createdAt: map['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int) : null,
      name: map['name'] as String,
      description: map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory IdeaTag.fromJson(String source) => IdeaTag.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'IdeaTag(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, name: $name, description: $description)';
  }

  @override
  bool operator ==(covariant IdeaTag other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.name == name &&
      other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      name.hashCode ^
      description.hashCode;
  }
}
