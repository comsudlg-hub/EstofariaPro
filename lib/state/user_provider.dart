import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ================= FETCH =================
  Future<void> loadUser(String uid) async {
    _setLoading(true);
    try {
      _user = await _userRepository.getUserById(uid);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Erro ao carregar usuário: $e";
    } finally {
      _setLoading(false);
    }
  }

  // ================= UPDATE =================
  Future<bool> updateUser(UserModel updatedUser) async {
    _setLoading(true);
    try {
      await _userRepository.updateUser(updatedUser);
      _user = updatedUser;
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = "Erro ao atualizar usuário: $e";
      _setLoading(false);
      return false;
    }
  }

  // ================= UPDATE ROLE =================
  Future<bool> updateUserRole(String uid, String role) async {
    _setLoading(true);
    try {
      await _userRepository.updateUserRole(uid, role);
      if (_user != null && _user!.uid == uid) {
        _user = _user!.copyWith(tipo: role);
      }
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = "Erro ao atualizar papel do usuário: $e";
      _setLoading(false);
      return false;
    }
  }

  // ================= HELPERS =================
  void clearUser() {
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
