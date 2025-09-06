import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _dbService = DatabaseService();

  // Converte Firebase User em Usuario
  Usuario? _userFromFirebaseUser(User? user) {
    if (user == null) return null;
    return Usuario(
      id: user.uid,
      nome: user.displayName ?? 'Usuário',
      email: user.email ?? '',
      pessoaTipo: 'PF',
      papel: 'cliente',
      cpfCnpj: '',
      dataCriacao: DateTime.now(),
    );
  }

  // Stream de autenticação
  Stream<Usuario?> get user => _auth.authStateChanges().asyncMap(_userFromFirebaseUser);

  // Login
  Future<Usuario?> login(String email, String senha) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: senha);
      User? user = result.user;
      if (user == null) return null;

      // Busca papel e dados no Firestore
      final usuario = await _dbService.getUsuario(user.uid);
      return usuario;
    } catch (e) {
      print('Erro no login: $e');
      rethrow;
    }
  }

  // Cadastro PF ou PJ
  Future<Usuario> cadastro({
    required String nome,
    required String email,
    required String senha,
    required String pessoaTipo, // PF ou PJ
    required String papel, // cliente, estofaria, fornecedor
    required String cpfCnpj,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      User? user = result.user;
      if (user == null) throw Exception('Erro ao criar usuário no Firebase Auth');

      await user.updateDisplayName(nome);

      final usuario = Usuario(
        id: user.uid,
        nome: nome,
        email: email,
        pessoaTipo: pessoaTipo,
        papel: papel,
        cpfCnpj: cpfCnpj,
        dataCriacao: DateTime.now(),
      );

      await _dbService.criarUsuario(usuario);

      return usuario;
    } catch (e) {
      print('Erro no cadastro: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async => await _auth.signOut();

  // Recuperar senha
  Future<void> recuperarSenha(String email) async => await _auth.sendPasswordResetEmail(email: email);

  // Redirecionamento para dashboard
  static void redirectToDashboard(BuildContext context, Usuario usuario) {
    final rota = usuario.getDashboardRoute();
    Navigator.pushNamedAndRemoveUntil(context, rota, (route) => false);
  }
}
