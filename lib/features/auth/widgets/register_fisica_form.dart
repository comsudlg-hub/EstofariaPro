import 'package:flutter/material.dart';
import '../../../shared/utils/validators.dart';
import 'register_summary.dart';

class RegisterFisicaForm extends StatefulWidget {
  const RegisterFisicaForm({super.key});

  @override
  State<RegisterFisicaForm> createState() => _RegisterFisicaFormState();
}

class _RegisterFisicaFormState extends State<RegisterFisicaForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(controller: _nomeController, decoration: const InputDecoration(labelText: 'Nome completo')),
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
                              'Nome': _nomeController.text,
                              'Telefone': _telefoneController.text,
                              'E-mail': _emailController.text,
                              'Endereço': _enderecoController.text,
                              'Login': _loginController.text,
                              'Senha': _senhaController.text,
                              'Tipo': 'Cliente Final',
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
}
