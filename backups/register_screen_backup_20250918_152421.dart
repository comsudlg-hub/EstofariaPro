import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/validators.dart';
import '../../../presentation/common_widgets/custom_button.dart';
import '../../../presentation/common_widgets/custom_text_field.dart';
import '../../../state/auth_provider.dart';
import '../../../data/models/user_model.dart';

enum UserType {
  none,
  pessoaFisica,
  pessoaJuridicaEscolha,
  pessoaJuridicaEstofaria,
  pessoaJuridicaFornecedor,
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  UserType _selectedType = UserType.none;
  bool _showResumo = false;

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nomeController = TextEditingController();
  final _empresaController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _representanteController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _cepController = TextEditingController();
  final _complementoController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _empresaController.dispose();
    _cnpjController.dispose();
    _representanteController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _cepController.dispose();
    _complementoController.dispose();
    super.dispose();
  }

  Future<void> _salvarCadastro() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _showResumo = true);
  }

  Future<void> _confirmarCadastro() async {
    final authProvider = context.read<AuthProvider>();

    final user = UserModel(
      uid: '', // será preenchido pelo FirebaseAuth
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      telefone: _telefoneController.text.trim(),
      tipo: _selectedType.name,
      empresa: _empresaController.text.trim().isEmpty
          ? null
          : _empresaController.text.trim(),
      cnpj: _cnpjController.text.trim().isEmpty
          ? null
          : _cnpjController.text.trim(),
      representante: _representanteController.text.trim().isEmpty
          ? null
          : _representanteController.text.trim(),
      endereco: {
        'rua': _ruaController.text.trim(),
        'numero': _numeroController.text.trim(),
        'bairro': _bairroController.text.trim(),
        'cidade': _cidadeController.text.trim(),
        'estado': _estadoController.text.trim(),
        'cep': _cepController.text.trim(),
        'complemento': _complementoController.text.trim(),
      },
      criadoEm: DateTime.now(),
    );

    final success = await authProvider.registerUser(
      user: user,
      senha: _senhaController.text.trim(),
    );

    if (success && mounted) {
      context.go('/login'); // mantém fluxo de voltar ao login
    }
  }

  // ================== UI ==================
  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Icon(Icons.chair, size: 60, color: theme.colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          "Estofaria Pro",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCardSelecao(
      ThemeData theme, IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Icon(icon, size: 48, color: theme.colorScheme.primary),
                const SizedBox(height: 8),
                Text(label, style: theme.textTheme.titleMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelecaoInicial(ThemeData theme) {
    return Column(
      children: [
        Text("Bem-vindo! Vamos começar seu cadastro.",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Text("Você gostaria de se cadastrar como:",
            style: theme.textTheme.bodyMedium),
        const SizedBox(height: 24),
        Row(
          children: [
            _buildCardSelecao(
                theme, Icons.person, "Pessoa Física", () {
              setState(() => _selectedType = UserType.pessoaFisica);
            }),
            const SizedBox(width: 16),
            _buildCardSelecao(
                theme, Icons.business, "Pessoa Jurídica", () {
              setState(() => _selectedType = UserType.pessoaJuridicaEscolha);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildEscolhaPJ(ThemeData theme) {
    return Column(
      children: [
        Text("Você é uma Estofaria ou um Fornecedor?",
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center),
        const SizedBox(height: 24),
        Row(
          children: [
            _buildCardSelecao(
                theme, Icons.chair_alt, "Estofaria", () {
              setState(() =>
                  _selectedType = UserType.pessoaJuridicaEstofaria);
            }),
            const SizedBox(width: 16),
            _buildCardSelecao(
                theme, Icons.inventory, "Fornecedor", () {
              setState(() =>
                  _selectedType = UserType.pessoaJuridicaFornecedor);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildFormulario(ThemeData theme) {
    final isPF = _selectedType == UserType.pessoaFisica;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (isPF)
            CustomTextField(
              controller: _nomeController,
              label: "Nome completo",
              validator: Validators.requiredField,
            )
          else ...[
            CustomTextField(
              controller: _empresaController,
              label: "Nome da empresa",
              validator: Validators.requiredField,
            ),
            CustomTextField(
              controller: _cnpjController,
              label: "CNPJ",
              validator: Validators.cnpj,
            ),
            CustomTextField(
              controller: _representanteController,
              label: "Nome do representante",
              validator: Validators.requiredField,
            ),
          ],
          CustomTextField(
            controller: _telefoneController,
            label: "Telefone",
            validator: Validators.phone,
          ),
          CustomTextField(
            controller: _emailController,
            label: "E-mail",
            validator: Validators.email,
          ),
          CustomTextField(
            controller: _senhaController,
            label: "Senha",
            obscureText: true,
            validator: (v) =>
                v != null && v.length >= 6 ? null : "Mínimo 6 caracteres",
          ),
          const SizedBox(height: 16),
          Text("Endereço", style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _ruaController,
            label: "Rua",
            validator: Validators.requiredField,
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _numeroController,
                  label: "Número",
                  validator: Validators.requiredField,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  controller: _bairroController,
                  label: "Bairro",
                  validator: Validators.requiredField,
                ),
              ),
            ],
          ),
          CustomTextField(
            controller: _cidadeController,
            label: "Cidade",
            validator: Validators.requiredField,
          ),
          CustomTextField(
            controller: _estadoController,
            label: "Estado",
            validator: Validators.requiredField,
          ),
          CustomTextField(
            controller: _cepController,
            label: "CEP",
            validator: Validators.cep,
          ),
          CustomTextField(
            controller: _complementoController,
            label: "Complemento (opcional)",
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: "Cancelar",
                  isOutlined: true,
                  onPressed: () => context.go('/login'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  label: "Salvar",
                  onPressed: _salvarCadastro,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResumo(ThemeData theme) {
    final dados = [
      "Tipo: ${_selectedType.name}",
      if (_selectedType == UserType.pessoaFisica)
        "Nome: ${_nomeController.text}",
      if (_selectedType != UserType.pessoaFisica) ...[
        "Empresa: ${_empresaController.text}",
        "CNPJ: ${_cnpjController.text}",
        "Representante: ${_representanteController.text}",
      ],
      "Telefone: ${_telefoneController.text}",
      "E-mail: ${_emailController.text}",
      "Rua: ${_ruaController.text}, Nº: ${_numeroController.text}",
      "Bairro: ${_bairroController.text}",
      "Cidade: ${_cidadeController.text}",
      "Estado: ${_estadoController.text}",
      "CEP: ${_cepController.text}",
      if (_complementoController.text.isNotEmpty)
        "Complemento: ${_complementoController.text}",
    ];

    final authProvider = context.watch<AuthProvider>();

    return Column(
      children: [
        Text("Confirme seus dados", style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        ...dados.map(
          (d) => Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(d),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (authProvider.errorMessage != null)
          Text(
            authProvider.errorMessage!,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                label: "Voltar",
                isOutlined: true,
                onPressed: () {
                  setState(() => _showResumo = false);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                label: "OK",
                isLoading: authProvider.isLoading,
                onPressed: authProvider.isLoading
                    ? null
                    : () async {
                        await _confirmarCadastro();
                      },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildHeader(theme),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _showResumo
                          ? _buildResumo(theme)
                          : _selectedType == UserType.none
                              ? _buildSelecaoInicial(theme)
                              : _selectedType == UserType.pessoaJuridicaEscolha
                                  ? _buildEscolhaPJ(theme)
                                  : _buildFormulario(theme),
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
