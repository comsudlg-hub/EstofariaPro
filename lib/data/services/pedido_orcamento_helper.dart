// lib/data/services/pedido_orcamento_helper.dart
import 'dart:typed_data';
import 'dart:io' show File;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class PedidoOrcamentoHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// --------------------------------------------
  /// Método original: cria pedido de orçamento com contador transacional
  /// Retorna {'docId': docId, 'pedidoIdCompleto': pedidoIdCompleto}
  /// --------------------------------------------
  Future<Map<String, String>> criarPedidoOrcamento({
    required String estofariaId,
    String? clienteId, // Ajuste solicitado: Adicionado clienteId opcional
  }) async {
    try {
      final now = DateTime.now();
      final anoMes = "${now.year}${now.month.toString().padLeft(2, '0')}";

      final counterRef = _firestore
          .collection('counters')
          .doc(estofariaId)
          .collection('pedidos_orcamento')
          .doc(anoMes);

      final result = await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(counterRef);
        int current = 0;
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>?;
          current = (data?['current'] ?? 0) as int;
        }

        final novoSeq = current + 1;
        transaction.set(counterRef, {'current': novoSeq}, SetOptions(merge: true));

        // ID padronizado: PO-yyyymm-####-ESTO
        final estofariaIdCurto =
            estofariaId.length >= 4 ? estofariaId.substring(0, 4).toUpperCase() : estofariaId.toUpperCase();
        final pedidoIdCompleto =
            'PO-$anoMes-${novoSeq.toString().padLeft(4, '0')}-$estofariaIdCurto';

        final pedidosRef = _firestore.collection('pedidos_orcamento').doc();
        transaction.set(pedidosRef, {
          'pedidoIdCompleto': pedidoIdCompleto,
          'estofariaId': estofariaId,
          'clienteId': clienteId ?? estofariaId, // Ajuste solicitado: Salva o ID do cliente. Se nulo, assume que a própria estofaria é o cliente (balcão).
          'createdAt': FieldValue.serverTimestamp(),
          'status': 'rascunho',
          'stepCompleted': 0,
        });

        return {
          'docId': pedidosRef.id,
          'pedidoIdCompleto': pedidoIdCompleto,
        };
      });

      return Map<String, String>.from(result);
    } catch (e) {
      rethrow;
    }
  }

  /// --------------------------------------------
  /// LEGADO: salvarStep1 (mantido para compatibilidade)
  /// Tenta um update; se documento não existir, faz set com merge:true
  /// --------------------------------------------
  Future<void> salvarStep1({
    required String docId,
    required Map<String, dynamic> dadosCliente,
  }) async {
    try {
      // Tentar update (presumindo que o doc foi criado no criarPedidoOrcamento)
      await _firestore.collection('pedidos_orcamento').doc(docId).update({
        'dadosCliente': dadosCliente,
        'stepCompleted': 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Se falhar (ex.: doc não existe), criar com merge para não sobrescrever
      await _firestore.collection('pedidos_orcamento').doc(docId).set({
        'dadosCliente': dadosCliente,
        'stepCompleted': 1,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  /// --------------------------------------------
  /// LEGADO: salvarStep2 — assinatura compatível com código legado
  /// (servicos: List<String>, estofados: Map<String,int>, detalhes optional)
  /// --------------------------------------------
  Future<void> salvarStep2({
    required String docId,
    required List<String> servicos,
    required Map<String, int> estofados,
    String? detalhes,
  }) async {
    try {
      final payload = {
        'servicos': servicos,
        'estofados': estofados,
        if (detalhes != null) 'detalhes_servico': detalhes,
        'stepCompleted': 2,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('pedidos_orcamento').doc(docId).set(payload, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  /// --------------------------------------------
  /// Conveniência mais flexível para salvar serviços (usado pelo novo UI)
  /// recebe servicos como Map<String,dynamic> (payload completo)
  /// --------------------------------------------
  Future<void> salvarServicos({
    required String docId,
    required Map<String, dynamic> servicos,
  }) async {
    try {
      await _firestore.collection('pedidos_orcamento').doc(docId).set({
        'servicos': servicos,
        'stepCompleted': 2,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  /// --------------------------------------------
  /// salvarFotos: aceita:
  /// - List<String> (URLs) -> apenas grava as URLs no documento
  /// - List<Uint8List> / Uint8List (bytes) -> faz upload
  /// - List<File> / File -> comprime (mobile) e faz upload
  ///
  /// Compatível com casos em que a UI já fez upload e passa URLs,
  /// ou com casos em que a UI passa arquivos/bytes para o helper subir.
  /// --------------------------------------------
  Future<void> salvarFotos({
    required String docId,
    required List<dynamic> fotos,
  }) async {
    try {
      final List<String> urls = [];

      for (var foto in fotos) {
        // Caso a UI já tenha enviado URLs (String começando com http)
        if (foto is String && (foto.startsWith('http://') || foto.startsWith('https://'))) {
          urls.add(foto);
          continue;
        }

        // Upload se vier bytes (web ou código que envia bytes)
        if (kIsWeb && foto is Uint8List) {
          final ref = _storage.ref().child("pedidos_orcamento/$docId/${DateTime.now().millisecondsSinceEpoch}.jpg");
          await ref.putData(foto, SettableMetadata(contentType: "image/jpeg"));
          final url = await ref.getDownloadURL();
          urls.add(url);
          continue;
        }

        // Upload se vier File (mobile)
        if (foto is File) {
          Uint8List? compressedBytes;
          try {
            compressedBytes = await FlutterImageCompress.compressWithFile(
              foto.absolute.path,
              quality: 75,
            ) as Uint8List?;
          } catch (_) {
            // fallback para leitura direta
            compressedBytes = await foto.readAsBytes();
          }
          final data = compressedBytes ?? await foto.readAsBytes();
          final ref = _storage.ref().child("pedidos_orcamento/$docId/${DateTime.now().millisecondsSinceEpoch}.jpg");
          await ref.putData(data, SettableMetadata(contentType: "image/jpeg"));
          final url = await ref.getDownloadURL();
          urls.add(url);
          continue;
        }

        // Caso venha Uint8List fora do web (tratamos como bytes)
        if (foto is Uint8List) {
          final ref = _storage.ref().child("pedidos_orcamento/$docId/${DateTime.now().millisecondsSinceEpoch}.jpg");
          
          // Ajuste solicitado: Adicionada a lógica de compressão para Uint8List.
          Uint8List? compressedBytes;
          try {
            // Tenta comprimir os bytes recebidos
            compressedBytes = await FlutterImageCompress.compressWithList(
              foto,
              quality: 75,
            );
          } catch (_) {
            // Se a compressão falhar, usa os bytes originais
            compressedBytes = foto;
          }

          await ref.putData(compressedBytes, SettableMetadata(contentType: "image/jpeg"));
          final url = await ref.getDownloadURL();
          urls.add(url);
          continue;
        }

        // Se chegar aqui, tipo não suportado — ignora ou lança
        // Optamos por ignorar silenciosamente para compatibilidade
      }

      // Se preferir manter append em vez de substituir, usar arrayUnion,
      // mas para previsibilidade aqui gravamos a lista completa (merge).
      await _firestore.collection('pedidos_orcamento').doc(docId).set({
        'fotos': FieldValue.arrayUnion(urls),
        'stepCompleted': 3,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  /// --------------------------------------------
  /// confirmarPedido (mantendo assinatura original)
  /// Atualiza status/stepCompleted
  /// Ajuste solicitado: Adicionado parâmetro de status.
  /// --------------------------------------------
  Future<void> confirmarPedido({
    required String docId,
    String status = 'submitted',
  }) async {
    try {
      await _firestore.collection('pedidos_orcamento').doc(docId).set({
        'status': status,
        'stepCompleted': 4,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  /// Alias para compatibilidade com código legado que chamava finalizarPedido
  Future<void> finalizarPedido({
    required String docId,
    String status = 'submitted',
  }) async {
    return confirmarPedido(docId: docId, status: status);
  }

  /// --------------------------------------------
  /// Métodos auxiliares adicionais (compatibilidade)
  /// - salvarDadosCliente: mesma função que salvarStep1, por conveniência do novo UI
  /// --------------------------------------------
  Future<void> salvarDadosCliente({
    required String docId,
    required Map<String, dynamic> dadosCliente,
  }) async {
    return salvarStep1(docId: docId, dadosCliente: dadosCliente);
  }
}
