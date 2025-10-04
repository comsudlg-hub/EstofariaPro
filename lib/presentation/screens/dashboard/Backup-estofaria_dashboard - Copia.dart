import 'package:flutter/material.dart';
import '../../common_widgets/workshop_app_bar.dart';

class EstofariaDashboard extends StatefulWidget {
  const EstofariaDashboard({super.key});

  @override
  State<EstofariaDashboard> createState() => _EstofariaDashboardState();
}

class _EstofariaDashboardState extends State<EstofariaDashboard> {
  final List<String> mainMenus = ['Vendas', 'Logística', 'Produção', 'Gerência'];

  final Map<String, List<String>> subMenus = {
    'Vendas': [
      'Pedido de Orçamento',
      'Enviar Orçamento',
      'Aprovar Orçamento',
      'Ordem de Serviço'
    ],
    'Logística': [
      'Consultar Agenda',
      'Encerrar Entrega',
      'Check-In Produção',
      'Acompanhar Custos'
    ],
    'Produção': [
      'Pedido de Produção',
      'Aviso Produção',
      'Pedido de Compra',
      'Fechar Pedido'
    ],
    'Gerência': [
      'Financeiro',
      'Compras',
      'Relatórios',
      'Cadastro',
    ],
  };

  String selectedMainMenu = 'Vendas';
  String? selectedSubMenu;

  void _onMainMenuTap(String menu) {
    setState(() {
      selectedMainMenu = menu;
      selectedSubMenu = null;
    });
  }

  void _onSubMenuTap(String submenu) {
    setState(() {
      selectedSubMenu = submenu;
    });
  }

  IconData _getMainMenuIcon(String menu) {
    switch (menu) {
      case 'Vendas':
        return Icons.shopping_cart;
      case 'Logística':
        return Icons.local_shipping;
      case 'Produção':
        return Icons.precision_manufacturing;
      case 'Gerência':
        return Icons.business_center;
      default:
        return Icons.circle;
    }
  }

  IconData _getSubMenuIcon(String submenu) {
    switch (submenu) {
      case 'Pedido de Orçamento':
        return Icons.request_quote;
      case 'Enviar Orçamento':
        return Icons.send;
      case 'Aprovar Orçamento':
        return Icons.check_circle;
      case 'Ordem de Serviço':
        return Icons.assignment;
      case 'Consultar Agenda':
        return Icons.calendar_month;
      case 'Encerrar Entrega':
        return Icons.done_all;
      case 'Check-In Produção':
        return Icons.qr_code_scanner;
      case 'Acompanhar Custos':
        return Icons.attach_money;
      case 'Pedido de Produção':
        return Icons.playlist_add;
      case 'Aviso Produção':
        return Icons.notifications_active;
      case 'Pedido de Compra':
        return Icons.shopping_bag;
      case 'Fechar Pedido':
        return Icons.lock;
      case 'Financeiro':
        return Icons.account_balance;
      case 'Compras':
        return Icons.shopping_cart_checkout;
      case 'Relatórios':
        return Icons.bar_chart;
      case 'Cadastro':
        return Icons.app_registration;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const WorkshopAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== MENU PRINCIPAL =====
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: mainMenus.map((menu) {
                    final isSelected = menu == selectedMainMenu;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                        onTap: () => _onMainMenuTap(menu),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surface,
                            border: Border.all(
                              color: theme.colorScheme.outline,
                              width: 1.5,
                            ),
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 4,
                                  offset: const Offset(2, 2),
                                ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getMainMenuIcon(menu),
                                color: isSelected
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                menu,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ===== SUBMENU =====
            if (subMenus.containsKey(selectedMainMenu))
              Center(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: subMenus[selectedMainMenu]!.map((submenu) {
                    final isSelected = submenu == selectedSubMenu;
                    return ChoiceChip(
                      avatar: Icon(
                        _getSubMenuIcon(submenu),
                        size: 18,
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.primary,
                      ),
                      label: Text(
                        submenu,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.primary,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) => _onSubMenuTap(submenu),
                      selectedColor: theme.colorScheme.primary,
                      backgroundColor: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: theme.colorScheme.outline,
                          width: 1.2,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 24),

            // ===== CONTEÚDO PRINCIPAL =====
            Expanded(
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    final fade = FadeTransition(opacity: animation, child: child);
                    final slide = SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: fade,
                    );
                    return slide;
                  },
                  child: selectedSubMenu == null
                      ? Text(
                          "Bem-vindo ao Painel da Estofaria!",
                          key: const ValueKey("welcome"),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : Card(
                          key: ValueKey(selectedSubMenu),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: theme.colorScheme.outline.withOpacity(0.5),
                            ),
                          ),
                          color: theme.colorScheme.surface,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getSubMenuIcon(selectedSubMenu!),
                                  size: 40,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  selectedSubMenu!,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Aqui você poderá gerenciar ${selectedSubMenu!.toLowerCase()}.",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
