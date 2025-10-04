import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/validators.dart';
import '../../../presentation/common_widgets/custom_button.dart';
import '../../../presentation/common_widgets/custom_text_field.dart';
import '../../../state/auth_provider.dart';
import '../../../data/models/user_model.dart';

class NavigationHelper {
  static void redirectUser(UserModel user, BuildContext context) {
    switch (user.tipo) {
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
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.loginUser(
      email: _emailController.text.trim(),
      senha: _senhaController.text.trim(),
    );

    if (success && mounted) {
      final user = authProvider.currentUser!;
      NavigationHelper.redirectUser(user, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();

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
                  Icon(Icons.chair_alt,
                      size: 72, color: theme.colorScheme.primary),
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
                            CustomTextField(
                              controller: _emailController,
                              label: "E-mail",
                              validator: Validators.email,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _senhaController,
                              label: "Senha",
                              obscureText: _obscurePassword,
                              validator: (value) =>
                                  value != null && value.length >= 6
                                      ? null
                                      : "Mínimo 6 caracteres",
                            ),
                            const SizedBox(height: 16),

                            // Mensagem de erro
                            if (authProvider.errorMessage != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  authProvider.errorMessage!,
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
                              child: CustomButton(
                                label: "Entrar",
                                isLoading: authProvider.isLoading,
                                onPressed: _login,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Links
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () =>
                                    context.go('/reset-password'),
                                child: const Text("Esqueci minha senha"),
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go('/register'),
                              child:
                                  const Text("Não tem conta? Cadastre-se"),
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
