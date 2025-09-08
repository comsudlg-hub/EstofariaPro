import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

enum TipoCadastro { pessoaFisica, pessoaJuridica }
enum TipoJuridica { estofaria, fornecedor }

class LoginCadastroScreen extends StatefulWidget {
  const LoginCadastroScreen({Key? key}) : super(key: key);

  @override
  State<LoginCadastroScreen> createState() => _LoginCadastroScreenState();
}

class _LoginCadastroScreenState extends State<LoginCadastroScreen> {
  TipoCadastro? tipoCadastro;
  TipoJuridica? tipoJuridica;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // Escolha tipo de cadastro
            DropdownButton<TipoCadastro>(
              value: tipoCadastro,
              hint: Text('Selecione o tipo de cadastro'),
              onChanged: (value) {
                setState(() {
                  tipoCadastro = value;
                });
              },
              items: TipoCadastro.values.map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Text(tipo == TipoCadastro.pessoaFisica ? 'Pessoa Física' : 'Pessoa Jurídica'),
                );
              }).toList(),
            ),
            SizedBox(height: 24),

            if (tipoCadastro == TipoCadastro.pessoaFisica) ...[
              TextField(decoration: InputDecoration(labelText: 'Nome')),
              TextField(decoration: InputDecoration(labelText: 'CPF')),
              TextField(decoration: InputDecoration(labelText: 'E-mail')),
              TextField(decoration: InputDecoration(labelText: 'Telefone')),
              TextField(decoration: InputDecoration(labelText: 'Endereço')),
              TextField(decoration: InputDecoration(labelText: 'Login')),
              TextField(decoration: InputDecoration(labelText: 'Senha'), obscureText: true),
            ] else if (tipoCadastro == TipoCadastro.pessoaJuridica) ...[
              DropdownButton<TipoJuridica>(
                value: tipoJuridica,
                hint: Text('Selecione tipo da empresa'),
                onChanged: (value) {
                  setState(() {
                    tipoJuridica = value;
                  });
                },
                items: TipoJuridica.values.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo == TipoJuridica.estofaria ? 'Estofaria' : 'Fornecedor'),
                  );
                }).toList(),
              ),
              SizedBox(height: 12),
              TextField(decoration: InputDecoration(labelText: 'Nome da Empresa')),
              TextField(decoration: InputDecoration(labelText: 'CNPJ')),
              TextField(decoration: InputDecoration(labelText: 'Nome do Responsável')),
              TextField(decoration: InputDecoration(labelText: 'Telefone')),
              TextField(decoration: InputDecoration(labelText: 'E-mail')),
              TextField(decoration: InputDecoration(labelText: 'Endereço')),
              TextField(decoration: InputDecoration(labelText: 'Login')),
              TextField(decoration: InputDecoration(labelText: 'Senha'), obscureText: true),
            ],

            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.couroPrimary,
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              child: Text('Cadastrar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
