import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String nome;
  final String email;
  final String telefone;
  final String tipo;
  final String? empresa;
  final String? cnpj;
  final String? representante;
  final Map<String, dynamic>? endereco;
  final DateTime criadoEm;

  UserModel({
    required this.uid,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.tipo,
    this.empresa,
    this.cnpj,
    this.representante,
    this.endereco,
    required this.criadoEm,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'tipo': tipo,
      'empresa': empresa,
      'cnpj': cnpj,
      'representante': representante,
      'endereco': endereco,
      'criadoEm': Timestamp.fromDate(criadoEm),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'] ?? '',
      tipo: map['tipo'] ?? '',
      empresa: map['empresa'],
      cnpj: map['cnpj'],
      representante: map['representante'],
      endereco: map['endereco'] != null
          ? Map<String, dynamic>.from(map['endereco'])
          : null,
      criadoEm: (map['criadoEm'] as Timestamp).toDate(),
    );
  }
}
