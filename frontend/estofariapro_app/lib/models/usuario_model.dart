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

  // Converter para Map (para Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'tipoUsuario': tipoUsuario,
      'dataCriacao': dataCriacao.toIso8601String(),
    };
  }

  // Criar a partir de Map (do Firebase)
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      tipoUsuario: map['tipoUsuario'],
      dataCriacao: DateTime.parse(map['dataCriacao']),
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
