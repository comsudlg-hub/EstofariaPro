import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserModel user) async {
    await _usersCollection.doc(user.uid).set(user.toMap());
  }

  Future<void> updateUser(UserModel user) async {
    await _usersCollection.doc(user.uid).update(user.toMap());
  }

  Future<void> updateUserRole(String uid, String role) async {
    await _usersCollection.doc(uid).update({'tipo': role});
  }

  Future<UserModel?> getUserById(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<List<UserModel>> getUsers() async {
    final querySnapshot = await _usersCollection.get();
    return querySnapshot.docs
        .map((doc) => UserModel.fromMap(doc.data()))
        .toList();
  }
}
