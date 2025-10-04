// lib/presentation/common_widgets/shared_app_bar.dart
// AppBar reutilizável (Estofaria PRO) — segue documentação do Plano Mestre.

import 'package:flutter/material.dart';

class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Roadmap: Identidade Visual
  final String estofariaNome;
  final String? estofariaLogoUrl;

  // Roadmap: Funcionalidades de Perfil
  final String? usuarioNome;
  final String? usuarioFotoUrl;
  final bool isAdmin;

  // Roadmap: Callbacks e Placeholders
  final VoidCallback? onLogout;
  final VoidCallback? onProfileTap;
  final VoidCallback? onChangePassword;
  final VoidCallback? onManageUsers;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onSearchTap;

  const SharedAppBar({
    Key? key,
    required this.estofariaNome,
    this.estofariaLogoUrl,
    this.usuarioNome,
    this.usuarioFotoUrl,
    this.isAdmin = false,
    this.onLogout,
    this.onProfileTap,
    this.onChangePassword,
    this.onManageUsers,
    this.onNotificationsTap,
    this.onSearchTap,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AppBar(
      backgroundColor: colorScheme.primary,
      automaticallyImplyLeading: false,
      titleSpacing: 24,
      title: Row(
        children: [
          // Ajuste para correção de compilação: Restaurado o bloco do logo.
          if (estofariaLogoUrl != null && estofariaLogoUrl!.isNotEmpty)
            Image.network(
              estofariaLogoUrl!,
              height: kToolbarHeight * 0.6, // Ajuste: Altura do logo proporcional.
              errorBuilder: (_, __, ___) => Icon(Icons.weekend, color: colorScheme.onPrimary),
            )
          else
            Icon(Icons.weekend, color: colorScheme.onPrimary),
          const SizedBox(width: 12),
          
          // Ajuste: Centraliza o nome da estofaria usando Expanded e Center.
          Expanded(
            child: Center(
              child: Text(
                // Ajuste: Fallback para o nome da estofaria.
                estofariaNome.isNotEmpty ? estofariaNome : 'Estofaria',
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // Ajuste para correção de compilação: Restaurados os IconButtons de ação.
          if (onSearchTap != null)
            IconButton(
              icon: Icon(Icons.search, color: colorScheme.onPrimary),
              onPressed: onSearchTap,
              tooltip: 'Buscar',
            ),
          if (onNotificationsTap != null)
            IconButton(
              icon: Icon(Icons.notifications_none_outlined, color: colorScheme.onPrimary),
              onPressed: onNotificationsTap,
              tooltip: 'Notificações',
            ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            tooltip: 'Menu do usuário',
            offset: const Offset(0, 40),
            color: colorScheme.surface,
            child: Tooltip( // Ajuste: Adicionado Tooltip para acessibilidade.
              message: 'Abrir menu do usuário',
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: colorScheme.onPrimary.withOpacity(0.2),
                  backgroundImage: (usuarioFotoUrl != null && usuarioFotoUrl!.isNotEmpty)
                      ? NetworkImage(usuarioFotoUrl!)
                      : null,
                  child: (usuarioFotoUrl == null || usuarioFotoUrl!.isEmpty)
                      ? Icon(Icons.person, color: colorScheme.onPrimary)
                      : null,
                ),
              ),
            ),
            onSelected: (value) {
              // Ajuste para correção de compilação: Restaurado o bloco switch.
              switch (value) {
                case 'perfil':
                  onProfileTap?.call();
                  break;
                case 'trocar_senha':
                  onChangePassword?.call();
                  break;
                case 'gerenciar_usuarios':
                  onManageUsers?.call();
                  break;
                case 'logout':
                  onLogout?.call();
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                if (usuarioNome != null && usuarioNome!.isNotEmpty)
                  PopupMenuItem(
                    enabled: false,
                    child: Text(
                      usuarioNome!,
                      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                if (usuarioNome != null && usuarioNome!.isNotEmpty)
                  const PopupMenuDivider(),

                // Roadmap: Opções do menu
                PopupMenuItem(
                  value: 'perfil',
                  child: Text('Meus Dados', style: textTheme.bodyMedium),
                ),
                PopupMenuItem(
                  value: 'trocar_senha',
                  child: Text('Trocar Senha', style: textTheme.bodyMedium),
                ),
                if (isAdmin)
                  PopupMenuItem(
                    value: 'gerenciar_usuarios',
                    child: Text('Gerenciar Usuários', style: textTheme.bodyMedium),
                  ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: colorScheme.error),
                      const SizedBox(width: 8),
                      Text('Sair', style: textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
