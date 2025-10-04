import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Salva um usuário no Firestore
  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore.collection('usuarios').doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Erro ao salvar usuário: $e');
    }
  }

  /// Busca um usuário pelo ID
  Future<UserModel?> getUserById(String id) async {
    try {
      final doc = await _firestore.collection('usuarios').doc(id).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar usuário: $e');
    }
  }

  /// Atualiza os dados de um usuário existente
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('usuarios').doc(user.id).update(user.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar usuário: $e');
    }
  }

  /// Remove um usuário
  Future<void> deleteUser(String id) async {
    try {
      await _firestore.collection('usuarios').doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao deletar usuário: $e');
    }
  }
}
