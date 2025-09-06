import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/usuario_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Converter Firebase User para nosso User Model
  Usuario? _userFromFirebaseUser(User? user) {
    return user != null ? Usuario(
      id: user.uid,
      nome: user.displayName ?? 'Usuário',
      email: user.email ?? '',
      tipoUsuario: 'cliente', // Default - será atualizado no Firestore
      dataCriacao: DateTime.now(),
    ) : null;
  }

  // Stream de mudanças de autenticação
  Stream<Usuario?> get user {
    return _auth.authStateChanges().asyncMap(_userFromFirebaseUser);
  }

  // Login com email e senha
  Future<Usuario?> login(String email, String senha) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print('Erro no login: $e');
      rethrow;
    }
  }

  // Cadastro com email e senha
  Future<Usuario> cadastro(String nome, String email, String senha, String tipoUsuario) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      User? user = result.user;
      
      // Salvar informações adicionais no Firestore
      if (user != null) {
        await _firestore.collection('usuarios').doc(user.uid).set({
          'nome': nome,
          'email': email,
          'tipoUsuario': tipoUsuario,
          'dataCriacao': DateTime.now(),
        });

        // Atualizar display name
        await user.updateDisplayName(nome);
      }

      return _userFromFirebaseUser(user)!;
    } catch (e) {
      print('Erro no cadastro: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Erro no logout: $e');
      rethrow;
    }
  }

  // Recuperar senha
  Future<void> recuperarSenha(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Erro ao recuperar senha: $e');
      rethrow;
    }
  }

  // Redirecionar para dashboard baseado no tipo de usuário
  static void redirectToDashboard(BuildContext context, Usuario usuario) {
    final route = usuario.getDashboardRoute();
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

  // Get user data from Firestore
  Future<Usuario> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('usuarios').doc(uid).get();
      
      if (doc.exists) {
        return Usuario.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('Usuário não encontrado no Firestore');
      }
    } catch (e) {
      print('Erro ao buscar dados do usuário: $e');
      rethrow;
    }
  }
}