import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

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

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _empresaController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _representanteController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();

  // Endereço desmembrado
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _cepController = TextEditingController();
  final _complementoController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      _loginController.text = _emailController.text;
    });
  }

  Future<void> _salvarCadastro() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _showResumo = true;
    });
  }

  Future<void> _confirmarCadastro() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );

      final uid = userCredential.user?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'tipo': _selectedType.name,
          'nome': _nomeController.text.trim(),
          'empresa': _empresaController.text.trim(),
          'cnpj': _cnpjController.text.trim(),
          'representante': _representanteController.text.trim(),
          'telefone': _telefoneController.text.trim(),
          'email': _emailController.text.trim(),
          'login': _loginController.text.trim(),
          'endereco': {
            'rua': _ruaController.text.trim(),
            'numero': _numeroController.text.trim(),
            'bairro': _bairroController.text.trim(),
            'cidade': _cidadeController.text.trim(),
            'estado': _estadoController.text.trim(),
            'cep': _cepController.text.trim(),
            'complemento': _complementoController.text.trim(),
          },
          'criadoEm': FieldValue.serverTimestamp(),
        });
      }

      if (mounted) Future.microtask(() => context.go('/login'));
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? "Erro ao cadastrar.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // =================== UI Widgets ===================

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

  Widget _buildCardSelecao(ThemeData theme,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                  color: theme.colorScheme.primary.withOpacity(0.5))),
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
        Text(
          "Bem-vindo! Vamos começar seu cadastro.",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text("Você gostaria de se cadastrar como:",
            style: theme.textTheme.bodyMedium),
        const SizedBox(height: 24),
        Row(
          children: [
            _buildCardSelecao(
              theme,
              icon: Icons.person,
              label: "Pessoa Física",
              onTap: () =>
                  setState(() => _selectedType = UserType.pessoaFisica),
            ),
            const SizedBox(width: 16),
            _buildCardSelecao(
              theme,
              icon: Icons.business,
              label: "Pessoa Jurídica",
              onTap: () =>
                  setState(() => _selectedType = UserType.pessoaJuridicaEscolha),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEscolhaPJ(ThemeData theme) {
    return Column(
      children: [
        Text(
          "Informe: você é uma Estofaria ou um Fornecedor?",
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _buildCardSelecao(
              theme,
              icon: Icons.chair_alt,
              label: "Estofaria",
              onTap: () => setState(
                  () => _selectedType = UserType.pessoaJuridicaEstofaria),
            ),
            const SizedBox(width: 16),
            _buildCardSelecao(
              theme,
              icon: Icons.inventory,
              label: "Fornecedor",
              onTap: () => setState(
                  () => _selectedType = UserType.pessoaJuridicaFornecedor),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        enabled: enabled,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.brown.shade50.withOpacity(0.2), // fundo leve
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.brown.shade300, // cor da borda harmonizada
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.brown.shade600,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormulario(ThemeData theme) {
    final isPF = _selectedType == UserType.pessoaFisica;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (isPF)
            _buildTextField(
              controller: _nomeController,
              label: "Nome completo",
              validator: (v) => v!.isEmpty ? "Obrigatório" : null,
            )
          else ...[
            _buildTextField(
              controller: _empresaController,
              label: "Nome da empresa",
              validator: (v) => v!.isEmpty ? "Obrigatório" : null,
            ),
            _buildTextField(
              controller: _cnpjController,
              label: "CNPJ",
              validator: (v) => v!.isEmpty ? "Obrigatório" : null,
            ),
            _buildTextField(
              controller: _representanteController,
              label: "Nome do representante",
              validator: (v) => v!.isEmpty ? "Obrigatório" : null,
            ),
          ],
          _buildTextField(
            controller: _telefoneController,
            label: "Telefone",
            validator: (v) => v!.isEmpty ? "Obrigatório" : null,
          ),
          _buildTextField(
            controller: _emailController,
            label: "E-mail",
            validator: (v) => v!.contains("@") ? null : "E-mail inválido",
          ),
          _buildTextField(
            controller: _loginController,
            enabled: false,
            label: "Login (igual ao e-mail)",
          ),
          _buildTextField(
            controller: _senhaController,
            label: "Senha",
            obscure: true,
            validator: (v) => v!.length < 6 ? "Mínimo 6 caracteres" : null,
          ),
          const SizedBox(height: 16),
          Text("Endereço", style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _ruaController,
            label: "Rua",
            validator: (v) => v!.isEmpty ? "Obrigatório" : null,
          ),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _numeroController,
                  label: "Número",
                  validator: (v) => v!.isEmpty ? "Obrigatório" : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _bairroController,
                  label: "Bairro",
                  validator: (v) => v!.isEmpty ? "Obrigatório" : null,
                ),
              ),
            ],
          ),
          _buildTextField(
            controller: _cidadeController,
            label: "Cidade",
            validator: (v) => v!.isEmpty ? "Obrigatório" : null,
          ),
          _buildTextField(
            controller: _estadoController,
            label: "Estado",
            validator: (v) => v!.isEmpty ? "Obrigatório" : null,
          ),
          _buildTextField(
            controller: _cepController,
            label: "CEP",
            validator: (v) => v!.isEmpty ? "Obrigatório" : null,
          ),
          _buildTextField(
            controller: _complementoController,
            label: "Complemento (opcional)",
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.go('/login'),
                  child: const Text("Cancelar"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _salvarCadastro,
                  child: const Text("Salvar"),
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
      if (_selectedType == UserType.pessoaFisica) "Nome: ${_nomeController.text}",
      if (_selectedType != UserType.pessoaFisica) ...[
        "Empresa: ${_empresaController.text}",
        "CNPJ: ${_cnpjController.text}",
        "Representante: ${_representanteController.text}",
      ],
      "Telefone: ${_telefoneController.text}",
      "E-mail: ${_emailController.text}",
      "Login: ${_loginController.text}",
      "Rua: ${_ruaController.text}, Nº: ${_numeroController.text}",
      "Bairro: ${_bairroController.text}",
      "Cidade: ${_cidadeController.text}",
      "Estado: ${_estadoController.text}",
      "CEP: ${_cepController.text}",
      if (_complementoController.text.isNotEmpty)
        "Complemento: ${_complementoController.text}",
    ];

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
        if (_errorMessage != null)
          Text(
            _errorMessage!,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isLoading ? null : () {
                  setState(() {
                    _showResumo = false;
                  });
                },
                child: const Text("Voltar"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: _isLoading ? null : _confirmarCadastro,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("OK"),
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
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
