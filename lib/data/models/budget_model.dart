import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetModel {
  final String id;
  final String clienteId;
  final String estofariaId;
  final double valor;
  final String status; // ex: pending, approved, rejected
  final DateTime criadoEm;

  BudgetModel({
    required this.id,
    required this.clienteId,
    required this.estofariaId,
    required this.valor,
    required this.status,
    required this.criadoEm,
  });

  factory BudgetModel.empty() {
    return BudgetModel(
      id: '',
      clienteId: '',
      estofariaId: '',
      valor: 0.0,
      status: 'pending',
      criadoEm: DateTime.now(),
    );
  }

  BudgetModel copyWith({
    String? id,
    String? clienteId,
    String? estofariaId,
    double? valor,
    String? status,
    DateTime? criadoEm,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      estofariaId: estofariaId ?? this.estofariaId,
      valor: valor ?? this.valor,
      status: status ?? this.status,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clienteId': clienteId,
      'estofariaId': estofariaId,
      'valor': valor,
      'status': status,
      'criadoEm': Timestamp.fromDate(criadoEm),
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map, String id) {
    return BudgetModel(
      id: id,
      clienteId: map['clienteId'] ?? '',
      estofariaId: map['estofariaId'] ?? '',
      valor: (map['valor'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      criadoEm: map['criadoEm'] is Timestamp
          ? (map['criadoEm'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
