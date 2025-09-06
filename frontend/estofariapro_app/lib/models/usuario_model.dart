import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String id;
  final String nome;
  final String email;
  final String tipoUsuario; // 'estofaria', 'fornecedor', 'cliente', 'admin'
  final DateTime dataCriacao;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.tipoUsuario,
    required this.dataCriacao,
  });

  // Converter para Map (para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'tipoUsuario': tipoUsuario,
      'dataCriacao': Timestamp.fromDate(dataCriacao),
    };
  }

  // Criar a partir de Map (do Firestore)
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      tipoUsuario: map['tipoUsuario'] ?? 'cliente',
      dataCriacao: (map['dataCriacao'] as Timestamp).toDate(),
    );
  }

  // Método para redirecionar para o dashboard correto
  String getDashboardRoute() {
    switch (tipoUsuario) {
      case 'estofaria':
        return '/dashboard-estofaria';
      case 'fornecedor':
        return '/dashboard-fornecedor';
      case 'cliente':
        return '/dashboard-cliente';
      case 'admin':
        return '/dashboard-admin';
      default:
        return '/login';
    }
  }
}