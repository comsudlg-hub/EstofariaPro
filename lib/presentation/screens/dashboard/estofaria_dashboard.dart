// lib/presentation/screens/dashboard/estofaria_dashboard.dart
// Versão ajustada: menus, submenu à esquerda, diálogo de confirmação
// e após confirmação cria o pedido no Firestore e navega para a tela PedidoOrcamentoScreen.
//
// Ajustes aplicados:
// - SharedAppBar(estofariaNome: ...)
// - createTextTheme(Theme.of(context).brightness)
// - Layout desktop: 4 botões compactos no topo (Row) + espaço para resumos
// - Layout mobile: mantém GridView
// - Rodapé destacado
// - _buildModuleCard estilo botão compacto
// - Pedido de Orçamento agora abre nova tela (PedidoOrcamentoScreen) via router

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Guia de Padronização
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/utils/text_theme_util.dart';

// Widgets reutilizáveis
import '../../common_widgets/shared_app_bar.dart';
import '../../common_widgets/custom_button.dart';
import '../../common_widgets/lista_pedidos_orcamento_widget.dart';

// Serviços / providers
import '../../../data/services/pedido_orcamento_helper.dart'; // Ajuste solicitado: Mantido o import correto.
import '../../../state/auth_provider.dart';
import '../../../state/order_provider.dart';
import '../../../data/repositories/order_repository.dart';

class EstofariaDashboard extends StatefulWidget {
  const EstofariaDashboard({Key? key}) : super(key: key);

  @override
  State<EstofariaDashboard> createState() => _EstofariaDashboardState();
}

class _EstofariaDashboardState extends State<EstofariaDashboard> {
  final List<Map<String, dynamic>> _modules = [
    {'id': 'Vendas', 'label': 'Vendas', 'icon': Icons.point_of_sale},
    {'id': 'Produção', 'label': 'Produção', 'icon': Icons.factory},
    {'id': 'Logística', 'label': 'Logística', 'icon': Icons.local_shipping},
    {'id': 'Gestão', 'label': 'Gestão', 'icon': Icons.manage_accounts},
  ];

  final Map<String, List<Map<String, dynamic>>> _submenuMap = {
    'Vendas': [
      {
        'id': 'pedido_orcamento',
        'label': 'Pedido de Orçamento',
        'route': '/estofaria-dashboard/pedido-orcamento',
        'icon': Icons.description_outlined,
      },
      {
        'id': 'enviar_orcamento',
        'label': 'Enviar Orçamento',
        'route': '/estofaria-dashboard/enviar-orcamento',
        'icon': Icons.send_outlined,
      },
      {
        'id': 'agendar_visita',
        'label': 'Agendar Visita',
        'route': '/estofaria-dashboard/agendar-visita',
        'icon': Icons.event_available_outlined,
      },
      {
        'id': 'ordem_servico',
        'label': 'Ordem de Serviço (OS)',
        'route': '/estofaria-dashboard/ordem-servico',
        'icon': Icons.assignment_turned_in_outlined,
      },
    ],
    'Logística': [
      {
        'id': 'entregas',
        'label': 'Entregas',
        'route': '/estofaria-dashboard/entregas',
        'icon': Icons.local_shipping_outlined,
      },
      {
        'id': 'atribuicao_entregadores',
        'label': 'Atribuição de Entregadores',
        'route': '/estofaria-dashboard/atribuicao-entregadores',
        'icon': Icons.person_add_alt_1_outlined,
      },
      {
        'id': 'status_entrega',
        'label': 'Status de Entrega',
        'route': '/estofaria-dashboard/status-entrega',
        'icon': Icons.track_changes_outlined,
      },
      {
        'id': 'upload_comprovantes',
        'label': 'Upload de Comprovantes',
        'route': '/estofaria-dashboard/upload-comprovantes',
        'icon': Icons.upload_file,
      },
    ],
    'Produção': [
      {
        'id': 'ordens_producao',
        'label': 'Ordens de Produção',
        'route': '/estofaria-dashboard/ordens-producao',
        'icon': Icons.build_outlined,
      },
      {
        'id': 'progresso_producao',
        'label': 'Progresso (%)',
        'route': '/estofaria-dashboard/progresso-producao',
        'icon': Icons.show_chart_outlined,
      },
      {
        'id': 'conclusao_producao',
        'label': 'Conclusão (libera logística)',
        'route': '/estofaria-dashboard/conclusao-producao',
        'icon': Icons.check_circle_outline,
      },
    ],
    'Gestão': [
      {
        'id': 'funcionarios',
        'label': 'Funcionários',
        'route': '/estofaria-dashboard/funcionarios',
        'icon': Icons.people_outline,
      },
      {
        'id': 'relatorios',
        'label': 'Relatórios',
        'route': '/estofaria-dashboard/relatorios',
        'icon': Icons.bar_chart_outlined,
      },
      {
        'id': 'compras',
        'label': 'Compras de Materiais/Tecidos',
        'route': '/estofaria-dashboard/compras',
        'icon': Icons.shopping_cart_outlined,
      },
    ],
  };

  String _selectedModule = 'Vendas';
  String? _selectedSubmenuId;

  @override
  void initState() {
    super.initState();
    _selectedSubmenuId = null;
  }

  void _selectModule(String module) {
    setState(() {
      _selectedModule = module;
      _selectedSubmenuId = null;
    });
  }

