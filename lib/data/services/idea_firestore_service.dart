import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/data/services/firebase_service.dart';

class IdeaFirestoreService extends FirestoreService<Idea> {
  IdeaFirestoreService() : super('ideas');

  Future<void> add(Idea item) async {
    await addUserData(item.id, item.toMap());
  }

  Future<Idea?> get(String id) async {
    return await getData(id, (data) => Idea.fromMap(data));
  }

  Stream<List<Idea>> getStream() {
    return getUserDatasStream((data) => Idea.fromMap(data));
  }

  Future<void> update(Idea item) async {
    await updateData(item.id, item.toMap());
  }

  Future<void> delete(String id) async {
    await deleteData(id);
  }

  Future<void> deleteAll() async {
    await deleteUserDatas();
  }
}