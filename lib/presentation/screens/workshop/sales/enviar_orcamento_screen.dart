import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../state/auth_provider.dart'; // Caminho já estava correto, mantendo por clareza.
import '../../../common_widgets/shared_app_bar.dart';
import '../../../common_widgets/custom_text_field.dart';
import '../../../../core/utils/validators.dart'; // Ajuste: Import para validações.
import '../../../../data/services/pedido_orcamento_helper.dart'; // 1. Importar o helper

class EnviarOrcamentoScreen extends StatefulWidget {
  final String docId;

  const EnviarOrcamentoScreen({
    Key? key,
    required this.docId,
  }) : super(key: key);

  @override
  State<EnviarOrcamentoScreen> createState() => _EnviarOrcamentoScreenState();
}

class _EnviarOrcamentoScreenState extends State<EnviarOrcamentoScreen> {
  late Future<DocumentSnapshot> _pedidoFuture;
  final _helper = PedidoOrcamentoHelper(); // 2. Instanciar o helper
  final _formKey = GlobalKey<FormState>();

  // Controllers para o formulário de orçamento
  final _maoDeObraController = TextEditingController();
  final _materiaisController = TextEditingController();
  final _outrosCustosController = TextEditingController();
  // Ajuste: Adicionados controllers para os novos campos da Fase 5.
  final _logisticaController = TextEditingController();
  final _prazoEntregaController = TextEditingController();
  final _formasPagamentoController = TextEditingController();
  final _observacoesController = TextEditingController();

  // Estado do formulário
  double _valorTotal = 0.0;
  DateTime? _validadeOrcamento;
  bool _isLoading = false;
  bool _isFormularioPreenchido = false; // Flag para controlar o preenchimento inicial

  // Helper para formatação de moeda
  final _currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void initState() {
    super.initState();
    _pedidoFuture = FirebaseFirestore.instance
        .collection('pedidos_orcamento')
        .doc(widget.docId)
        .get();

    // Listeners para calcular o total automaticamente
    _maoDeObraController.addListener(_calcularTotal);
    _materiaisController.addListener(_calcularTotal);
    _outrosCustosController.addListener(_calcularTotal);
    _logisticaController.addListener(_calcularTotal); // Ajuste: Adicionado ao cálculo total.
  }

  @override
  void dispose() {
    _maoDeObraController.dispose();
    _materiaisController.dispose();
    _outrosCustosController.dispose();
    _observacoesController.dispose();
    _logisticaController.dispose();
    _prazoEntregaController.dispose();
    _formasPagamentoController.dispose();
    super.dispose();
  }

  void _calcularTotal() {
    final maoDeObra = double.tryParse(_maoDeObraController.text.replaceAll(',', '.')) ?? 0.0;
    final materiais = double.tryParse(_materiaisController.text.replaceAll(',', '.')) ?? 0.0;
    final outros = double.tryParse(_outrosCustosController.text.replaceAll(',', '.')) ?? 0.0;
    final logistica = double.tryParse(_logisticaController.text.replaceAll(',', '.')) ?? 0.0;
    setState(() {
      _valorTotal = maoDeObra + materiais + outros + logistica;
    });
  }

