import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/firebase_auth_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

enum UserType { pessoaFisica, pessoaJuridica }
enum BusinessType { estofaria, fornecedor }

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _authService = FirebaseAuthService();

  // Controllers PF
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _cepController = TextEditingController();

  // Controllers PJ
  final _empresaController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _responsavelController = TextEditingController();
  final _telefonePJController = TextEditingController();
  final _emailPJController = TextEditingController();
  final _loginPJController = TextEditingController();
  final _senhaPJController = TextEditingController();
  final _ruaPJController = TextEditingController();
  final _numeroPJController = TextEditingController();
  final _bairroPJController = TextEditingController();
  final _cidadePJController = TextEditingController();
  final _cepPJController = TextEditingController();

  UserType? _userType;
  BusinessType? _businessType;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userType = UserType.values[prefs.getInt('userType') ?? 0];
    _businessType = BusinessType.values[prefs.getInt('businessType') ?? 0];
    _nomeController.text = prefs.getString('nome') ?? '';
    _telefoneController.text = prefs.getString('telefone') ?? '';
    _emailController.text = prefs.getString('email') ?? '';
    _loginController.text = prefs.getString('login') ?? '';
    _senhaController.text = prefs.getString('senha') ?? '';
    _ruaController.text = prefs.getString('rua') ?? '';
    _numeroController.text = prefs.getString('numero') ?? '';
    _bairroController.text = prefs.getString('bairro') ?? '';
    _cidadeController.text = prefs.getString('cidade') ?? '';
    _cepController.text = prefs.getString('cep') ?? '';
    _empresaController.text = prefs.getString('empresa') ?? '';
    _cnpjController.text = prefs.getString('cnpj') ?? '';
    _responsavelController.text = prefs.getString('responsavel') ?? '';
    _telefonePJController.text = prefs.getString('telefonePJ') ?? '';
    _emailPJController.text = prefs.getString('emailPJ') ?? '';
    _loginPJController.text = prefs.getString('loginPJ') ?? '';
    _senhaPJController.text = prefs.getString('senhaPJ') ?? '';
    _ruaPJController.text = prefs.getString('ruaPJ') ?? '';
    _numeroPJController.text = prefs.getString('numeroPJ') ?? '';
    _bairroPJController.text = prefs.getString('bairroPJ') ?? '';
    _cidadePJController.text = prefs.getString('cidadePJ') ?? '';
    _cepPJController.text = prefs.getString('cepPJ') ?? '';
    setState(() {});
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userType', _userType?.index ?? 0);
    prefs.setInt('businessType', _businessType?.index ?? 0);
    prefs.setString('nome', _nomeController.text);
    prefs.setString('telefone', _telefoneController.text);
    prefs.setString('email', _emailController.text);
    prefs.setString('login', _loginController.text);
    prefs.setString('senha', _senhaController.text);
    prefs.setString('rua', _ruaController.text);
    prefs.setString('numero', _numeroController.text);
    prefs.setString('bairro', _bairroController.text);
    prefs.setString('cidade', _cidadeController.text);
    prefs.setString('cep', _cepController.text);
    prefs.setString('empresa', _empresaController.text);
    prefs.setString('cnpj', _cnpjController.text);
    prefs.setString('responsavel', _responsavelController.text);
    prefs.setString('telefonePJ', _telefonePJController.text);
    prefs.setString('emailPJ', _emailPJController.text);
    prefs.setString('loginPJ', _loginPJController.text);
    prefs.setString('senhaPJ', _senhaPJController.text);
    prefs.setString('ruaPJ', _ruaPJController.text);
    prefs.setString('numeroPJ', _numeroPJController.text);
    prefs.setString('bairroPJ', _bairroPJController.text);
    prefs.setString('cidadePJ', _cidadePJController.text);
    prefs.setString('cepPJ', _cepPJController.text);
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    String? result;
    if (_userType == UserType.pessoaFisica) {
      result = await _authService.register(
        _loginController.text.trim(), _senhaController.text.trim());
    } else if (_userType == UserType.pessoaJuridica) {
      result = await _authService.register(
        _loginPJController.text.trim(), _senhaPJController.text.trim());
    }

    setState(() => _loading = false);
    if (result == null) {
      _saveData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro realizado com sucesso!')));
      Navigator.pop(context); // volta para login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  void _cancel() {
    Navigator.pop(context);
  }

  Widget _buildPFForm() {
    return Column(
      children: [
        TextFormField(controller: _nomeController, decoration: InputDecoration(
          labelText: 'Nome completo', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
        SizedBox(height: 10),
        TextFormField(controller: _telefoneController, decoration: InputDecoration(
          labelText: 'Telefone', border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone))),
        SizedBox(height: 10),
        TextFormField(controller: _emailController, decoration: InputDecoration(
          labelText: 'E-mail', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email))),
        SizedBox(height: 10),
        TextFormField(controller: _loginController, decoration: InputDecoration(
          labelText: 'Login', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
        SizedBox(height: 10),
        TextFormField(controller: _senhaController, obscureText: true, decoration: InputDecoration(
          labelText: 'Senha', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock))),
        SizedBox(height: 10),
        // Endereço detalhado
        TextFormField(controller: _ruaController, decoration: InputDecoration(labelText: 'Rua', border: OutlineInputBorder())),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: TextFormField(controller: _numeroController, decoration: InputDecoration(labelText: 'Número', border: OutlineInputBorder()))),
            SizedBox(width: 10),
            Expanded(child: TextFormField(controller: _bairroController, decoration: InputDecoration(labelText: 'Bairro', border: OutlineInputBorder()))),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: TextFormField(controller: _cidadeController, decoration: InputDecoration(labelText: 'Cidade', border: OutlineInputBorder()))),
            SizedBox(width: 10),
            Expanded(child: TextFormField(controller: _cepController, decoration: InputDecoration(labelText: 'CEP', border: OutlineInputBorder()))),
          ],
        ),
      ],
    );
  }

  Widget _buildPJForm() {
    return Column(
      children: [
        TextFormField(controller: _empresaController, decoration: InputDecoration(
          labelText: 'Nome da empresa', border: OutlineInputBorder(), prefixIcon: Icon(Icons.business))),
        SizedBox(height: 10),
        TextFormField(controller: _cnpjController, decoration: InputDecoration(
          labelText: 'CNPJ', border: OutlineInputBorder(), prefixIcon: Icon(Icons.confirmation_number))),
        SizedBox(height: 10),
        TextFormField(controller: _responsavelController, decoration: InputDecoration(
          labelText: 'Responsável', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
        SizedBox(height: 10),
        TextFormField(controller: _telefonePJController, decoration: InputDecoration(
          labelText: 'Telefone', border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone))),
        SizedBox(height: 10),
        TextFormField(controller: _emailPJController, decoration: InputDecoration(
          labelText: 'E-mail', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email))),
        SizedBox(height: 10),
        TextFormField(controller: _loginPJController, decoration: InputDecoration(
          labelText: 'Login', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
        SizedBox(height: 10),
        TextFormField(controller: _senhaPJController, obscureText: true, decoration: InputDecoration(
          labelText: 'Senha', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock))),
        SizedBox(height: 10),
        // Endereço detalhado
        TextFormField(controller: _ruaPJController, decoration: InputDecoration(labelText: 'Rua', border: OutlineInputBorder())),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: TextFormField(controller: _numeroPJController, decoration: InputDecoration(labelText: 'Número', border: OutlineInputBorder()))),
            SizedBox(width: 10),
            Expanded(child: TextFormField(controller: _bairroPJController, decoration: InputDecoration(labelText: 'Bairro', border: OutlineInputBorder()))),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: TextFormField(controller: _cidadePJController, decoration: InputDecoration(labelText: 'Cidade', border: OutlineInputBorder()))),
            SizedBox(width: 10),
            Expanded(child: TextFormField(controller: _cepPJController, decoration: InputDecoration(labelText: 'CEP', border: OutlineInputBorder()))),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Conta'),
        backgroundColor: AppColors.primary,
        leading: IconButton(icon: Icon(Icons.close), onPressed: _cancel),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Icon(Icons.weekend, size: 80, color: AppColors.primary),
              SizedBox(height: 10),
              Text('EstofariaPro', style: AppTypography.title.copyWith(color: AppColors.primary)),
              SizedBox(height: 10),
              // Tipo de usuário
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<UserType>(
                      title: Text('Pessoa Física'),
                      value: UserType.pessoaFisica,
                      groupValue: _userType,
                      onChanged: (value) { setState(() => _userType = value); },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<UserType>(
                      title: Text('Pessoa Jurídica'),
                      value: UserType.pessoaJuridica,
                      groupValue: _userType,
                      onChanged: (value) { setState(() => _userType = value); },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              if (_userType == UserType.pessoaFisica) _buildPFForm(),
              if (_userType == UserType.pessoaJuridica) ...[
                // Tipo de PJ
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<BusinessType>(
                        title: Text('Estofaria'),
                        value: BusinessType.estofaria,
                        groupValue: _businessType,
                        onChanged: (value) { setState(() => _businessType = value); },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<BusinessType>(
                        title: Text('Fornecedor'),
                        value: BusinessType.fornecedor,
                        groupValue: _businessType,
                        onChanged: (value) { setState(() => _businessType = value); },
                      ),
                    ),
                  ],
                ),
                _buildPJForm(),
              ],
              SizedBox(height: 20),
              _loading
                ? CircularProgressIndicator()
                : Row(
                  children: [
                    Expanded(child: ElevatedButton(
                      onPressed: _register,
                      child: Text('SALVAR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: Size(double.infinity, 50),
                        textStyle: AppTypography.button,
                      ),
                    )),
                    SizedBox(width: 10),
                    Expanded(child: ElevatedButton(
                      onPressed: _cancel,
                      child: Text('CANCELAR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        minimumSize: Size(double.infinity, 50),
                        textStyle: AppTypography.button,
                      ),
                    )),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
