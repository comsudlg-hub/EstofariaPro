import 'package:flutter/material.dart';

class EnviarOrcamentoScreen extends StatelessWidget {
  const EnviarOrcamentoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enviar Orçamento')),
      body: const Center(
        child: Text(
          'Tela: Enviar Orçamento',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
