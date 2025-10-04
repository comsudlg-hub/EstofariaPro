import 'package:flutter/material.dart'; // lib/presentation/common_widgets/empty_state.dart
// Tela de vazio (quando não há dados) — agora suporta botão/ação opcional.

class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final Widget? action; // 🔹 botão ou qualquer widget opcional

  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.inbox,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[
            const SizedBox(height: 16),
            action!,
          ],
        ],
      ),
    );
  }
}
