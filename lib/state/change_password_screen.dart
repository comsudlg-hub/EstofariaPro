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

  Future<void> _submitChangePassword() async {
    // 1. Validar o formulário
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Verificar se a nova senha e a confirmação são iguais
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("A nova senha e a confirmação não correspondem."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();

    // 3. Chamar o método do AuthProvider
    final success = await authProvider.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    if (mounted) {
      // 4. Exibir feedback para o usuário
      final message = success
          ? "Senha alterada com sucesso!"
          : (authProvider.errorMessage ?? "Erro ao alterar a senha.");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) {
        // 5. Se for sucesso, volta para a tela anterior
        context.pop();
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;

    return Scaffold(
      appBar: SharedAppBar(
        estofariaNome: (currentUser?.tipo.startsWith('pessoaJuridica') ?? false)
            ? (currentUser?.empresa ?? "Painel")
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
                    Text("Alterar Senha", style: Theme.of(context).textTheme.headlineSmall),
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
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      label: "Salvar Nova Senha",
                      isLoading: _isLoading,
                      onPressed: _submitChangePassword,
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