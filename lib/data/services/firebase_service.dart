import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator_planner/core/utils/debug.dart';

class FirestoreService<T> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionPath;

  FirestoreService(this.collectionPath);

  Future<void> add(String id, Map<String, dynamic> data) async {
    tryCatch('Firebase에서 $collectionPath를 add', () async {
      await _db.collection(collectionPath).doc(id).set(data);
    });
  }

  Future<T?> get(String id, T Function(Map<String, dynamic>) fromMap) async {
    tryCatch('Firebase에서 $collectionPath를 get', () async {
      DocumentSnapshot doc = await _db.collection(collectionPath).doc(id).get();
      if (doc.exists) {
        return fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  Future<List<T>> getList(T Function(Map<String, dynamic>) fromMap) async {
    tryCatch('Firebase에서 $collectionPath를 getList', () async {
      QuerySnapshot querySnapshot = await _db.collection(collectionPath).get();
      return querySnapshot.docs
          .map((doc) => fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
    return [];
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    tryCatch('Firebase에서 $collectionPath를 update', () async {
      await _db.collection(collectionPath).doc(id).update(data);
    });
  }

  Future<void> delete(String id) async {
    tryCatch('Firebase에서 $collectionPath를 delete', () async {
      await _db.collection(collectionPath).doc(id).delete();
    });
  }
}