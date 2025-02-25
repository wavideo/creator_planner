import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/data/services/firebase_service.dart';

class IdeaFirestoreService extends FirestoreService<Idea> {
  IdeaFirestoreService() : super('ideas');

  Future<void> addItem(Idea item) async {
    await add(item.id, item.toMap());
  }

  Future<Idea?> getItem(String id) async {
    return await get(id, (data) => Idea.fromMap(data));
  }

  Stream<List<Idea>> getItemList() {
    return getList((data) => Idea.fromMap(data));
  }

  Future<void> updateItem(Idea item) async {
    await update(item.id, item.toMap());
  }

  Future<void> deleteItem(String id) async {
    await delete(id);
  }
}
