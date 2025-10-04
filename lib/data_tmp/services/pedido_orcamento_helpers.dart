import 'dart:io' if (dart.library.html) 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class PedidoOrcamentoHelpers {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String origem = "cliente";

  Future<void> init() async {
    final user = _auth.currentUser;
    origem = user != null ? "cliente" : "estofaria";
  }

  Future<Map<String, dynamic>> criarPedido(
    Map<String, dynamic> dadosCliente,
    Map<String, dynamic> dadosServicos,
  ) async {
    await init();
    final user = _auth.currentUser;
    final now = DateTime.now();
    final mes = now.month.toString().padLeft(2, "0");
    final ano = now.year.toString().substring(2);

    // sequencial atômico
    final counterRef = _firestore.collection('counters').doc('pedidos_${ano}${mes}');
    int novoSequencial = await _firestore.runTransaction<int>((tx) async {
      final snap = await tx.get(counterRef);
      if (!snap.exists) {
        tx.set(counterRef, {'seq': 1});
        return 1;
      } else {
        final current = (snap.data()?['seq'] ?? 0) as int;
        final next = current + 1;
        tx.update(counterRef, {'seq': next});
        return next;
      }
    });
    final sequencialStr = novoSequencial.toString().padLeft(4, "0");

    final pedidoIdCompleto = "PO$sequencialStr$mes$ano";

    final pedido = {
      "prefixo": "PO",
      "sequencial": sequencialStr,
      "mes": mes,
      "ano": ano,
      "pedidoIdCompleto": pedidoIdCompleto,
      "status": "rascunho",
      "stepCompleted": 1,
      "origem": origem,
      "dataCriacao": Timestamp.now(),
      "clienteId": dadosCliente["clienteId"] ?? user?.uid ?? "",
      "dadosCliente": dadosCliente,
      "dadosServicos": dadosServicos,
    };

    try {
      await _firestore.collection("pedidos_orcamento").doc(pedidoIdCompleto).set(pedido);
      return pedido;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> salvarFotos(String pedidoId, List<dynamic> fotos) async {
    try {
      for (var foto in fotos) {
        final ref = _storage.ref("pedidos/$pedidoId/${DateTime.now().millisecondsSinceEpoch}.jpg");
        if (kIsWeb && foto is Uint8List) {
          await ref.putData(foto, SettableMetadata(contentType: "image/jpeg"));
        } else if (foto is File) {
          final compressed = await FlutterImageCompress.compressWithFile(
            foto.path,
            quality: 70,
          );
          await ref.putData(compressed!, SettableMetadata(contentType: "image/jpeg"));
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> alterarStatus(String pedidoId, String novoStatus) async {
    try {
      await _firestore.collection("pedidos_orcamento").doc(pedidoId).update({
        "status": novoStatus,
        "dataAtualizacao": Timestamp.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> listarPedidosPorCliente(String clienteId) async {
    try {
      final snapshot = await _firestore
          .collection("pedidos_orcamento")
          .where("clienteId", isEqualTo: clienteId)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> listarTodosPedidos() async {
    try {
      final snapshot = await _firestore.collection("pedidos_orcamento").get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      rethrow;
    }
  }
}
