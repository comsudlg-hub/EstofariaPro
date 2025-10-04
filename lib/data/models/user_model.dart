import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String nome;
  final String email;
  final String telefone;
  final String? empresa;
  final String? cnpj;
  final String? representante;
  final String tipo;
  final Map<String, dynamic>? endereco;
  final DateTime criadoEm;
  final String? login; // campo opcional de login
  final String? logoUrl;
  final String? fotoUrl;
  final bool isAdmin;

  UserModel({
    required this.uid,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.tipo,
    required this.criadoEm,
    this.empresa,
    this.cnpj,
    this.representante,
    this.endereco,
    this.login,
    this.logoUrl,
    this.fotoUrl,
    this.isAdmin = false,
  });

  /// copyWith para atualizar campos sem perder os existentes
  UserModel copyWith({
    String? uid,
    String? nome,
    String? email,
    String? telefone,
    String? empresa,
    String? cnpj,
    String? representante,
    String? tipo,
    Map<String, dynamic>? endereco,
    DateTime? criadoEm,
    String? login,
    String? logoUrl,
    String? fotoUrl,
    bool? isAdmin,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      empresa: empresa ?? this.empresa,
      cnpj: cnpj ?? this.cnpj,
      representante: representante ?? this.representante,
      tipo: tipo ?? this.tipo,
      endereco: endereco ?? this.endereco,
      criadoEm: criadoEm ?? this.criadoEm,
      login: login ?? this.login,
      logoUrl: logoUrl ?? this.logoUrl,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  /// Converte para Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'empresa': empresa,
      'cnpj': cnpj,
      'representante': representante,
      'tipo': tipo,
      'endereco': endereco,
      'criadoEm': Timestamp.fromDate(criadoEm),
      'login': login,
      'logoUrl': logoUrl,
      'fotoUrl': fotoUrl,
      'isAdmin': isAdmin,
    };
  }

  /// Constrói a partir do Firestore
  factory UserModel.fromMap(Map<String, dynamic> map, [String? id]) {
    return UserModel(
      uid: id ?? map['uid'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'] ?? '',
      empresa: map['empresa'],
      cnpj: map['cnpj'],
      representante: map['representante'],
      tipo: map['tipo'] ?? 'pessoaFisica',
      endereco: map['endereco'],
      criadoEm: (map['criadoEm'] is Timestamp)
          ? (map['criadoEm'] as Timestamp).toDate()
          : DateTime.tryParse(map['criadoEm']?.toString() ?? '') ??
              DateTime.now(),
      login: map['login'],
      logoUrl: map['logoUrl'],
      fotoUrl: map['fotoUrl'],
      isAdmin: map['isAdmin'] ?? false,
    );
  }
}
