import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = userCredential.user?.uid;

      if (uid != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        final userData = snapshot.data();
        final userType = userData?['tipo'] as String?;

        if (!mounted) return;

        switch (userType) {
          case 'pessoaFisica':
            context.go('/client-dashboard');
            break;
          case 'pessoaJuridicaEstofaria':
            context.go('/estofaria-dashboard');
            break;
          case 'pessoaJuridicaFornecedor':
            context.go('/fornecedor-dashboard');
            break;
          default:
            context.go('/admin-dashboard');
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? "Erro ao fazer login.";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Cabeçalho
                  Icon(
                    Icons.chair_alt,
                    size: 72,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Estofaria Pro",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Na medida certa para a sua empresa",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Campo de e-mail
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: "E-mail",
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Digite seu e-mail";
                                }
                                if (!value.contains('@')) {
                                  return "E-mail inválido";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Campo de senha
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: "Senha",
                                prefixIcon: const Icon(Icons.lock),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  tooltip: _obscurePassword
                                      ? "Mostrar senha"
                                      : "Ocultar senha",
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Digite sua senha";
                                }
                                if (value.length < 6) {
                                  return "Senha deve ter pelo menos 6 caracteres";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Mensagem de erro
                            if (_errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                            // Botão Entrar
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: _isLoading ? null : _login,
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text("Entrar"),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Links
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => context.go('/reset-password'),
                                child: const Text("Esqueci minha senha"),
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go('/register'),
                              child: const Text("Não tem conta? Cadastre-se"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Rodapé
                  SafeArea(
                    top: false,
                    child: Text(
                      "© 2025 Compersonalite Soluções Estratégicas",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
