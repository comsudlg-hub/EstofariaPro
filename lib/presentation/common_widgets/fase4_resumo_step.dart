// lib/presentation/common_widgets/fase4_resumo_step.dart
//
// Ajustes aplicados:
// - Inclusão do endereço completo (coletado na Fase 1).
// - Uso de CustomCard e CustomButton padronizados.
// - Responsividade com LayoutBuilder.
// - Lógica de confirmação via PedidoOrcamentoHelper.finalizarPedido.
// - Correção: campo "uf" (não "estado") no endereço.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/services/pedido_orcamento_helper.dart';
import '../common_widgets/custom_card.dart';
import '../common_widgets/custom_button.dart';

class Fase4ResumoStep extends StatefulWidget {
  final String docId;
  final VoidCallback onConfirmed;

  const Fase4ResumoStep({
    super.key,
    required this.docId,
    required this.onConfirmed,
  });

  @override
  State<Fase4ResumoStep> createState() => _Fase4ResumoStepState();
}

class _Fase4ResumoStepState extends State<Fase4ResumoStep> {
  bool _isLoading = true;
  bool _isConfirming = false;
  Map<String, dynamic>? _pedidoData;

  @override
  void initState() {
    super.initState();
    _carregarResumo();
  }

  Future<void> _carregarResumo() async {
    setState(() => _isLoading = true);
    try {
      final doc = await FirebaseFirestore.instance
          .collection("pedidos_orcamento")
          .doc(widget.docId)
          .get();
      if (doc.exists) {
        setState(() => _pedidoData = doc.data());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao carregar resumo: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmarPedido() async {
    setState(() => _isConfirming = true);
    try {
      await PedidoOrcamentoHelper().finalizarPedido(docId: widget.docId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pedido confirmado com sucesso!")),
        );
        widget.onConfirmed();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao confirmar pedido: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isConfirming = false);
    }
  }

  Widget _buildClienteCard(Map<String, dynamic> dadosCliente) {
    final endereco = dadosCliente["endereco"] ?? {};
    return CustomCard(
      title: "Dados do Cliente",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nome: ${dadosCliente["nome"] ?? ""}"),
          Text("CPF: ${dadosCliente["cpf"] ?? ""}"),
          Text("Telefone: ${dadosCliente["telefone"] ?? ""}"),
          Text("E-mail: ${dadosCliente["email"] ?? ""}"),
          const SizedBox(height: 8),
          Text("Endereço:"),
          Text("${endereco["rua"] ?? ""}, Nº ${endereco["numero"] ?? ""}"),
          Text("${endereco["bairro"] ?? ""}"),
          Text("${endereco["cidade"] ?? ""} - ${endereco["uf"] ?? ""}"),
          Text("CEP: ${endereco["cep"] ?? ""}"),
        ],
      ),
    );
  }

  Widget _buildServicoCard(Map<String, dynamic> dados) {
    return CustomCard(
      title: "Serviço",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dados["servicos"] != null)
            Text("Serviços: ${(dados["servicos"] as List).join(", ")}"),
          if (dados["estofados"] != null)
            Text("Estofados: ${(dados["estofados"] as Map).toString()}"),
          if (dados["detalhes_servico"] != null)
            Text("Detalhes: ${dados["detalhes_servico"]}"),
        ],
      ),
    );
  }

  Widget _buildFotosCard(Map<String, dynamic> dados) {
    final fotos = (dados["fotos"] ?? []) as List;
    return CustomCard(
      title: "Fotos",
      child: fotos.isEmpty
          ? const Text("Nenhuma foto enviada.")
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: fotos
                  .map((url) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ))
                  .toList(),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_pedidoData == null) {
      return const Center(child: Text("Pedido não encontrado."));
    }

    final dadosCliente =
        (_pedidoData!["dadosCliente"] ?? {}) as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isLarge = constraints.maxWidth >= 600;

          return Column(
            children: [
              isLarge
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildClienteCard(dadosCliente)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildServicoCard(_pedidoData!)),
                      ],
                    )
                  : Column(
                      children: [
                        _buildClienteCard(dadosCliente),
                        const SizedBox(height: 16),
                        _buildServicoCard(_pedidoData!),
                      ],
                    ),
              const SizedBox(height: 16),
              _buildFotosCard(_pedidoData!),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  label: "Confirmar Pedido",
                  icon: Icons.check,
                  isLoading: _isConfirming,
                  onPressed: _confirmarPedido,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
