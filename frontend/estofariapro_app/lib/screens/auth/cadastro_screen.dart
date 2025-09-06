import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../../models/usuario_model.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  String _tipoUsuarioSelecionado = 'cliente';
  bool _isLoading = false;

  void _cadastrar() async {
    if (_formKey.currentState!.validate()) {
      if (_senhaController.text != _confirmarSenhaController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('As senhas não coincidem'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);
      
      try {
        final authService = AuthService();
         final usuario = await authService.cadastro(
          _nomeController.text,
          _emailController.text,
          _senhaController.text,
          _tipoUsuarioSelecionado,
        );
        
        AuthService.redirectToDashboard(context, usuario);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFebe7dc),
      appBar: AppBar(
        title: Text(
          "Criar Conta",
          style: GoogleFonts.zenAntiqueSoft(
            color: const Color(0xFF42585c),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFebe7dc),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF42585c)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Icon(Icons.chair, size: 60, color: const Color(0xFF9C8158)),
              const SizedBox(height: 16),
              Text(
                "EstofariaPro",
                style: GoogleFonts.zenAntiqueSoft(
                  color: const Color(0xFF42585c),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Crie sua conta",
                style: GoogleFonts.playfairDisplay(
                  color: const Color(0xFF2f4653),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                "Selecione o tipo de conta:",
                style: GoogleFonts.roboto(
                  color: const Color(0xFF2f4653),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Seleção de tipo de usuário
              DropdownButtonFormField<String>(
                value: _tipoUsuarioSelecionado,
                items: const [
                  DropdownMenuItem(value: 'cliente', child: Text('Cliente Final')),
                  DropdownMenuItem(value: 'estofaria', child: Text('Estofaria')),
                  DropdownMenuItem(value: 'fornecedor', child: Text('Fornecedor')),
                ],
                onChanged: (value) {
                  setState(() => _tipoUsuarioSelecionado = value!);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF9C8158)),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                        labelText: "Nome completo",
                        labelStyle: GoogleFonts.roboto(color: const Color(0xFF42585c)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF9C8158)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF9C8158), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite seu nome';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: GoogleFonts.roboto(color: const Color(0xFF42585c)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF9C8158)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF9C8158), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite seu email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Senha",
                        labelStyle: GoogleFonts.roboto(color: const Color(0xFF42585c)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF9C8158)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF9C8158), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite sua senha';
                        }
                        if (value.length < 6) {
                          return 'Senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmarSenhaController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirmar senha",
                        labelStyle: GoogleFonts.roboto(color: const Color(0xFF42585c)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF9C8158)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF9C8158), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, confirme sua senha';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _cadastrar,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: const Color(0xFF9C8158),
                      ),
                      child: Text(
                        "Criar Conta",
                        style: GoogleFonts.zenAntiqueSoft(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Já tem conta? Faça login",
                  style: GoogleFonts.roboto(
                    color: const Color(0xFF9C8158),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }
}
