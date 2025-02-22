import 'package:uuid/uuid.dart';

class IdeaTag {
  final String id;
  final String name;
  final String? description;

  IdeaTag({
    String? id,
    required this.name,
    this.description,
  }) : id = id ?? Uuid().v4();
}
