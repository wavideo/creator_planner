abstract class Mappable<T> {
  Map<String, dynamic> toMap();
  String toJson();
  T copyWith();
}