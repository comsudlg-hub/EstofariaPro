import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PedidoOrcamentoHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Cria um novo Pedido de Orçamento e retorna [docId, pedidoIdCompleto]
  static Future<Map<String, String>> criarPedidoOrcamento({
    required String estofariaId,
  }) async {
    final now = DateTime.now();
    final anoMes = DateFormat('yyyyMM').format(now);

    final counterRef = _firestore
        .collection('counters')
        .doc(estofariaId)
        .collection('pedidos_orcamento')
        .doc(anoMes);

    return await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);

      int current = 0;
      if (snapshot.exists) {
        current = snapshot.get('current') as int? ?? 0;
      }

      final novoSeq = current + 1;

      // Atualiza o contador
      transaction.set(counterRef, {'current': novoSeq}, SetOptions(merge: true));

      // Gera ID do pedido com regra definida
      final estofariaIdCurto = estofariaId.substring(0, 4).toUpperCase();
      final pedidoIdCompleto =
          'PO-$anoMes-${novoSeq.toString().padLeft(4, '0')}-$estofariaIdCurto';

      // Cria documento em pedidos_orcamento
      final pedidosRef = _firestore.collection('pedidos_orcamento').doc();
      transaction.set(pedidosRef, {
        'pedidoIdCompleto': pedidoIdCompleto,
        'estofariaId': estofariaId,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'rascunho', // default inicial
        'stepCompleted': 0,
      });

      return {
        'docId': pedidosRef.id,
        'pedidoIdCompleto': pedidoIdCompleto,
      };
    });
  }

  /// Step 1 - Salvar dados do cliente
  static Future<void> salvarStep1({
    required String docId,
    required Map<String, dynamic> dadosCliente,
  }) async {
    await _firestore.collection('pedidos_orcamento').doc(docId).update({
      'dadosCliente': dadosCliente,
      'stepCompleted': 1,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Step 2 - Salvar serviços e estofados
  static Future<void> salvarStep2({
    required String docId,
    required List<String> servicos,
    required Map<String, int> estofados,
    String? detalhes,
  }) async {
    await _firestore.collection('pedidos_orcamento').doc(docId).update({
      'servicos': servicos,
      'estofados': estofados,
      if (detalhes != null) 'detalhes_servico': detalhes,
      'stepCompleted': 2,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Step 3 - Salvar URLs das fotos
  static Future<void> salvarStep3({
    required String docId,
    required List<String> fotosUrls,
  }) async {
    await _firestore.collection('pedidos_orcamento').doc(docId).update({
      'fotos': fotosUrls,
      'stepCompleted': 3,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Step 4 - Finalizar pedido
  static Future<void> finalizarPedido({
    required String docId,
  }) async {
    await _firestore.collection('pedidos_orcamento').doc(docId).update({
      'status': 'submitted',
      'stepCompleted': 4,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
