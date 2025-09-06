import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String id;
  final String nome;
  final String email;
  final String pessoaTipo; // 'PF' ou 'PJ'
  final String papel; // 'cliente', 'estofaria', 'fornecedor'
  final String cpfCnpj;
  final DateTime dataCriacao;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.pessoaTipo,
    required this.papel,
    required this.cpfCnpj,
    required this.dataCriacao,
  });

  // Converte Firestore Map em Usuario
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      pessoaTipo: map['pessoaTipo'] ?? 'PF',
      papel: map['papel'] ?? 'cliente',
      cpfCnpj: map['cpfCnpj'] ?? '',
      dataCriacao: (map['dataCriacao'] as Timestamp).toDate(),
    );
  }

  // Converte Usuario em Map para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'pessoaTipo': pessoaTipo,
      'papel': papel,
      'cpfCnpj': cpfCnpj,
      'dataCriacao': dataCriacao,
    };
  }

  // Rota do dashboard baseada no papel
  String getDashboardRoute() {
    switch (papel) {
      case 'cliente':
        return '/dashboard-cliente';
      case 'estofaria':
        return '/dashboard-estofaria';
      case 'fornecedor':
        return '/dashboard-fornecedor';
      default:
        return '/';
    }
  }
}