  Future<void> _selectSubmenu(String id, String? route, BuildContext context) async {
    if (id == 'pedido_orcamento') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Iniciar Pedido de Orçamento'),
          content: const Text('Deseja realmente iniciar um novo Pedido de Orçamento?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;

      final auth = context.read<AuthProvider?>();
      final estofariaId = auth?.currentUser?.uid;
      if (estofariaId == null || estofariaId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: usuário não identificado.')),
        );
        return;
      }

      try {
        final helper = PedidoOrcamentoHelper();
        // Ajuste solicitado: Passar o estofariaId como clienteId também, representando um pedido de balcão.
        final result = await helper.criarPedidoOrcamento(
          estofariaId: estofariaId,
          clienteId: estofariaId, 
        );

        final docId = result['docId'];
        final pedidoIdCompleto = result['pedidoIdCompleto'];

        // AGORA NAVEGA PARA A NOVA TELA, passando os dados necessários.
        if (mounted) {
          context.push('/estofaria-dashboard/pedido-orcamento', extra: {
            'docId': docId,
            'pedidoIdCompleto': pedidoIdCompleto,
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao criar pedido: $e')),
          );
        }
      }
      return; // Finaliza a execução aqui para não continuar para o setState abaixo.
    }

    setState(() {
      _selectedSubmenuId = id;
    });

    if (route != null) {
      context.push(route);
    }
  }

  void _showSubmenu(BuildContext context, String moduleId) {
    final submenu = _submenuMap[moduleId];
    if (submenu == null) return;

    showModalBottomSheet(
      context: context,
      builder: (_) => ListView(
        shrinkWrap: true,
        children: submenu.map((item) {
          return ListTile(
            leading: Icon(item['icon'], color: Theme.of(context).colorScheme.primary),
            title: Text(item['label'],
                style: createTextTheme(Theme.of(context).brightness).bodyLarge),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pop(context);
              _selectSubmenu(item['id'], item['route'], context);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, Map<String, dynamic> module) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 6,
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showSubmenu(context, module['id']),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(module['icon'], size: 36, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                module['label'],
                textAlign: TextAlign.center,
                style: createTextTheme(Theme.of(context).brightness).bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftSidebar(BuildContext context, double width) {
    final submenu = _submenuMap[_selectedModule] ?? [];
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          ..._modules.map((m) {
            final selected = m['id'] == _selectedModule;
            return ListTile(
              leading: Icon(m['icon'],
                  color: selected ? Theme.of(context).colorScheme.primary : null),
              title: Text(m['label'],
                  style: createTextTheme(Theme.of(context).brightness).bodyLarge),
              tileColor:
                  selected ? Theme.of(context).colorScheme.primary.withOpacity(0.08) : null,
              onTap: () => _selectModule(m['id']),
            );
          }).toList(),
          const Divider(),
          Expanded(
            child: ListView(
              children: submenu.map((s) {
                return ListTile(
                  leading: Icon(s['icon'], color: Theme.of(context).colorScheme.primary),
                  title: Text(s['label'],
                      style: createTextTheme(Theme.of(context).brightness).bodyMedium),
                  selected: _selectedSubmenuId == s['id'],
                  onTap: () => _selectSubmenu(s['id'], s['route'], context),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ajuste solicitado: O nome da estofaria agora é consumido diretamente do AuthProvider.
    final authProvider = context.watch<AuthProvider?>();
    final currentUser = authProvider?.currentUser;

    // Ajuste para exibir o nome da empresa para PJ ou o nome para PF.
    final estofariaNome = (currentUser?.tipo.startsWith('pessoaJuridica') ?? false)
        ? (currentUser?.empresa ?? "Painel")
        : (currentUser?.nome ?? "Painel da Estofaria");

    final isWide = MediaQuery.of(context).size.width >= 1024;

    return Scaffold(
      // Ajuste: Passando os callbacks e dados do usuário para o SharedAppBar.
      appBar: SharedAppBar(
        estofariaNome: estofariaNome,
        estofariaLogoUrl: currentUser?.logoUrl,
        usuarioNome: currentUser?.nome,
        usuarioFotoUrl: currentUser?.fotoUrl,
        isAdmin: currentUser?.isAdmin ?? false,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isWide
            ? Row(
                children: [
                  _buildLeftSidebar(context, 320),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _modules.map((module) {
                            return SizedBox(
                              width: 120,
                              height: 100,
                              child: _buildModuleCard(context, module),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        // Ajuste: Preparando a área de conteúdo para a lista de pedidos.
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pedidos Recentes",
                                style: createTextTheme(Theme.of(context).brightness).titleLarge,
                              ),
                              const Divider(),
                              const Expanded(child: ListaPedidosOrcamentoWidget()), // Placeholder para a lista
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  GridView.count(
                    crossAxisCount: kIsWeb ? 4 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: _modules.map((module) {
                      return _buildModuleCard(context, module);
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Ajuste: Preparando a área de conteúdo para a lista de pedidos.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pedidos Recentes",
                          style: createTextTheme(Theme.of(context).brightness).titleLarge,
                        ),
                        const Divider(),
                        const Expanded(child: ListaPedidosOrcamentoWidget()), // Placeholder para a lista
                      ],
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "© 2025 EstofariaPro | Versão 1.0.0",
              style: createTextTheme(Theme.of(context).brightness).bodySmall,
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
