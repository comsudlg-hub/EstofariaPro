import 'package:flutter/foundation.dart';
import '../data/models/budget_model.dart';
import '../data/repositories/budget_repository.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetRepository _repository = BudgetRepository();
  List<BudgetModel> _budgets = [];
  bool _isLoading = false;

  List<BudgetModel> get budgets => _budgets;
  bool get isLoading => _isLoading;

  Future<void> fetchBudgets() async {
    _isLoading = true;
    notifyListeners();
    try {
      _budgets = await _repository.getAllBudgets();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBudget(BudgetModel budget) async {
    await _repository.saveBudget(budget);
    _budgets.add(budget);
    notifyListeners();
  }

  Future<void> updateBudgetStatus(String id, String status) async {
    final idx = _budgets.indexWhere((b) => b.id == id);
    if (idx != -1) {
      final updated = _budgets[idx].copyWith(status: status);
      await _repository.saveBudget(updated);
      _budgets[idx] = updated;
      notifyListeners();
    }
  }

  Future<void> deleteBudget(String id) async {
    await _repository.deleteBudget(id);
    _budgets.removeWhere((b) => b.id == id);
    notifyListeners();
  }
}
