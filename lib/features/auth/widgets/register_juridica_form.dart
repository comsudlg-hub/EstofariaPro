import 'package:flutter/material.dart';
import '../../../shared/utils/validators.dart';
import 'register_summary.dart';

class RegisterJuridicaForm extends StatefulWidget {
  const RegisterJuridicaForm({super.key});

  @override
  State<RegisterJuridicaForm> createState() => _RegisterJuridicaFormState();
}

class _RegisterJuridicaFormState extends State<RegisterJuridicaForm> {
  String? tipoPJ; // Estofaria ou Fornecedor
  final _formKey = GlobalKey<FormState>();
  final _empresaController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _representanteController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (tipoPJ == null) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCard('Estofaria', Icons.chair, () => setState(() => tipoPJ = 'Estofaria')),
            const SizedBox(width: 20),
            _buildCard('Fornecedor', Icons.local_shipping, () => setState(() => tipoPJ = 'Fornecedor')),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(controller: _empresaController, decoration: const InputDecoration(labelText: 'Nome da empresa')),
            TextFormField(controller: _cnpjController, decoration: const InputDecoration(labelText: 'CNPJ'), validator: Validators.cnpj),
            TextFormField(controller: _representanteController, decoration: const InputDecoration(labelText: 'Nome do representante')),
            TextFormField(controller: _telefoneController, decoration: const InputDecoration(labelText: 'Telefone')),
            TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'E-mail'), validator: Validators.email),
            TextFormField(controller: _enderecoController, decoration: const InputDecoration(labelText: 'Endereço completo')),
            TextFormField(controller: _loginController, decoration: const InputDecoration(labelText: 'Login')),
            TextFormField(controller: _senhaController, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true, validator: Validators.password),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RegisterSummary(
                            data: {
                              'Empresa': _empresaController.text,
                              'CNPJ': _cnpjController.text,
                              'Representante': _representanteController.text,
                              'Telefone': _telefoneController.text,
                              'E-mail': _emailController.text,
                              'Endereço': _enderecoController.text,
                              'Login': _loginController.text,
                              'Senha': _senhaController.text,
                              'Tipo': tipoPJ!,
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: SizedBox(
          width: 150,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(height: 10),
              Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
