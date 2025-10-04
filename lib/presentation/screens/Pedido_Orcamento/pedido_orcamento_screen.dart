// lib/presentation/screens/workshop/sales/pedido_orcamento_screen.dart

import 'package:flutter/material.dart';
import '../../../common_widgets/shared_app_bar.dart';

class PedidoOrcamentoScreen extends StatefulWidget {
  final String docId;
  final String pedidoId;
  final String fromPanel; // <-- parâmetro adicionado (mínimo ajuste)

  const PedidoOrcamentoScreen({
    Key? key,
    required this.docId,
    required this.pedidoId,
    required this.fromPanel, // obrigatório
  }) : super(key: key);

  @override
  State<PedidoOrcamentoScreen> createState() => _PedidoOrcamentoScreenState();
}

class _PedidoOrcamentoScreenState extends State<PedidoOrcamentoScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppBar(estofariaNome: "Pedido de Orçamento"),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() => _currentStep += 1);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        steps: [
          Step(title: const Text("Dados do Cliente"), content: const Text("Step 1 aqui...")),
          Step(title: const Text("Serviços"), content: const Text("Step 2 aqui...")),
          Step(title: const Text("Detalhes do Estofado"), content: const Text("Step 3 aqui...")),
          Step(title: const Text("Confirmação"), content: const Text("Step 4 aqui...")),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          "Pedido: ${widget.pedidoId} | Doc: ${widget.docId} | Painel: ${widget.fromPanel}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
