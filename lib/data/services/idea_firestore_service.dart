import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/data/services/firebase_service.dart';

class IdeaFirestoreService extends FirestoreService<Idea> {
  IdeaFirestoreService() : super('ideaTags');

  Future<void> addItem(Idea item) async {
    await add(item.id, item.toMap());
  }

  Future<Idea?> getItem(String id) async {
    return await get(id, (data) => Idea.fromMap(data));
  }

  Future<List<Idea>> getItemList() async {
    return await getList((data) => Idea.fromMap(data));
  }

  Future<void> updateItem(Idea item) async {
    Idea updatedItem = item.copyWith(updatedAt: DateTime.now());
    await update(item.id, updatedItem.toMap());
  }

  Future<void> deleteItem(String id) async {
    await delete(id);
  }
}