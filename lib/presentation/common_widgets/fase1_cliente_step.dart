// lib/presentation/common_widgets/fase1_cliente_step.dart
//
// Ajustes aplicados:
// - Inclus�o dos campos de endere�o (CEP, Rua, N�mero, Bairro, Cidade, Estado).
// - Integra��o com API ViaCEP para preenchimento autom�tico.
// - Responsividade: campos reorganizados em duas colunas em telas maiores.
// - Mantida a estrutura original (CustomTextField + Validators + CustomButton).
// - Endere�o salvo junto com dadosCliente no Firestore.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/validators.dart';
import '../../data/services/pedido_orcamento_helper.dart';
import '../common_widgets/custom_text_field.dart';
import '../common_widgets/custom_button.dart';

class Fase1ClienteStep extends StatefulWidget {
  final String docId; // Ajuste: O ID correto para salvar é o docId do Firestore.
  final VoidCallback onStepComplete;

  const Fase1ClienteStep({
    super.key,
    required this.docId,
    required this.onStepComplete,
  });

  @override
  State<Fase1ClienteStep> createState() => _Fase1ClienteStepState();
}

class _Fase1ClienteStepState extends State<Fase1ClienteStep> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();

  bool _isLoading = false;
  bool _isConsultandoCep = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _cepController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    super.dispose();
  }

  Future<void> _consultarCep() async {
    final cep = _cepController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Digite um CEP v�lido (8 d�gitos).")),
      );
      return;
    }

    setState(() => _isConsultandoCep = true);

    try {
      final response = await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["erro"] == true) {
          throw Exception("CEP n�o encontrado.");
        }
        setState(() {
          _ruaController.text = data["logradouro"] ?? "";
          _bairroController.text = data["bairro"] ?? "";
          _cidadeController.text = data["localidade"] ?? "";
          _estadoController.text = data["uf"] ?? "";
        });
      } else {
        throw Exception("Erro ao consultar CEP.");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isConsultandoCep = false);
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await PedidoOrcamentoHelper().salvarStep1(
        docId: widget.docId, // Ajuste: Usar o docId passado para o widget.
        dadosCliente: {
          'nome': _nomeController.text.trim(),
          'cpf': _cpfController.text.trim(),
          'telefone': _telefoneController.text.trim(),
          'email': _emailController.text.trim(),
          'endereco': {
            'cep': _cepController.text.trim(),
            'rua': _ruaController.text.trim(),
            'numero': _numeroController.text.trim(),
            'bairro': _bairroController.text.trim(),
            'cidade': _cidadeController.text.trim(),
            'estado': _estadoController.text.trim(),
          }
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dados do cliente salvos com sucesso.")),
        );
        widget.onStepComplete();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao salvar cliente: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isLarge = constraints.maxWidth >= 600;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Dados do Cliente", style: textTheme.titleLarge),
                  const SizedBox(height: 16),

                  // Nome
                  CustomTextField(
                    controller: _nomeController,
                    label: "Nome completo",
                    validator: Validators.requiredField,
                  ),
                  const SizedBox(height: 12),

                  // CPF
                  CustomTextField(
                    controller: _cpfController,
                    label: "CPF",
                    validator: Validators.cpf,
                  ),
                  const SizedBox(height: 12),

                  // Telefone
                  CustomTextField(
                    controller: _telefoneController,
                    label: "Telefone",
                    keyboardType: TextInputType.phone,
                    validator: Validators.telefone,
                  ),
                  const SizedBox(height: 12),

                  // Email
                  CustomTextField(
                    controller: _emailController,
                    label: "E-mail",
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 20),

                  Text("Endere�o", style: textTheme.titleMedium),
                  const SizedBox(height: 12),

                  // CEP + bot�o consultar
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          controller: _cepController,
                          label: "CEP",
                          keyboardType: TextInputType.number,
                          validator: Validators.cep,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: CustomButton(
                          label: "Consultar",
                          isLoading: _isConsultandoCep,
                          onPressed: _consultarCep,
                          type: ButtonType.secondary,
                          icon: Icons.search,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Rua e N�mero (lado a lado se tela grande)
                  isLarge
                      ? Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: CustomTextField(
                                controller: _ruaController,
                                label: "Rua",
                                validator: Validators.requiredField,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: CustomTextField(
                                controller: _numeroController,
                                label: "N�mero",
                                keyboardType: TextInputType.number,
                                validator: Validators.requiredField,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            CustomTextField(
                              controller: _ruaController,
                              label: "Rua",
                              validator: Validators.requiredField,
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              controller: _numeroController,
                              label: "N�mero",
                              keyboardType: TextInputType.number,
                              validator: Validators.requiredField,
                            ),
                          ],
                        ),
                  const SizedBox(height: 12),

                  // Bairro e Cidade
                  isLarge
                      ? Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomTextField(
                                controller: _bairroController,
                                label: "Bairro",
                                validator: Validators.requiredField,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: CustomTextField(
                                controller: _cidadeController,
                                label: "Cidade",
                                validator: Validators.requiredField,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            CustomTextField(
                              controller: _bairroController,
                              label: "Bairro",
                              validator: Validators.requiredField,
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              controller: _cidadeController,
                              label: "Cidade",
                              validator: Validators.requiredField,
                            ),
                          ],
                        ),
                  const SizedBox(height: 12),

                  // Estado (UF)
                  CustomTextField(
                    controller: _estadoController,
                    label: "Estado (UF)",
                    validator: Validators.requiredField,
                  ),

                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      label: "Salvar e continuar",
                      isLoading: _isLoading,
                      onPressed: _salvar,
                      icon: Icons.check,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
