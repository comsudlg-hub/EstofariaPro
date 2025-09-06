class Usuario {
  final String uid;
  final String nome;
  final String email;
  final String pessoaTipo; // 'pf' ou 'pj'
  final String papel; // 'cliente', 'estofaria' ou 'fornecedor'
  final String? cpf;
  final String? cnpj;
  final DateTime createdAt;

  Usuario({
    required this.uid,
    required this.nome,
    required this.email,
    required this.pessoaTipo,
    required this.papel,
    this.cpf,
    this.cnpj,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nome': nome,
      'email': email,
      'pessoaTipo': pessoaTipo,
      'papel': papel,
      'cpf': cpf,
      'cnpj': cnpj,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      uid: map['uid'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      pessoaTipo: map['pessoaTipo'] ?? 'pf',
      papel: map['papel'] ?? 'cliente',
      cpf: map['cpf'],
      cnpj: map['cnpj'],
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
