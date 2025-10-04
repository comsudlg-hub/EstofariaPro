import 'package:flutter/material.dart';

class AgendarVisitaScreen extends StatelessWidget {
  const AgendarVisitaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agendar Visita')),
      body: const Center(
        child: Text(
          'Tela: Agendar Visita',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
