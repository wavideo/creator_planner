import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class FirestoreService<T> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionPath;

  FirestoreService(this.collectionPath){
    _db.settings = const Settings(
      persistenceEnabled: true,
    );
  }

  Future<void> add(String id, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).doc(id).set(data);
    } catch (e) {
      Logger().e('Firebase에서 $collectionPath를 add 실패', error: e);
      throw Exception("Firebase에서 $collectionPath를 add 과정에 문제가 발생했습니다. 에러: $e");
    }
  }

  Future<T?> get(String id, T Function(Map<String, dynamic>) fromMap) async {
    try {
      DocumentSnapshot doc = await _db.collection(collectionPath).doc(id).get();
      if (doc.exists) {
        return fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      Logger().e('Firebase에서 $collectionPath를 get 실패', error: e);
      throw Exception("Firebase에서 $collectionPath를 get 과정에 문제가 발생했습니다. 에러: $e");
    }
  }

  Future<List<T>> getList(T Function(Map<String, dynamic>) fromMap) async {
    try {
      QuerySnapshot querySnapshot = await _db.collection(collectionPath).get();
      return querySnapshot.docs
          .map((doc) => fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Logger().e('Firebase에서 $collectionPath를 getList 실패', error: e);
      throw Exception(
          "Firebase에서 $collectionPath를 getList 과정에 문제가 발생했습니다. 에러: $e");
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).doc(id).update(data);
    } catch (e) {
      Logger().e('Firebase에서 $collectionPath를 update 실패', error: e);
      throw Exception(
          "Firebase에서 $collectionPath를 update 과정에 문제가 발생했습니다. 에러: $e");
    }
  }

  Future<void> delete(String id) async {
    try {
      await _db.collection(collectionPath).doc(id).delete();
    } catch (e) {
      Logger().e('Firebase에서 $collectionPath를 delete 실패', error: e);
      throw Exception(
          "Firebase에서 $collectionPath를 delete 과정에 문제가 발생했습니다. 에러: $e");
    }
  }
}
