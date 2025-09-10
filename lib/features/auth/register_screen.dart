import 'package:flutter/material.dart';
import 'widgets/register_fisica_form.dart';
import 'widgets/register_juridica_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? tipoCadastro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: tipoCadastro == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bem-vindo! Vamos começar seu cadastro.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCard('Pessoa Física', Icons.person, () {
                        setState(() => tipoCadastro = 'PF');
                      }),
                      const SizedBox(width: 20),
                      _buildCard('Pessoa Jurídica', Icons.business, () {
                        setState(() => tipoCadastro = 'PJ');
                      }),
                    ],
                  ),
                ],
              )
            : tipoCadastro == 'PF'
                ? const RegisterFisicaForm()
                : const RegisterJuridicaForm(),
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
