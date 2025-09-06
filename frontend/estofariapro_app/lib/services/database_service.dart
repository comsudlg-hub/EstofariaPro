import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cria ou atualiza o perfil do usuário
  Future<void> createUserProfile(Usuario usuario) async {
    await _firestore.collection('usuarios').doc(usuario.uid).set(usuario.toMap());
  }

  // Busca o perfil do usuário pelo UID
  Future<Usuario?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('usuarios').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return Usuario.fromMap(doc.data()!);
    }
    return null;
  }
}