  Future<void> _selecionarDataValidade(BuildContext context) async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (dataSelecionada == null) return;
    setState(() => _validadeOrcamento = dataSelecionada);
  }

  /// Preenche o formulário se um orçamento já existir no documento.
  void _preencherFormularioSeExistir(Map<String, dynamic> pedidoData) {
    if (pedidoData.containsKey('orcamento') && pedidoData['orcamento'] != null) {
      final orcamento = pedidoData['orcamento'] as Map<String, dynamic>;

      // Usamos um post-frame callback para garantir que o setState não seja chamado durante o build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        // Formata os números para o padrão brasileiro com vírgula.
        final formatador = NumberFormat("#.00", "pt_BR");

        _maoDeObraController.text = formatador.format(orcamento['maoDeObra'] ?? 0.0);
        _materiaisController.text = formatador.format(orcamento['materiais'] ?? 0.0);
        _outrosCustosController.text = formatador.format(orcamento['outrosCustos'] ?? 0.0);
        _logisticaController.text = formatador.format(orcamento['logistica'] ?? 0.0);
        _prazoEntregaController.text = orcamento['prazoEntrega'] ?? '';
        _formasPagamentoController.text = orcamento['formasPagamento'] ?? '';
        _observacoesController.text = orcamento['observacoes'] ?? '';

        if (orcamento['validade'] is Timestamp) {
          setState(() {
            _validadeOrcamento = (orcamento['validade'] as Timestamp).toDate();
          });
        }
        // _calcularTotal() será chamado automaticamente pelos listeners dos controllers.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider?>();
    final currentUser = authProvider?.currentUser;
    final estofariaNome = (currentUser?.tipo.startsWith('pessoaJuridica') ?? false)
        ? (currentUser?.empresa ?? "Painel")
        : (currentUser?.nome ?? "Painel da Estofaria");

    return Scaffold(
      // Correção: A chamada ao SharedAppBar foi completada com todos os parâmetros
      // necessários para garantir a consistência com o resto do aplicativo.
      appBar: SharedAppBar(
        estofariaNome: estofariaNome,
        estofariaLogoUrl: currentUser?.logoUrl,
        usuarioNome: currentUser?.nome,
        usuarioFotoUrl: currentUser?.fotoUrl,
        isAdmin: currentUser?.isAdmin ?? false,
        onProfileTap: () => context.push('/profile'), // Ajuste: Adicionado callback para o perfil.
        onChangePassword: () => context.push('/change-password'),
        onSearchTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Funcionalidade de busca em breve...")),
          );
        },
        onNotificationsTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Notificações em breve...")),
          );
        },
        onLogout: () {
          context.read<AuthProvider?>()?.logoutUser();
          context.go('/login');
        },
      ),
      // Ajuste: O corpo agora é um Stack para permitir o overlay de loading.
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: FutureBuilder<DocumentSnapshot>(
                future: _pedidoFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Ajuste UX: Centraliza e destaca o loading inicial.
                    return const Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        CircularProgressIndicator(), SizedBox(height: 16), Text("Carregando pedido..."),
                      ]),
                    );
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text("Pedido não encontrado."));
                  }

                  final pedidoData = snapshot.data!.data() as Map<String, dynamic>;

                  // Preenche o formulário com dados existentes, mas apenas uma vez.
                  if (!_isFormularioPreenchido) {
                    _preencherFormularioSeExistir(pedidoData);
                    _isFormularioPreenchido = true;
                  }

                  return Card(
                    margin: const EdgeInsets.all(24),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildHeader(context, pedidoData),
                        Expanded(
                          // Ajuste UI/UX: Usa LayoutBuilder para um layout responsivo.
                          child: LayoutBuilder(builder: (context, constraints) {
                            // Em telas largas, usa duas colunas. Em telas estreitas, mantém uma.
                            if (constraints.maxWidth > 960) {
                              return _buildWideLayout(context, pedidoData);
                            }
                            return _buildNarrowLayout(context, pedidoData);
                          }),
                        ),
                        _buildFooter(context, pedidoData),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // Ajuste: Widget de overlay de loading.
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text("Salvando orçamento...", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> pedidoData) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Text(
        "Orçamento para: ${pedidoData['pedidoIdCompleto'] ?? 'ID Indisponível'}",
        style: textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Layout para telas largas (Desktop/Web)
  Widget _buildWideLayout(BuildContext context, Map<String, dynamic> pedidoData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Coluna da Esquerda: Resumo do Pedido
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 12, 24),
            child: _buildResumoColumn(context, pedidoData),
          ),
        ),
        const VerticalDivider(width: 1),
        // Coluna da Direita: Formulário de Orçamento
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 24, 24, 24),
            child: _buildFormularioOrcamento(context),
          ),
        ),
      ],
    );
  }

  /// Layout para telas estreitas (Mobile)
  Widget _buildNarrowLayout(BuildContext context, Map<String, dynamic> pedidoData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildResumoColumn(context, pedidoData),
          const SizedBox(height: 32),
          _buildFormularioOrcamento(context),
        ],
      ),
    );
  }

  /// Constrói a coluna de resumo do pedido.
  Widget _buildResumoColumn(BuildContext context, Map<String, dynamic> pedidoData) {
    final textTheme = Theme.of(context).textTheme;
    final dadosCliente = pedidoData['dadosCliente'] as Map<String, dynamic>? ?? {};
    final servicos = pedidoData['servicos'] as Map<String, dynamic>? ?? {};
    final servicosTipo = servicos['servico_tipo'] as List<dynamic>? ?? [];
    final estofados = servicos['estofados'] as List<dynamic>? ?? [];
    final fotos = pedidoData['fotos'] as List<dynamic>? ?? [];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Resumo do Pedido Solicitado", style: textTheme.titleLarge),
            const Divider(height: 24),
            // Ajuste UX: Usar ExpansionTile para organizar a informação.
            _buildResumoCliente(context, dadosCliente),
            _buildResumoServicos(context, servicosTipo, estofados),
            if (fotos.isNotEmpty) _buildResumoFotos(context, fotos),
          ],
        ),
      ),
    );
  }

  Widget _buildFormularioOrcamento(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Formulário de Orçamento", style: textTheme.titleLarge),
              const Divider(height: 24),
              Text("Custos", style: textTheme.titleMedium),
              const SizedBox(height: 16),
              CustomTextField(
            controller: _maoDeObraController,
            label: "Custo Mão de Obra (R\$)",
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d{0,2}'))],
            validator: Validators.number, // Ajuste: Adicionada validação.
          ),
          const SizedBox(height: 12),
              CustomTextField(
            controller: _materiaisController,
            label: "Custo Materiais (R\$)",
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d{0,2}'))],
            validator: Validators.number, // Ajuste: Adicionada validação.
          ),
          const SizedBox(height: 12),
              CustomTextField(
            controller: _outrosCustosController,
            label: "Outros Custos (R\$)",
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d{0,2}'))],
          ),
          const SizedBox(height: 12),
              CustomTextField(
            controller: _logisticaController,
            label: "Valor Logística (Coleta/Entrega) (R\$)",
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d{0,2}'))],
          ),
          const SizedBox(height: 24),
              Text("Prazos e Condições", style: textTheme.titleMedium),
              const SizedBox(height: 16),
              CustomTextField(
            controller: _prazoEntregaController,
            label: "Prazo de Entrega (ex: 15 dias úteis)",
            validator: Validators.requiredField, // Ajuste: Adicionada validação.
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _formasPagamentoController,
            label: "Formas de Pagamento (ex: 50% sinal + 50% entrega)",
            maxLines: 2,
            validator: Validators.requiredField, // Ajuste: Adicionada validação.
          ),
          const SizedBox(height: 16),
              ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text("Validade do Orçamento"),
            subtitle: Text(
              _validadeOrcamento == null
                  ? 'Selecione uma data'
                  : DateFormat('dd/MM/yyyy').format(_validadeOrcamento!),
            ),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: () => _selecionarDataValidade(context),
          ),
          const SizedBox(height: 12),
              Text("Informações Adicionais", style: textTheme.titleMedium),
              const SizedBox(height: 16),
              CustomTextField(
            controller: _observacoesController,
            label: "Observações (visível para o cliente)",
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
                  child: Text("Valor Total: ${_currencyFormatter.format(_valorTotal)}",
                      style: textTheme.headlineSmall?.copyWith(color: colorScheme.onSecondaryContainer))),
          ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResumoCliente(BuildContext context, Map<String, dynamic> dadosCliente) {
    final textTheme = Theme.of(context).textTheme;
    return ExpansionTile(
      leading: const Icon(Icons.person_outline),
      title: Text("Dados do Cliente", style: textTheme.titleMedium),
      initiallyExpanded: true,
      children: [
        ListTile(
          title: Text(dadosCliente['nome'] ?? 'Nome não informado'),
          subtitle: Text(
            "Telefone: ${dadosCliente['telefone'] ?? 'N/A'}\nE-mail: ${dadosCliente['email'] ?? 'N/A'}",
          ),
          isThreeLine: true,
        ),
      ],
    );
  }

  Widget _buildResumoServicos(BuildContext context, List<dynamic> servicosTipo, List<dynamic> estofados) {
    final textTheme = Theme.of(context).textTheme;
    return ExpansionTile(
      leading: const Icon(Icons.home_repair_service_outlined),
      title: Text("Serviços Solicitados", style: textTheme.titleMedium),
      initiallyExpanded: true,
      children: [
        ListTile(title: Text("Tipo: ${servicosTipo.join(', ')}")),
        ...estofados.map((item) {
          final estofado = item as Map<String, dynamic>;
          return ListTile(
            title: Text("${estofado['nome'] ?? 'Item'} (Qtd: ${estofado['quantidade'] ?? 'N/A'})"),
            subtitle: Text(estofado['descricao'] ?? 'Sem descrição.'),
          );
        }),
      ],
    );
  }

  Widget _buildResumoFotos(BuildContext context, List<dynamic> fotos) {
    final textTheme = Theme.of(context).textTheme;
    return ExpansionTile(
      leading: const Icon(Icons.photo_library_outlined),
      title: Text("Fotos do Cliente", style: textTheme.titleMedium),
      initiallyExpanded: false,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildFotosGrid(fotos),
        ),
      ],
    );
  }

  Widget _buildFotosGrid(List<dynamic> fotos) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: fotos.length,
      itemBuilder: (context, index) {
        final fotoUrl = fotos[index] as String;
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(fotoUrl, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator(strokeWidth: 2.0));
              }),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context, Map<String, dynamic> pedidoData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!_isLoading) // Ajuste: O indicador de loading foi movido para o overlay.
            ElevatedButton.icon(
              icon: const Icon(Icons.send_outlined),
              label: const Text("Salvar e Enviar"),
              onPressed: () => _salvarEEnviar(pedidoData),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _salvarEEnviar(Map<String, dynamic> pedidoData) async {
    // Ajuste: Adicionada validação do formulário.
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, corrija os erros no formulário.")),
      );
      return;
    }

    if (_validadeOrcamento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, selecione a data de validade do orçamento.")),
      );
      return;
    }

    // Ajuste: Adicionado diálogo de confirmação antes de enviar.
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar Envio"),
        content: const Text("Deseja realmente enviar este orçamento para o cliente?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Sim, Enviar"),
          ),
        ],
      ),
    );

    if (confirmado != true) return;

    setState(() => _isLoading = true);

    try {
      final orcamentoData = {
        'maoDeObra': double.tryParse(_maoDeObraController.text.replaceAll(',', '.')) ?? 0.0,
        'materiais': double.tryParse(_materiaisController.text.replaceAll(',', '.')) ?? 0.0,
        'outrosCustos': double.tryParse(_outrosCustosController.text.replaceAll(',', '.')) ?? 0.0,
        'logistica': double.tryParse(_logisticaController.text.replaceAll(',', '.')) ?? 0.0,
        'prazoEntrega': _prazoEntregaController.text,
        'formasPagamento': _formasPagamentoController.text,
        'valorTotal': _valorTotal,
        'validade': Timestamp.fromDate(_validadeOrcamento!),
        'observacoes': _observacoesController.text,
        'criadoEm': FieldValue.serverTimestamp(),
        'atualizadoEm': FieldValue.serverTimestamp(),
      };

      // Se já existe um orçamento, preserva a data de criação original.
      final orcamentoExistente = pedidoData['orcamento'] as Map<String, dynamic>?;
      if (orcamentoExistente != null && orcamentoExistente.containsKey('criadoEm')) {
        orcamentoData['criadoEm'] = orcamentoExistente['criadoEm'];
      }

      // 3. Refatorar para usar o helper centralizado
      final userId = context.read<AuthProvider?>()?.currentUser?.uid ?? 'sistema';

      await _helper.atualizarStatusPedido(
        docId: widget.docId,
        statusCode: 'EO', // Orçamento Enviado
        userId: userId,
        dadosAdicionais: {'orcamento': orcamentoData}, // Passa o orçamento como dado adicional
      );

      // Usamos context.pop() para um comportamento mais natural de "voltar"
      if (mounted) context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro ao salvar: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
