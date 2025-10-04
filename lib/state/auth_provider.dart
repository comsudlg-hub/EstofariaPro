import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:typed_data';

import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';
import '../data/services/storage_service.dart';

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

  // ================= UPDATE USER =================
  Future<bool> updateUserData(UserModel updatedUser) async {
    _setLoading(true);
    try {
      await _userRepository.updateUser(updatedUser);
      _currentUser = updatedUser; // Atualiza o usuário localmente
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = "Erro ao atualizar dados: ${e.toString()}";
      _setLoading(false);
      return false;
    }
  }

  // ================= UPDATE USER PROFILE (WITH IMAGES) =================
  Future<bool> updateUserProfile({
    required String nome,
    required String telefone,
    required String empresa,
    Uint8List? fotoBytes,
    Uint8List? logoBytes,
  }) async {
    if (currentUser == null) {
      _errorMessage = "Nenhum usuário logado para atualizar.";
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      // Instancia o StorageService para fazer o upload
      final storageService = StorageService();
      String? newFotoUrl;
      if (fotoBytes != null) {
        final path = 'users/${currentUser!.uid}/profile_photo.jpg';
        newFotoUrl = await storageService.uploadBytes(path, fotoBytes);
      }

      String? newLogoUrl;
      if (logoBytes != null) {
        final path = 'users/${currentUser!.uid}/company_logo.jpg';
        newLogoUrl = await storageService.uploadBytes(path, logoBytes);
      }

      final updatedUser = currentUser!.copyWith(
        nome: nome,
        telefone: telefone,
        empresa: empresa,
        fotoUrl: newFotoUrl, // Usa a nova URL se o upload foi feito, senão mantém a antiga via copyWith
        logoUrl: newLogoUrl, // Usa a nova URL se o upload foi feito, senão mantém a antiga via copyWith
      );

      // Chama o método que atualiza o Firestore e o estado local
      return await updateUserData(updatedUser);
    } catch (e) {
      _errorMessage = "Erro ao atualizar perfil: $e";
      _setLoading(false);
      return false;
    }
    // O _setLoading(false) já é chamado dentro do updateUserData em caso de sucesso.
  }

  // ================= CHANGE PASSWORD =================
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw FirebaseAuthException(code: 'user-not-found');
      }

      // Reautentica o usuário para confirmar a identidade
      final cred = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
      await user.reauthenticateWithCredential(cred);

      // Se a reautenticação for bem-sucedida, atualiza a senha
      await user.updatePassword(newPassword);

      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Ocorreu um erro.";
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = "Ocorreu um erro inesperado.";
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
