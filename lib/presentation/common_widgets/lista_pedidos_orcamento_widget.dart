import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListaPedidosOrcamentoWidget extends StatelessWidget {
  const ListaPedidosOrcamentoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pedidos_orcamento')
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("Nenhum pedido de orçamento encontrado."),
          );
        }

        final pedidos = snapshot.data!.docs;

        return ListView.builder(
          itemCount: pedidos.length,
          itemBuilder: (context, index) {
            final pedido = pedidos[index].data() as Map<String, dynamic>;
            final docId = pedidos[index].id;

            final pedidoId = pedido['pedidoIdCompleto'] ?? 'ID Indisponível';
            final status = pedido['status'] ?? 'desconhecido';
            final nomeCliente = pedido['dadosCliente']?['nome'] ?? 'Cliente não informado';
            
            final Timestamp? timestamp = pedido['createdAt'];
            final dataCriacao = timestamp != null
                ? DateFormat('dd/MM/yyyy \'às\' HH:mm').format(timestamp.toDate())
                : 'Data indisponível';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(Icons.description_outlined, color: colorScheme.onPrimaryContainer),
                ),
                title: Text(
                  pedidoId,
                  style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '$nomeCliente\nCriado em: $dataCriacao',
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                trailing: Chip(
                  label: Text(status, style: textTheme.labelSmall),
                  backgroundColor: status == 'rascunho' ? Colors.orange.shade100 : Colors.green.shade100,
                ),
                isThreeLine: true,
                onTap: () {
                  // TODO: Implementar navegação para detalhes do pedido
                },
              ),
            );
          },
        );
      },
    );
  }
}