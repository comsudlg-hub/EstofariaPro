import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  /// Cria usuário
  Future<void> createUser(UserModel user) async {
    await usersRef.doc(user.uid).set(user.toMap());
  }

  /// Atualiza usuário
  Future<void> updateUser(UserModel user) async {
    await usersRef.doc(user.uid).update(user.toMap());
  }

  /// Atualiza role/tipo do usuário
  Future<void> updateUserRole(String uid, String role) async {
    await usersRef.doc(uid).update({'tipo': role});
  }

  /// Busca usuário pelo UID
  Future<UserModel?> getUserById(String uid) async {
    final doc = await usersRef.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  /// Retorna todos os usuários
  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await usersRef.get();
    return snapshot.docs
        .map((d) => UserModel.fromMap(d.data() as Map<String, dynamic>, d.id))
        .toList();
  }

  /// Exclui usuário
  Future<void> deleteUser(String uid) async {
    await usersRef.doc(uid).delete();
  }
}
