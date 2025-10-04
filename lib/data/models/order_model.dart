import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String clienteId;
  final String estofariaId;
  final String? fornecedorId;
  final String status; // ex: pending, in_progress, completed
  final DateTime criadoEm;

  OrderModel({
    required this.id,
    required this.clienteId,
    required this.estofariaId,
    this.fornecedorId,
    required this.status,
    required this.criadoEm,
  });

  factory OrderModel.empty() {
    return OrderModel(
      id: '',
      clienteId: '',
      estofariaId: '',
      fornecedorId: null,
      status: 'pending',
      criadoEm: DateTime.now(),
    );
  }

  OrderModel copyWith({
    String? id,
    String? clienteId,
    String? estofariaId,
    String? fornecedorId,
    String? status,
    DateTime? criadoEm,
  }) {
    return OrderModel(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      estofariaId: estofariaId ?? this.estofariaId,
      fornecedorId: fornecedorId ?? this.fornecedorId,
      status: status ?? this.status,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clienteId': clienteId,
      'estofariaId': estofariaId,
      'fornecedorId': fornecedorId,
      'status': status,
      'criadoEm': Timestamp.fromDate(criadoEm),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      clienteId: map['clienteId'] ?? '',
      estofariaId: map['estofariaId'] ?? '',
      fornecedorId: map['fornecedorId'],
      status: map['status'] ?? 'pending',
      criadoEm: map['criadoEm'] is Timestamp
          ? (map['criadoEm'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
