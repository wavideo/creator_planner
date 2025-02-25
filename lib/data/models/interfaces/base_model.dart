import 'package:uuid/uuid.dart';

abstract class BaseModel<T> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  BaseModel({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap();
  String toJson();
  T copyWith();
}
