
import "package:flutter/material.dart";
import "package:estofariapro_app/widgets/shared_widgets/custom_textfield.dart";
import "package:estofariapro_app/widgets/shared_widgets/custom_button.dart";
import "package:estofariapro_app/services/auth_service.dart";
import "package:estofariapro_app/utils/validators.dart";

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({Key? key}) : super(key: key);

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  bool isPessoaFisica = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cpfCnpjController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  String tipoEmpresa = "Estofaria";
  final TextEditingController nomeEmpresaController = TextEditingController();
  final TextEditingController representanteController = TextEditingController();

  void _registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (isPessoaFisica) {
          await AuthService.cadastrarCliente(
            nome: nomeController.text.trim(),
            cpf: cpfCnpjController.text.trim(),
            email: emailController.text.trim(),
            telefone: telefoneController.text.trim(),
            endereco: enderecoController.text.trim(),
            senha: senhaController.text.trim(),
          );
        } else {
          await AuthService.cadastrarEmpresa(
            tipo: tipoEmpresa,
            nomeEmpresa: nomeEmpresaController.text.trim(),
            representante: representanteController.text.trim(),
            cnpj: cpfCnpjController.text.trim(),
            email: emailController.text.trim(),
            telefone: telefoneController.text.trim(),
            endereco: enderecoController.text.trim(),
            senha: senhaController.text.trim(),
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cadastro realizado com sucesso!")),
        );
        Navigator.pop(context); // volta para login
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text("Estofaria Pro", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFB85C38))),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Pessoa Física"),
                    Switch(
                      value: isPessoaFisica,
                      activeColor: Color(0xFFB85C38),
                      onChanged: (val) {
                        setState(() {
                          isPessoaFisica = val;
                        });
                      },
                    ),
                    const Text("CNPJ"),
                  ],
                ),
                const SizedBox(height: 20),
                if (isPessoaFisica) ...[
                  CustomTextField(controller: nomeController, label: "Nome"),
                  CustomTextField(controller: cpfCnpjController, label: "CPF", validator: Validators.cpfValidator),
                  CustomTextField(controller: emailController, label: "E-mail", validator: Validators.emailValidator),
                  CustomTextField(controller: telefoneController, label: "Telefone"),
                  CustomTextField(controller: enderecoController, label: "Endereço"),
                  CustomTextField(controller: senhaController, label: "Senha", obscureText: true),
                ] else ...[
                  DropdownButtonFormField<String>(
                    value: tipoEmpresa,
                    items: const [
                      DropdownMenuItem(value: "Estofaria", child: Text("Estofaria")),
                      DropdownMenuItem(value: "Fornecedor", child: Text("Fornecedor")),
                    ],
                    onChanged: (val) { setState(() { tipoEmpresa = val!; }); },
                    decoration: const InputDecoration(labelText: "Tipo de Empresa"),
                  ),
                  CustomTextField(controller: nomeEmpresaController, label: "Nome da Empresa"),
                  CustomTextField(controller: representanteController, label: "Nome do Representante"),
                  CustomTextField(controller: cpfCnpjController, label: "CNPJ", validator: Validators.cnpjValidator),
                  CustomTextField(controller: emailController, label: "E-mail", validator: Validators.emailValidator),
                  CustomTextField(controller: telefoneController, label: "Telefone"),
                  CustomTextField(controller: enderecoController, label: "Endereço"),
                  CustomTextField(controller: senhaController, label: "Senha", obscureText: true),
                ],
                const SizedBox(height: 30),
                CustomButton(
                  text: "Cadastrar",
                  color: const Color(0xFFB85C38),
                  onPressed: _registrarUsuario,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

