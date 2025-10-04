import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../state/auth_provider.dart';
import '../../common_widgets/custom_button.dart';
import '../../common_widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../common_widgets/shared_app_bar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    if (mounted) {
      // 4. Exibir feedback para o usuário
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Senha alterada com sucesso!"),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        // 5. Se for sucesso, volta para a tela anterior
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? "Erro ao alterar a senha."),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;

    // Ajuste UX: Lógica de nome da estofaria consistente com outras telas
    return Scaffold(
      appBar: SharedAppBar(
        estofariaNome: (currentUser?.tipo.startsWith('pessoaJuridica') ?? false)
            ? (currentUser?.empresa ?? "Painel Estofaria")
            : (currentUser?.nome ?? "Painel"),
        estofariaLogoUrl: currentUser?.logoUrl,
        usuarioNome: currentUser?.nome,
        usuarioFotoUrl: currentUser?.fotoUrl,
        isAdmin: currentUser?.isAdmin ?? false,
        onProfileTap: () => context.push('/profile'),
        onChangePassword: () => context.push('/change-password'),
        onLogout: () {
          authProvider.logoutUser();
          context.go('/login');
        },
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Card(
            margin: const EdgeInsets.all(24),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Ajuste UI: Título consistente com a tela de perfil
                    Text("Alterar Senha",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                    const SizedBox(height: 24),
                    CustomTextField(
                      controller: _currentPasswordController,
                      label: "Senha Atual",
                      obscureText: true,
                      validator: Validators.requiredField,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _newPasswordController,
                      label: "Nova Senha",
                      obscureText: true,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      label: "Confirmar Nova Senha",
                      obscureText: true,
                      // Ajuste UX: Validação de confirmação direto no campo
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Confirmação de senha obrigatória";
                        }
                        if (value != _newPasswordController.text) {
                          return "As senhas não coincidem.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      // Ajuste UI: Texto do botão consistente
                      label: "Salvar Alterações",
                      isLoading: _isLoading,
                      onPressed: _changePassword,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}