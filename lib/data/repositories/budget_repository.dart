import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/budget_model.dart';

class BudgetRepository {
  final CollectionReference _budgetsCollection =
      FirebaseFirestore.instance.collection('budgets');

  Future<void> saveBudget(BudgetModel budget) async {
    await _budgetsCollection.doc(budget.id).set(budget.toMap());
  }

  Future<BudgetModel?> getBudgetById(String id) async {
    final doc = await _budgetsCollection.doc(id).get();
    if (doc.exists && doc.data() != null) {
      return BudgetModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<List<BudgetModel>> getAllBudgets() async {
    final query = await _budgetsCollection.get();
    return query.docs
        .map((doc) =>
            BudgetModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> deleteBudget(String id) async {
    await _budgetsCollection.doc(id).delete();
  }
}
