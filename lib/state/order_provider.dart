import 'package:flutter/foundation.dart';
import '../data/models/order_model.dart';
import '../data/repositories/order_repository.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repository = OrderRepository();
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  // Ajuste solicitado: campo de erro para exibir mensagens no form
  String? errorMessage;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();
    try {
      _orders = await _repository.getAllOrders();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrder(OrderModel order) async {
    await _repository.saveOrder(order);
    _orders.add(order);
    notifyListeners();
  }

  Future<void> updateOrderStatus(String id, String status) async {
    final idx = _orders.indexWhere((o) => o.id == id);
    if (idx != -1) {
      final updated = _orders[idx].copyWith(status: status);
      await _repository.saveOrder(updated);
      _orders[idx] = updated;
      notifyListeners();
    }
  }

  Future<void> deleteOrder(String id) async {
    await _repository.deleteOrder(id);
    _orders.removeWhere((o) => o.id == id);
    notifyListeners();
  }

  // Ajuste solicitado: resetar lista local
  void resetPedido() {
    _orders = [];
    notifyListeners();
  }

  // Ajuste solicitado: método usado pelo form para criar pedido
  Future<void> criarPedido(Map<String, dynamic> dadosCliente, Map<String, dynamic> dadosServicos) async {
    try {
      final order = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        clienteId: dadosCliente['clienteId'] ?? '',   // Ajuste solicitado
        estofariaId: dadosServicos['estofariaId'] ?? '', // Ajuste solicitado
        fornecedorId: dadosServicos['fornecedorId'],     // Ajuste solicitado
        status: 'pending',
        criadoEm: DateTime.now(),
      );

      await _repository.saveOrder(order);
      _orders.add(order);
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
