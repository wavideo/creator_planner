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

  // 데이터 추가
  Future<void> addData(String id, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).doc(id).set(data);
      await _db.collection(collectionPath).doc(id).get();
    } catch (e) {
      Logger().e('Firebase에서 $collectionPath를 add 실패', error: e);
      throw Exception("Firebase에서 $collectionPath를 add 과정에 문제가 발생했습니다. 에러: $e");
    }
  }

  // 데이터 추가 (유저 식별)
  Future<void> addUserData(String id, Map<String, dynamic> data) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Logger().e('사용자가 로그인하지 않았습니다.');
        throw Exception("로그인된 사용자가 없습니다.");
      }
      data['userId'] = userId;

      await _db.collection(collectionPath).doc(id).set(data);
    } catch (e) {
      Logger().e('Firebase에서 $collectionPath를 add 실패', error: e);
      throw Exception("Firebase에서 $collectionPath를 add 과정에 문제가 발생했습니다. 에러: $e");
    }
  }

  // 데이터 읽기
  Future<T?> getData(
      String id, T Function(Map<String, dynamic>) fromMap) async {
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

  // 실시간으로 데이터 리스트 읽어오기
  Stream<List<T>> getDatasStream(T Function(Map<String, dynamic>) fromMap) {
    try {
      return _db.collection(collectionPath).snapshots().map(
        (querySnapshot) {
          return querySnapshot.docs.map((doc) => fromMap(doc.data())).toList();
        },
      );
    } catch (e) {
      Logger().e('Firebase에서 $collectionPath를 getListStream 실패', error: e);
      throw Exception(
          "Firebase에서 $collectionPath를 getListStream 과정에 문제가 발생했습니다. 에러: $e");
    }
  }

  // 실시간으로 데이터 리스트 읽어오기 (유저 식별)
  Stream<List<T>> getUserDatasStream(T Function(Map<String, dynamic>) fromMap) {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Logger().e('로그인되지 않은 사용자가 접근했습니다.');
        throw Exception("로그인된 사용자가 없습니다.");
      }

      return _db
          .collection(collectionPath)
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map(
        (querySnapshot) {
          return querySnapshot.docs.map((doc) => fromMap(doc.data())).toList();
        },
      );
    } catch (e) {
      Logger().e('Firebase에서 $collectionPath를 getListStream 실패', error: e);
      throw Exception(
          "Firebase에서 $collectionPath를 getListStream 과정에 문제가 발생했습니다. 에러: $e");
    }
  }

  // 데이터 업데이트
  Future<void> updateData(String id, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).doc(id).update(data);
    } catch (e) {
      Logger().e('Firebase에서 $collectionPath를 update 실패', error: e);
      throw Exception(
          "Firebase에서 $collectionPath를 update 과정에 문제가 발생했습니다. 에러: $e");
    }
  }

  // 데이터 지우기
  Future<void> deleteData(String id) async {
    try {
      await _db.collection(collectionPath).doc(id).delete();
    } catch (e) {
      Logger().e('Firebase에서 $collectionPath를 delete 실패', error: e);
      throw Exception(
          "Firebase에서 $collectionPath를 delete 과정에 문제가 발생했습니다. 에러: $e");
    }
  }

  // 모든 데이터 지우기 (유저 식별)
  Future<void> deleteUserDatas() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Logger().e('로그인되지 않은 사용자가 접근했습니다.');
        throw Exception("로그인된 사용자가 없습니다.");
      }

      var snapshot = await _db
          .collection(collectionPath)
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      Logger().e('Firebase에서 $collectionPath를 delete 실패', error: e);
      throw Exception(
          "Firebase에서 $collectionPath를 delete 과정에 문제가 발생했습니다. 에러: $e");
    }
  }
}
