import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class WorkshopAppBar extends StatefulWidget implements PreferredSizeWidget {
  const WorkshopAppBar({super.key});

  @override
  State<WorkshopAppBar> createState() => _WorkshopAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _WorkshopAppBarState extends State<WorkshopAppBar> {
  String empresa = "";
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadEmpresa();
  }

  Future<void> _loadEmpresa() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    if (doc.exists) {
      setState(() {
        empresa = doc.data()?['empresa'] ?? "";
      });
    }
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'perfil':
        context.push('/perfil');
        break;
      case 'configuracoes':
        context.push('/configuracoes');
        break;
      case 'sair':
        FirebaseAuth.instance.signOut().then((_) {
          if (mounted) context.go('/login');
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const terracotaColor = Color(0xFF9C8158);

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 2,
      leadingWidth: 120,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).canPop()
                  ? Navigator.of(context).pop()
                  : context.go('/login'),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.arrow_back, size: 28),
              ),
            ),
            const SizedBox(width: 4),
            Row(
              children: const [
                Icon(Icons.chair, size: 24, color: terracotaColor),
                SizedBox(width: 4),
                Text(
                  'Estofaria Pro',
                  style: TextStyle(
                    color: terracotaColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      centerTitle: true,
      title: Text(
        empresa.isEmpty ? "Estofaria Pro" : empresa,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: _onMenuSelected,
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'perfil',
              child: Text('Perfil'),
            ),
            PopupMenuItem(
              value: 'configuracoes',
              child: Text('Configurações'),
            ),
            PopupMenuItem(
              value: 'sair',
              child: Text('Sair'),
            ),
          ],
          icon: CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
