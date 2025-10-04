import 'package:flutter/material.dart'; // lib/presentation/screens/workshop/sales/pedido_orcamento_screen.dart

// Widgets reutilizáveis
import '../../../common_widgets/shared_app_bar.dart';
import '../../../common_widgets/pedido_orcamento_form.dart';

class PedidoOrcamentoScreen extends StatefulWidget {
  final String docId;
  final String pedidoIdCompleto; // Ajuste solicitado: Corrigido o nome do parâmetro para corresponder ao que é enviado.
  final String fromPanel; // já acrescentado anteriormente

  const PedidoOrcamentoScreen({
    Key? key,
    required this.docId,
    required this.pedidoIdCompleto,
    required this.fromPanel,
  }) : super(key: key);

  @override
  State<PedidoOrcamentoScreen> createState() => _PedidoOrcamentoScreenState();
}

class _PedidoOrcamentoScreenState extends State<PedidoOrcamentoScreen> {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const SharedAppBar(estofariaNome: "Pedido de Orçamento"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: scheme.primary, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Pedido de Orçamento",
                      style: textTheme.headlineSmall?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center, // Ajuste solicitado: Título centralizado.
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "ID do Pedido: ${widget.pedidoIdCompleto}", // Ajuste solicitado: Exibindo o ID correto.
                      style: textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Expanded(
                      child: PedidoOrcamentoForm(
                        docId: widget.docId,
                        pedidoIdCompleto: widget.pedidoIdCompleto,
                        fromPanel: widget.fromPanel, // Ajuste solicitado: repassar origem
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: scheme.primaryContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "© 2025 EstofariaPro | Versão 1.0.0",
              style: textTheme.bodySmall,
            ),
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline),
              tooltip: "Abrir chat",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Chat em breve...")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
