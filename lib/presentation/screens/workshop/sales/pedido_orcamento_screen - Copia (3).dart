import 'package:flutter/material.dart';

class OrdemServicoScreen extends StatelessWidget {
  const OrdemServicoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ordem de Serviço')),
      body: const Center(
        child: Text(
          'Tela: Ordem de Serviço',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
