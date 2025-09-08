import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_text_field.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  bool isPessoaFisica = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cpfCnpjController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController empresaController = TextEditingController();
  final TextEditingController representanteController = TextEditingController();
  String tipoEmpresa = 'Estofaria';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.chair, color: Colors.white),
            SizedBox(width: 10),
            Text('Estofaria Pro'),
          ],
        ),
        backgroundColor: Color(0xFF6C4F3D),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SwitchListTile(
                title: Text(isPessoaFisica ? 'Pessoa Física' : 'CNPJ'),
                value: isPessoaFisica,
                onChanged: (val) {
                  setState(() {
                    isPessoaFisica = val;
                  });
                },
              ),
              if (isPessoaFisica) ...[
                CustomTextField(controller: nomeController, label: 'Nome'),
                CustomTextField(controller: cpfCnpjController, label: 'CPF', inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('Estofaria'),
                        value: 'Estofaria',
                        groupValue: tipoEmpresa,
                        onChanged: (value) {
                          setState(() { tipoEmpresa = value!; });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('Fornecedor'),
                        value: 'Fornecedor',
                        groupValue: tipoEmpresa,
                        onChanged: (value) {
                          setState(() { tipoEmpresa = value!; });
                        },
                      ),
                    ),
                  ],
                ),
                CustomTextField(controller: empresaController, label: 'Nome da empresa'),
                CustomTextField(controller: representanteController, label: 'Nome do representante'),
                CustomTextField(controller: cpfCnpjController, label: 'CNPJ', inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
              ],
              CustomTextField(controller: emailController, label: 'E-mail', keyboardType: TextInputType.emailAddress),
              CustomTextField(controller: telefoneController, label: 'Telefone', keyboardType: TextInputType.phone),
              CustomTextField(controller: enderecoController, label: 'Endereço'),
              CustomTextField(controller: senhaController, label: 'Senha', obscureText: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: senhaController.text,
                      );
                      await FirebaseFirestore.instance.collection('usuarios').doc(user.user!.uid).set({
                        'tipo': isPessoaFisica ? 'Cliente Final' : tipoEmpresa,
                        'nome': isPessoaFisica ? nomeController.text : empresaController.text,
                        'representante': isPessoaFisica ? null : representanteController.text,
                        'cpf_cnpj': cpfCnpjController.text,
                        'email': emailController.text,
                        'telefone': telefoneController.text,
                        'endereco': enderecoController.text,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cadastro realizado com sucesso!')));
                      Navigator.pop(context);
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Erro')));
                    }
                  }
                },
                child: Text('Cadastrar'),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFB85C38)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
