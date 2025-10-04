import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ListaPedidosOrcamentoWidget extends StatelessWidget {
  // Helper para obter as propriedades visuais de cada status.
  // Agora recebe o código do status (ex: 'PO', 'AP', 'EO').
  // Ajuste solicitado: Cores vibrantes e retorno da abreviação.
  (Color, String) _getStatusProperties(String statusCode, String statusLabel, BuildContext context) {
    switch (statusCode) {
      case 'PO': // Pedido de Orçamento (Rascunho)
        return (Colors.grey.shade500, statusCode);
      case 'AP': // Aguardando Precificação
        return (const Color(0xFFFFA726), statusCode); // Laranja (Atenção)
      case 'EO': // Orçamento Enviado
        return (const Color(0xFF66BB6A), statusCode); // Verde (Enviado)
      case 'AV': // Aguardando Agendamento de Visita
        return (const Color(0xFFAB47BC), statusCode); // Roxo (Aprovado)
      case 'VT': // Visita Técnica
        return (const Color(0xFF26C6DA), statusCode); // Ciano (Agendado)
      case 'OS': // Ordem de Serviço
        return (const Color(0xFF42A5F5), statusCode); // Azul (Oficial)
      default:
        // Um fallback para status desconhecidos.
        return (
          Theme.of(context).colorScheme.surfaceVariant,
          statusLabel.length > 20 ? '${statusLabel.substring(0, 17)}...' : statusLabel,
        );
    }
  }

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
            final nomeCliente = pedido['dadosCliente']?['nome'] ?? 'Cliente não informado';
            
            // Lógica para ler o novo objeto de status
            String statusCode = 'desconhecido';
            String statusLabel = 'Desconhecido';
            if (pedido['status'] is Map) {
              statusCode = pedido['status']['code'] ?? 'desconhecido';
              statusLabel = pedido['status']['label'] ?? 'Status inválido';
            } else if (pedido['status'] is String) {
              // Mantém compatibilidade com status antigos (string)
              statusLabel = pedido['status'];
              if (statusLabel == 'rascunho') statusCode = 'PO';
            }

            final Timestamp? timestamp = pedido['createdAt'];
            final (statusColor, displayLabel) = _getStatusProperties(statusCode, statusLabel, context);

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
                trailing: Tooltip(
                  message: statusLabel, // Ajuste solicitado: Nome completo no hover.
                  child: Chip(
                    label: Text(displayLabel, // Ajuste solicitado: Abreviação no chip.
                        style: textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    backgroundColor: statusColor,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                ),
                isThreeLine: true,
                onTap: () {
                  // Navegação baseada no status do pedido.
                  if (statusCode == 'PO') {
                    // Se o pedido ainda é um rascunho, continua no formulário.
                    context.push('/estofaria-dashboard/pedido-orcamento', extra: {
                      'docId': docId,
                      'pedidoIdCompleto': pedidoId,
                      'fromPanel': 'estofaria', // Correção: Adicionado o parâmetro obrigatório.
                    });
                  } else if (statusCode == 'AP' || statusCode == 'EO') {
                    // Se o pedido foi finalizado pelo cliente ou um orçamento já foi enviado,
                    // vai para a tela de orçamento para criar, visualizar ou editar.
                    context.push('/estofaria-dashboard/enviar-orcamento/$docId');
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}