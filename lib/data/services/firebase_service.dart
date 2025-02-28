import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class FirestoreService<T> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionPath;

  FirestoreService(this.collectionPath) {
    _db.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  Future<void> add(String id, Map<String, dynamic> data) async {
    try {
      // User? user = FirebaseAuth.instance.currentUser;
      // if (user == null) {
      //   Logger().e('로그인되지 않은 사용자가 접근했습니다.');
      //   throw Exception("로그인된 사용자가 없습니다.");
      // }
      // String userId = user.uid;
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Logger().e('사용자가 로그인하지 않았습니다.');
        throw Exception("로그인된 사용자가 없습니다.");
      }
      data['userId'] = userId;

      await _db.collection(collectionPath).doc(id).set(data);
      // await _db.collection(collectionPath).doc(id).get();
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

  Stream<List<T>> getList(T Function(Map<String, dynamic>) fromMap) {
    try {
      // User? user = FirebaseAuth.instance.currentUser;
      // if (user == null) {
      //   Logger().e('로그인되지 않은 사용자가 접근했습니다.');
      //   throw Exception("로그인된 사용자가 없습니다.");
      // }
      // String userId = user.uid;

      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Logger().e('로그인되지 않은 사용자가 접근했습니다.');
        throw Exception("로그인된 사용자가 없습니다.");
      }

      // Firestore의 실시간 업데이트 기능을 사용
      return _db
          .collection(collectionPath)
          .where('userId', isEqualTo: userId)
          // .where(Filter.or(Filter('userId', isEqualTo: userId),
          //     Filter('userId', isNull: true)
          //     ))
          .snapshots()
          .map(
        (querySnapshot) {
          return querySnapshot.docs
              // .where((doc) => doc.data().containsKey('userId'))
              .map((doc) => fromMap(doc.data()))
              .toList();
        },
      );
    } catch (e) {
      Logger().e('Firebase에서 $collectionPath를 getListStream 실패', error: e);
      throw Exception(
          "Firebase에서 $collectionPath를 getListStream 과정에 문제가 발생했습니다. 에러: $e");
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).doc(id).update(data);
      // await _db.collection(collectionPath).doc(id).get();
    } catch (e) {
      Logger().e('Firebase에서 $collectionPath를 update 실패', error: e);
      throw Exception(
          "Firebase에서 $collectionPath를 update 과정에 문제가 발생했습니다. 에러: $e");
    }
  }

  Future<void> delete(String id) async {
    try {
      await _db.collection(collectionPath).doc(id).delete();
      // await _db.collection(collectionPath).doc(id).get();
    } catch (e) {
      Logger().e('Firebase에서 $collectionPath를 delete 실패', error: e);
      throw Exception(
          "Firebase에서 $collectionPath를 delete 과정에 문제가 발생했습니다. 에러: $e");
    }
  }
}
