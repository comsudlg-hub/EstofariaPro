import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String fornecedorId;
  final String nome;
  final String descricao;
  final double preco;
  final DateTime criadoEm;

  ProductModel({
    required this.id,
    required this.fornecedorId,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.criadoEm,
  });

  factory ProductModel.empty() {
    return ProductModel(
      id: '',
      fornecedorId: '',
      nome: '',
      descricao: '',
      preco: 0.0,
      criadoEm: DateTime.now(),
    );
  }

  ProductModel copyWith({
    String? id,
    String? fornecedorId,
    String? nome,
    String? descricao,
    double? preco,
    DateTime? criadoEm,
  }) {
    return ProductModel(
      id: id ?? this.id,
      fornecedorId: fornecedorId ?? this.fornecedorId,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      preco: preco ?? this.preco,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fornecedorId': fornecedorId,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'criadoEm': Timestamp.fromDate(criadoEm),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      fornecedorId: map['fornecedorId'] ?? '',
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      preco: (map['preco'] ?? 0).toDouble(),
      criadoEm: map['criadoEm'] is Timestamp
          ? (map['criadoEm'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
