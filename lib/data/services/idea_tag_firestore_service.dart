import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:creator_planner/data/services/firebase_service.dart';

class IdeaTagFirestoreService extends FirestoreService<IdeaTag> {
  IdeaTagFirestoreService() : super('ideaTags');

  Future<void> addItem(IdeaTag item) async {
    await add(item.id, item.toMap());
  }

  Future<IdeaTag?> getItem(String id) async {
    return await get(id, (data) => IdeaTag.fromMap(data));
  }

  Future<List<IdeaTag>> getItemList() async {
    return await getList((data) => IdeaTag.fromMap(data));
  }

  Future<void> updateItem(IdeaTag item) async {
    IdeaTag updatedItem = item.copyWith(updatedAt: DateTime.now());
    await update(item.id, updatedItem.toMap());
  }

  Future<void> deleteItem(String id) async {
    await delete(id);
  }
}