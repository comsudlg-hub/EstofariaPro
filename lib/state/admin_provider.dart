import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';

class AdminProvider extends ChangeNotifier {
  final UserRepository _repository = UserRepository();
  List<UserModel> _users = [];
  bool _isLoading = false;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _users = await _repository.getAllUsers();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser(String uid) async {
    await _repository.deleteUser(uid);
    _users.removeWhere((u) => u.uid == uid);
    notifyListeners();
  }
}
