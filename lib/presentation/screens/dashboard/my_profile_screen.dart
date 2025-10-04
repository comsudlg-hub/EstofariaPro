// lib/presentation/screens/dashboard/my_profile_screen.dart
// Ajustes visuais e UX — conforme padrão Estofaria PRO
// Mantida a lógica original, apenas aprimorados feedbacks e acessibilidade.

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../data/models/user_model.dart';
import '../../../state/auth_provider.dart';
import '../../common_widgets/custom_button.dart';
import '../../common_widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../common_widgets/shared_app_bar.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isUploadingImage = false; // Ajuste: controla progresso de upload de imagem

  // Controllers
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _empresaController = TextEditingController();
  final _cnpjController = TextEditingController();

  Uint8List? _fotoBytes;
  Uint8List? _logoBytes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.read<AuthProvider?>()?.currentUser;
    if (user != null) {
      _nomeController.text = user.nome;
      _telefoneController.text = user.telefone;
      _emailController.text = user.email;
      _empresaController.text = user.empresa ?? '';
      _cnpjController.text = user.cnpj ?? '';
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _empresaController.dispose();
    _cnpjController.dispose();
    super.dispose();
  }

  Future<void> _pickImage({required bool isLogo}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();

      // Ajuste UX: prevenção de imagens muito grandes (>3MB)
      if (bytes.lengthInBytes > 3 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: const Text("Imagem muito grande. Escolha uma imagem até 3MB."),
              backgroundColor: Theme.of(context).colorScheme.error),
        );
        return;
      }

      setState(() {
        _isUploadingImage = true;
      });

      await Future.delayed(const Duration(milliseconds: 300)); // Simulação de tempo de upload leve

      setState(() {
        if (isLogo) {
          _logoBytes = bytes;
        } else {
          _fotoBytes = bytes;
        }
        _isUploadingImage = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final authProvider = context.read<AuthProvider?>();

    if (authProvider == null || authProvider.currentUser == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Erro: Usuário não encontrado.")));
      setState(() => _isLoading = false);
      return;
    }

    final success = await authProvider.updateUserProfile(
      nome: _nomeController.text,
      telefone: _telefoneController.text,
      empresa: _empresaController.text,
      fotoBytes: _fotoBytes,
      logoBytes: _logoBytes,
    );

    if (!mounted) return;
    // Ajuste UX: Cores consistentes para feedback
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success ? "Dados atualizados com sucesso!" : "Erro ao atualizar os dados."),
      backgroundColor: success
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.error,
    ));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider?>();
    final currentUser = authProvider?.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("Usuário não encontrado.")),
      );
    }

    final isPj = currentUser.tipo.startsWith('pessoaJuridica');

    return Scaffold(
      appBar: SharedAppBar(
        estofariaNome: isPj ? (currentUser.empresa ?? "Painel") : (currentUser.nome),
        estofariaLogoUrl: currentUser.logoUrl,
        usuarioNome: currentUser.nome,
        usuarioFotoUrl: currentUser.fotoUrl,
        isAdmin: currentUser.isAdmin,
        onProfileTap: () => context.push('/profile'),
        onChangePassword: () => context.push('/change-password'),
        onLogout: () {
          authProvider?.logoutUser();
          context.go('/login');
        },
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Card(
            margin: const EdgeInsets.all(24),
            elevation: 4,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Perfil do Usuário", style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 24),

                    // Seção de Imagens
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildImagePicker(
                          context: context,
                          label: "Foto de Perfil",
                          isLogo: false,
                          imageBytes: _fotoBytes,
                          currentImageUrl: currentUser.fotoUrl,
                        ),
                        if (isPj) ...[
                          const SizedBox(width: 32),
                          _buildImagePicker(
                            context: context,
                            label: "Logo da Empresa",
                            isLogo: true,
                            imageBytes: _logoBytes,
                            currentImageUrl: currentUser.logoUrl,
                          ),
                        ],
                      ],
                    ),
                    if (_isUploadingImage)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Center(child: CircularProgressIndicator()),
                      ),

                    const Divider(height: 32),

                    // AGRUPAMENTO: Dados pessoais
                    Text("Informações de Contato",
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _nomeController,
                      label: "Nome Completo / Representante",
                      hintText: "Ex: Marcos da Silva",
                      validator: Validators.requiredField,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _telefoneController,
                      label: "Telefone",
                      hintText: "(11) 99999-9999",
                      validator: Validators.phone,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      label: "E-mail",
                      hintText: "email@exemplo.com",
                      enabled: false,
                    ),

                    // AGRUPAMENTO: Dados da empresa
                    if (isPj) ...[
                      const Divider(height: 32),
                      Text("Dados da Empresa",
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _empresaController,
                        label: "Nome da Empresa",
                        hintText: "Ex: Estofaria do João Ltda.",
                        validator: Validators.requiredField,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _cnpjController,
                        label: "CNPJ",
                        hintText: "00.000.000/0000-00",
                        enabled: false,
                      ),
                    ],

                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                          label: "Voltar",
                          type: ButtonType.outlined,
                          onPressed: () => context.pop(),
                        ),
                        const SizedBox(width: 16),
                        CustomButton(
                          label: "Salvar Alterações",
                          isLoading: _isLoading,
                          onPressed: _saveChanges,
                        ),
                      ],
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

  Widget _buildImagePicker({
    required BuildContext context,
    required String label,
    required bool isLogo,
    Uint8List? imageBytes,
    String? currentImageUrl,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    ImageProvider? imageProvider;

    if (imageBytes != null) {
      imageProvider = MemoryImage(imageBytes);
    } else if (currentImageUrl != null && currentImageUrl.isNotEmpty) {
      imageProvider = NetworkImage(currentImageUrl);
    }

    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: isLogo ? 60 : 50,
              backgroundColor: colorScheme.surfaceVariant,
              backgroundImage: imageProvider,
              child: imageProvider == null
                  ? Icon(isLogo ? Icons.business : Icons.person,
                      size: 50, color: colorScheme.onSurfaceVariant)
                  : null,
            ),
            Tooltip(
              // Ajuste UX: Adicionado Tooltip para acessibilidade
              message: "Alterar ${isLogo ? 'logo' : 'foto de perfil'}",
              child: Material(
                color: colorScheme.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () => _pickImage(isLogo: isLogo),
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Icon(Icons.edit, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
