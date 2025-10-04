import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> setDocument(
      String collection, String docId, Map<String, dynamic> data) async {
    await _db.collection(collection).doc(docId).set(data);
  }

  Future<Map<String, dynamic>?> getDocument(
      String collection, String docId) async {
    final doc = await _db.collection(collection).doc(docId).get();
    return doc.exists ? doc.data() : null;
  }

  Future<void> updateDocument(
      String collection, String docId, Map<String, dynamic> data) async {
    await _db.collection(collection).doc(docId).update(data);
  }

  Future<void> deleteDocument(String collection, String docId) async {
    await _db.collection(collection).doc(docId).delete();
  }

  Future<List<Map<String, dynamic>>> getCollection(String collection) async {
    final snapshot = await _db.collection(collection).get();
    return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }
}
