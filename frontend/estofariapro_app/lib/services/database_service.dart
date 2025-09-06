import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cria usuário no Firestore
  Future<void> criarUsuario(Usuario usuario) async {
    await _firestore.collection('usuarios').doc(usuario.id).set(usuario.toMap());
  }

  // Recupera dados de um usuário pelo UID
  Future<Usuario> getUsuario(String uid) async {
    final doc = await _firestore.collection('usuarios').doc(uid).get();
    if (doc.exists) {
      return Usuario.fromMap(doc.data()!);
    } else {
      throw Exception('Usuário não encontrado');
    }
  }
}
