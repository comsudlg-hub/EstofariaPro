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
  final _cpfCnpjController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  String _pessoaTipo = 'PF'; // PF ou PJ
  String _papel = 'cliente'; // cliente / estofaria / fornecedor
  bool _isLoading = false;

  void _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_senhaController.text != _confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = AuthService();
      final usuario = await authService.cadastro(
        nome: _nomeController.text,
        email: _emailController.text,
        senha: _senhaController.text,
        pessoaTipo: _pessoaTipo,
        papel: _papel,
        cpfCnpj: _cpfCnpjController.text,
      );

      AuthService.redirectToDashboard(context, usuario);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFebe7dc),
      appBar: AppBar(
        title: Text("Criar Conta", style: GoogleFonts.zenAntiqueSoft(color: const Color(0xFF42585c))),
        backgroundColor: const Color(0xFFebe7dc),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF42585c)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.chair, size: 60, color: const Color(0xFF9C8158)),
              const SizedBox(height: 16),
              Text("EstofariaPro", style: GoogleFonts.zenAntiqueSoft(color: const Color(0xFF42585c), fontSize: 24)),
              const SizedBox(height: 8),
              Text("Crie sua conta", style: GoogleFonts.playfairDisplay(color: const Color(0xFF2f4653), fontSize: 16)),

              const SizedBox(height: 24),
              // Escolha PF/PJ
              DropdownButtonFormField<String>(
                value: _pessoaTipo,
                items: const [
                  DropdownMenuItem(value: 'PF', child: Text('Pessoa Física')),
                  DropdownMenuItem(value: 'PJ', child: Text('Pessoa Jurídica')),
                ],
                onChanged: (value) {
                  setState(() {
                    _pessoaTipo = value!;
                    _papel = _pessoaTipo == 'PF' ? 'cliente' : 'estofaria';
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Tipo de cadastro',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Para PJ, escolher papel
                    if (_pessoaTipo == 'PJ')
                      DropdownButtonFormField<String>(
                        value: _papel,
                        items: const [
                          DropdownMenuItem(value: 'estofaria', child: Text('Estofaria')),
                          DropdownMenuItem(value: 'fornecedor', child: Text('Fornecedor')),
                        ],
                        onChanged: (value) => setState(() => _papel = value!),
                        decoration: InputDecoration(
                          labelText: 'Selecione o tipo de empresa',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(labelText: _pessoaTipo == 'PF' ? 'Nome completo' : 'Nome da empresa', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cpfCnpjController,
                      decoration: InputDecoration(labelText: _pessoaTipo == 'PF' ? 'CPF' : 'CNPJ', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Senha', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Campo obrigatório';
                        if (value.length < 6) return 'Senha deve ter pelo menos 6 caracteres';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmarSenhaController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Confirmar senha', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _cadastrar,
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: const Color(0xFF9C8158)),
                      child: const Text('Criar Conta'),
                    ),
              const SizedBox(height: 20),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Já tem conta? Faça login')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfCnpjController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }
}
