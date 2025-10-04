import 'package:flutter/material.dart';

import '../../data/services/pedido_orcamento_helper.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';
import '../../core/utils/validators.dart';

class Fase2ServicoStep extends StatefulWidget {
  final String docId; // ID do pedido no Firestore (âncora)
  final VoidCallback? onStepComplete;

  const Fase2ServicoStep({
    Key? key,
    required this.docId,
    this.onStepComplete,
  }) : super(key: key);

  @override
  State<Fase2ServicoStep> createState() => _Fase2ServicoStepState();
}

class _Fase2ServicoStepState extends State<Fase2ServicoStep> {
  final _formKey = GlobalKey<FormState>();
  final PedidoOrcamentoHelper _helper = PedidoOrcamentoHelper();

  // Serviços (multi-select) - opções definidas pela documentação
  final Set<String> _servicosSelecionados = {};

  // Estofados (multi-select) + controllers para quantidade
  final Map<String, TextEditingController> _estofadoQtdControllers = {
    "Sofá": TextEditingController(),
    "Poltrona": TextEditingController(),
    "Cadeira": TextEditingController(),
    "Outros": TextEditingController(),
  };

  // Seleção booleana de qual estofado foi escolhido
  final Map<String, bool> _estofadoSelecionado = {
    "Sofá": false,
    "Poltrona": false,
    "Cadeira": false,
    "Outros": false,
  };

  // Descrição geral do serviço
  final _descricaoDetalhadaController = TextEditingController();

  // Descrição para "Outros" estofados
  final _descricaoOutrosController = TextEditingController();

  // Campos extras para Sofá
  String? _sofaAssentosSelecionado; // '2','3','4','5','Outro'
  final TextEditingController _sofaAssentosOutroController = TextEditingController();
  bool _sofaPossuiChaise = false;

  bool _isLoading = false;

