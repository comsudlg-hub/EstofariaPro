import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  StreamSubscription<User?>? _authSubscription;

  AuthProvider() {
    _authSubscription = _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _onAuthStateChanged(User? user) async {
    if (user == null) {
      _currentUser = null;
    } else {
      _currentUser = await _userRepository.getUserById(user.uid);
    }
    notifyListeners();
  }

  // ================= LOGIN =================
  Future<bool> loginUser({
    required String email,
    required String senha,
  }) async {
    _setLoading(true);
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final uid = credential.user?.uid;
      if (uid != null) {
        _currentUser = await _userRepository.getUserById(uid);
        if (_currentUser == null) {
          await _auth.signOut(); // Ajuste: Desloga se o usuário não existe no DB para evitar estado inconsistente.
          _errorMessage = "Usuário não encontrado no banco de dados.";
          _setLoading(false);
          return false;
        }
      }

      _errorMessage = null;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Erro ao fazer login.";
      _setLoading(false);
      return false;
    }
  }

  // ================= REGISTER =================
  Future<bool> registerUser({
    required UserModel user,
    required String senha,
  }) async {
    _setLoading(true);
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: senha,
      );

      final uid = credential.user?.uid;
      if (uid == null) throw Exception("Erro ao obter UID do usuário");

      final userWithId = user.copyWith(uid: uid);
      await _userRepository.createUser(userWithId);

      _currentUser = userWithId;
      _errorMessage = null;

      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Erro ao cadastrar usuário.";
      _setLoading(false);
      return false;
    }
  }

  // ================= LOGOUT =================
  Future<void> logoutUser() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // ================= HELPERS =================
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
