import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:creator_planner/data/services/firebase_service.dart';

class IdeaTagFirestoreService extends FirestoreService<IdeaTag> {
  IdeaTagFirestoreService() : super('ideaTags');

  Future<void> add(IdeaTag item) async {
    await addUserData(item.id, item.toMap());
  }

  Future<IdeaTag?> get(String id) async {
    return await getData(id, (data) => IdeaTag.fromMap(data));
  }

  Stream<List<IdeaTag>> getStream() {
    return getUserDatasStream((data) => IdeaTag.fromMap(data));
  }

  Future<void> update(IdeaTag item) async {
    await updateData(item.id, item.toMap());
  }

  Future<void> delete(String id) async {
    await deleteData(id);
  }

  Future<void> deleteAll() async {
    await deleteUserDatas();
  }
}
