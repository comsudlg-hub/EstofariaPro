import 'package:flutter/material.dart';
import '../models/usuario_model.dart';

class AuthService {
  // Simulação de login - depois integraremos com Firebase
  static Future<Usuario?> login(String email, String senha) async {
    // Simulação de autenticação
    await Future.delayed(const Duration(seconds: 1));
    
    // Exemplo de usuários (será substituído por Firebase)
    final usuarios = [
      Usuario(
        id: '1',
        nome: 'Estofaria Modelo',
        email: 'estofaria@email.com',
        tipoUsuario: 'estofaria',
        dataCriacao: DateTime.now(),
      ),
      Usuario(
        id: '2', 
        nome: 'Fornecedor Exemplo',
        email: 'fornecedor@email.com',
        tipoUsuario: 'fornecedor',
        dataCriacao: DateTime.now(),
      ),
      Usuario(
        id: '3',
        nome: 'Cliente Final',
        email: 'cliente@email.com', 
        tipoUsuario: 'cliente',
        dataCriacao: DateTime.now(),
      ),
      Usuario(
        id: '4',
        nome: 'Administrador',
        email: 'admin@email.com',
        tipoUsuario: 'admin',
        dataCriacao: DateTime.now(),
      ),
    ];

    try {
      // Encontrar usuário pelo email
      final usuario = usuarios.firstWhere(
        (user) => user.email == email,
      );

      // Simulação de verificação de senha
      if (senha != '123456') {
        throw Exception('Senha incorreta');
      }

      return usuario;
    } catch (e) {
      throw Exception('Usuário não encontrado');
    }
  }

  // Simulação de cadastro
  static Future<Usuario> cadastro(String nome, String email, String senha, String tipoUsuario) async {
    await Future.delayed(const Duration(seconds: 1));
    
    return Usuario(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: nome,
      email: email,
      tipoUsuario: tipoUsuario,
      dataCriacao: DateTime.now(),
    );
  }

  // Redirecionar para dashboard baseado no tipo de usuário
  static void redirectToDashboard(BuildContext context, Usuario usuario) {
    final route = usuario.getDashboardRoute();
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }
}
