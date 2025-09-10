import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;           // ID do usuário (do Firebase Auth)
  final String nome;         // Nome completo ou razão social
  final String email;        // E-mail (também usado como login)
  final String cpfCnpj;      // CPF ou CNPJ
  final String pessoaTipo;   // "PF" ou "PJ"
  final String papel;        // Papel do usuário: "cliente", "estofaria", "fornecedor", etc.
  final DateTime dataCriacao; // Timestamp da criação do usuário

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.cpfCnpj,
    required this.pessoaTipo,
    required this.papel,
    required this.dataCriacao,
  });

  /// Converte UserModel para Map (para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'cpfCnpj': cpfCnpj,
      'pessoaTipo': pessoaTipo,
      'papel': papel,
      'dataCriacao': dataCriacao.toUtc(),
    };
  }

  /// Cria UserModel a partir de Map (ao buscar do Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      cpfCnpj: map['cpfCnpj'] ?? '',
      pessoaTipo: map['pessoaTipo'] ?? '',
      papel: map['papel'] ?? '',
      dataCriacao: (map['dataCriacao'] as Timestamp).toDate(),
    );
  }
}
