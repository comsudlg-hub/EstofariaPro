import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderRepository {
  final CollectionReference _ordersCollection =
      FirebaseFirestore.instance.collection('pedidos_orcamento');

  Future<void> saveOrder(OrderModel order) async {
    await _ordersCollection.doc(order.id).set(order.toMap());
  }

  Future<OrderModel?> getOrderById(String id) async {
    final doc = await _ordersCollection.doc(id).get();
    if (doc.exists && doc.data() != null) {
      return OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<List<OrderModel>> getAllOrders() async {
    final query = await _ordersCollection.get();
    return query.docs
        .map((doc) =>
            OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> deleteOrder(String id) async {
    await _ordersCollection.doc(id).delete();
  }

  /// Novo: atualiza status do pedido
  Future<void> updateStatus(String id, String status) async {
    await _ordersCollection.doc(id).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Novo: atualiza etapa concluída
  Future<void> updateStep(String id, int step) async {
    await _ordersCollection.doc(id).update({
      'stepCompleted': step,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Novo: retorna pedidos de uma estofaria específica
  Future<List<OrderModel>> getByEstofaria(String estofariaId) async {
    final query = await _ordersCollection
        .where('estofariaId', isEqualTo: estofariaId)
        .orderBy('createdAt', descending: true)
        .get();

    return query.docs
        .map((doc) =>
            OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
