import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator_planner/data/models/idea.dart';
import 'package:logger/logger.dart';

class IdeaFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addIdea(Idea idea) async {
    try {
      await _db.collection(IdeaField.collection).doc(idea.id).set({
        IdeaField.id: idea.id,
        IdeaField.createdAt: idea.createdAt,
        IdeaField.updatedAt: idea.updatedAt,
        IdeaField.title: idea.title,
        IdeaField.content: idea.content,
        IdeaField.tagIds: idea.tagIds,
        IdeaField.targetViews: idea.targetViews,
        IdeaField.prototypeIds: idea.prototypeIds,
        IdeaField.researchIds: idea.researchIds,
        IdeaField.taskScheduleIds: idea.taskScheduleIds,
      });
      Logger().d("객체가 업로드 되었습니다");
    } catch (e) {
      Logger().e("아이디어 추가 중 오류 발생", error: e);
      throw Exception("아이디어를 Firestore에 추가하는 과정에서 문제가 발생했습니다. 에러: $e");
    }
  }

  Future<Idea?> getIdea(String id) async {
    try {
      DocumentSnapshot snapshot =
          await _db.collection(IdeaField.collection).doc(id).get();

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;

        return Idea(
          id: data[IdeaField.id],
          createdAt: DateTime.parse(data[IdeaField.createdAt]),
          updatedAt: DateTime.parse(data[IdeaField.updatedAt]),
          title: data[IdeaField.title],
          content: data[IdeaField.content],
          tagIds: List<String>.from(data[IdeaField.tagIds]),
          targetViews: data[IdeaField.targetViews],
          prototypeIds: List<String>.from(data[IdeaField.prototypeIds]),
          researchIds: List<String>.from(data[IdeaField.researchIds]),
          taskScheduleIds: List<String>.from(data[IdeaField.taskScheduleIds]),
        );
      } else {
        return null;
      }
    } catch (e) {
      Logger().e("아이디어 가져오기 중 오류 발생", error: e);
      throw Exception("아이디어를 Firestore에서 가져오는 과정에서 문제가 발생했습니다. 에러: $e");
    }
  }

  Future<List<Idea>> getAllIdeas() async {
    try {
      QuerySnapshot snapshot = await _db.collection(IdeaField.collection).get();

      List<Idea> ideas = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Idea(
          id: data[IdeaField.id],
          createdAt: DateTime.parse(data[IdeaField.createdAt]),
          updatedAt: DateTime.parse(data[IdeaField.updatedAt]),
          title: data[IdeaField.title],
          content: data[IdeaField.content],
          tagIds: List<String>.from(data[IdeaField.tagIds]),
          targetViews: data[IdeaField.targetViews],
          prototypeIds: List<String>.from(data[IdeaField.prototypeIds]),
          researchIds: List<String>.from(data[IdeaField.researchIds]),
          taskScheduleIds: List<String>.from(data[IdeaField.taskScheduleIds]),
        );
      }).toList();

      return ideas;
    } catch (e) {
      Logger().e("모든 아이디어 가져오기 중 오류 발생", error: e);
      throw Exception("모든 아이디어를 가져오는 과정에서 문제가 발생했습니다. 에러: $e");
    }
  }

  Future<void> updateIdea(Idea idea) async {
    try {
      await _db.collection(IdeaField.collection).doc(idea.id).update({
        IdeaField.updatedAt: DateTime.now(),
        IdeaField.title: idea.title,
        IdeaField.content: idea.content,
        IdeaField.tagIds: idea.tagIds,
        IdeaField.targetViews: idea.targetViews,
        IdeaField.prototypeIds: idea.prototypeIds,
        IdeaField.researchIds: idea.researchIds,
        IdeaField.taskScheduleIds: idea.taskScheduleIds,
      });
    } catch (e) {
      Logger().e("아이디어 업데이트 중 오류 발생", error: e);
      throw Exception("아이디어를 업데이트하는 과정에서 문제가 발생했습니다. 에러: $e");
    }
  }

  Future<void> deleteIdeas(String id) async {
    try{
      await _db.collection(IdeaField.collection).doc(id).delete();
    } catch(e){
      Logger().e("아이디어 삭제 중 오류 발생", error: e);
      throw Exception("아이디어를 삭제하는 과정에서 문제가 발생했습니다. 에러: $e");
    }
  }
}