import 'package:flutter/material.dart'; // lib/presentation/screens/workshop/sales/pedido_orcamento_screen.dart
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../state/auth_provider.dart';

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

    // Correção: Utiliza o AuthProvider para obter o nome da estofaria dinamicamente.
    final authProvider = context.watch<AuthProvider?>();
    final currentUser = authProvider?.currentUser;
    final estofariaNome = (currentUser?.tipo.startsWith('pessoaJuridica') ?? false)
        ? (currentUser?.empresa ?? "Painel")
        : (currentUser?.nome ?? "Painel da Estofaria");

    return Scaffold(
      // Ajuste solicitado: Chamada ao SharedAppBar completada para consistência.
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
      // Ajuste UX/UI: Removido o Card e Padding externos.
      // A tela agora apenas hospeda o PedidoOrcamentoForm, que já é um Card
      // e gerencia seu próprio layout interno, eliminando o "card dentro de um card".
      body: PedidoOrcamentoForm(
        docId: widget.docId,
        pedidoIdCompleto: widget.pedidoIdCompleto,
        fromPanel: widget.fromPanel,
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