  @override
  void dispose() {
    _descricaoDetalhadaController.dispose();
    _descricaoOutrosController.dispose();
    _sofaAssentosOutroController.dispose();
    for (var c in _estofadoQtdControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    // Construir o payload de estofados
    final Map<String, dynamic> estofados = {};
    for (final tipo in _estofadoSelecionado.keys) {
      if (_estofadoSelecionado[tipo] == true) {
        final text = _estofadoQtdControllers[tipo]?.text ?? '';
        final qtd = int.tryParse(text) ?? 0;

        // Ajuste solicitado: Restaurada a lógica para salvar detalhes específicos de cada tipo de estofado.
        if (tipo == "Sofá") {
          final assentos = _sofaAssentosSelecionado == 'Outro'
              ? int.tryParse(_sofaAssentosOutroController.text) ?? 0
              : int.tryParse(_sofaAssentosSelecionado ?? '0') ?? 0;

          estofados['Sofá'] = {
            'quantidade': qtd,
            'assentos': assentos,
            'possuiChaise': _sofaPossuiChaise,
          };
        } else if (tipo == "Outros") {
          estofados['Outros'] = {
            'quantidade': qtd,
            'descricao': _descricaoOutrosController.text.trim(),
          };
        } else {
          // Para "Poltrona" e "Cadeira"
          estofados[tipo] = {
            'quantidade': qtd,
          };
        }
      }
    }

    // Se chegou aqui, payload pronto
    final payload = {
      'servicosSelecionados': _servicosSelecionados.toList(),
      'estofados': estofados,
      'detalhes': _descricaoDetalhadaController.text.trim(),
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };

    setState(() => _isLoading = true);

    try {
      await _helper.salvarServicos(
        docId: widget.docId,
        servicos: payload,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Serviços salvos com sucesso.')),
        );
        widget.onStepComplete?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar serviço: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildServicoChips() {
    final servicos = ['Produção', 'Reforma', 'Impermeabilização', 'Higienização'];

    return Wrap(
      spacing: 8,
      children: servicos.map((s) {
        final selected = _servicosSelecionados.contains(s);
        return FilterChip(
          label: Text(s),
          selected: selected,
          onSelected: (val) {
            setState(() {
              if (val) {
                _servicosSelecionados.add(s);
              } else {
                _servicosSelecionados.remove(s);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildEstofadosInputs() {
    // mantém a ordem: Sofá, Poltrona, Cadeira, Outros
    return Column(
      children: _estofadoQtdControllers.keys.map((tipo) {
        final selected = _estofadoSelecionado[tipo] ?? false;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: selected,
                    onChanged: (val) {
                      setState(() {
                        _estofadoSelecionado[tipo] = val ?? false;
                        // se desmarcou, limpa a qtd
                        if (!(val ?? false)) {
                          _estofadoQtdControllers[tipo]?.text = '';
                        }
                      });
                    },
                  ),
                  Expanded(child: Text(tipo, style: Theme.of(context).textTheme.bodyMedium)),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 100,
                    child: CustomTextField(
                      controller: _estofadoQtdControllers[tipo],
                      label: 'Qtd',
                      hintText: '0',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (selected) {
                          final num = int.tryParse(value ?? '');
                          if (num == null || num <= 0) return 'Qtd > 0';
                        }
                        return null;
                      },
                      enabled: selected,
                    ),
                  ),
                ],
              ),
              if (tipo == "Sofá" && (selected)) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _sofaAssentosSelecionado, // Ajuste solicitado: Adicionado validador
                        decoration: const InputDecoration(labelText: 'Assentos (por sofá)'),
                        items: const [
                          DropdownMenuItem(value: '2', child: Text('2 assentos')),
                          DropdownMenuItem(value: '3', child: Text('3 assentos')),
                          DropdownMenuItem(value: '4', child: Text('4 assentos')),
                          DropdownMenuItem(value: '5', child: Text('5 assentos')),
                          DropdownMenuItem(value: 'Outro', child: Text('Outro')),
                        ],
                        onChanged: (v) {
                          setState(() => _sofaAssentosSelecionado = v);
                        },
                        validator: (v) {
                          if (selected && (v == null || v.isEmpty)) {
                            return 'Selecione os assentos';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        children: [
                          Checkbox(
                            value: _sofaPossuiChaise,
                            onChanged: (v) => setState(() => _sofaPossuiChaise = v ?? false),
                          ),
                          const SizedBox(width: 4),
                          const Text('Possui chaise?'),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_sofaAssentosSelecionado == 'Outro') ...[
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _sofaAssentosOutroController,
                    label: 'Informe número de assentos',
                    validator: (v) { // Ajuste solicitado: Adicionado validador
                      if (_sofaAssentosSelecionado == 'Outro') {
                        return Validators.requiredField(v);
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                ],
              ],
              if (tipo == "Outros" && (selected)) ...[
                const SizedBox(height: 8),
                CustomTextField( // Ajuste solicitado: Adicionado validador
                  controller: _descricaoOutrosController,
                  validator: (v) => selected ? Validators.requiredField(v) : null,
                  label: 'Descreva o tipo (Outros)',
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          color: scheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: scheme.outline.withOpacity(0.4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.home_repair_service_outlined, size: 40, color: scheme.primary),
                  const SizedBox(height: 12),
                  Text(
                    "Detalhes do Serviço",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Serviços (multi-select)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Tipo de serviço', style: textTheme.labelLarge),
                  ),
                  const SizedBox(height: 8),
                  _buildServicoChips(),
                  const SizedBox(height: 16),

                  // Estofados (multi + qtd + extras)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Tipo(s) de estofado', style: textTheme.labelLarge),
                  ),
                  const SizedBox(height: 8),
                  _buildEstofadosInputs(),
                  const SizedBox(height: 12),

                  // Detalhes do serviço (livre)
                  CustomTextField(
                    controller: _descricaoDetalhadaController,
                    label: 'Detalhes do serviço',
                    hintText: 'Ex: trocar espuma, trocar tecido, reparar apoio...',
                    maxLines: 4,
                    validator: Validators.requiredField, // Ajuste solicitado: Corrigido nome do validador
                  ),
                  const SizedBox(height: 18),

                  // Botão salvar/continuar
                  CustomButton(
                    label: _isLoading ? 'Salvando...' : 'Salvar e Continuar',
                    onPressed: _isLoading ? null : _salvar,
                    type: ButtonType.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
