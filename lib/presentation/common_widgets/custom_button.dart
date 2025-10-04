import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, tertiary, outlined }

class CustomButton extends StatelessWidget {
  final String? label; // ✅ agora opcional
  final String? text; // ✅ compatibilidade legado
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final IconData? icon; // 👈 Ícone opcional
  final bool iconRight; // 👈 Controle de posição do ícone
  final bool isSelected; // 👈 Novo: estado de seleção

  const CustomButton({
    super.key,
    this.label, // ✅ removido "required"
    this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.icon,
    this.iconRight = false,
    this.isSelected = false, // padrão = não selecionado
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Definição de cores com base no estado selecionado
    Color backgroundColor;
    Color foregroundColor;
    BorderSide? border;

    if (isSelected) {
      backgroundColor = colorScheme.primaryContainer; // marrom mais claro
      foregroundColor = colorScheme.onPrimaryContainer;
      border = BorderSide(color: colorScheme.primary, width: 1);
    } else {
      switch (type) {
        case ButtonType.secondary:
          backgroundColor = colorScheme.secondary;
          foregroundColor = colorScheme.onSecondary;
          break;
        case ButtonType.tertiary:
          backgroundColor = colorScheme.tertiary;
          foregroundColor = colorScheme.onTertiary;
          break;
        case ButtonType.outlined:
          backgroundColor = Colors.transparent;
          foregroundColor = colorScheme.primary;
          border = BorderSide(color: colorScheme.primary);
          break;
        default:
          backgroundColor = colorScheme.primary;
          foregroundColor = colorScheme.onPrimary;
      }
    }

    final displayLabel = text ?? label ?? ''; // ✅ seguro, não quebra se ambos null

    final child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null && !iconRight) ...[
                Icon(icon, size: 20, color: foregroundColor),
                const SizedBox(width: 8),
              ],
              Text(
                displayLabel,
                style: textTheme.labelLarge?.copyWith(color: foregroundColor),
              ),
              if (icon != null && iconRight) ...[
                const SizedBox(width: 8),
                Icon(icon, size: 20, color: foregroundColor),
              ],
            ],
          );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: border ?? BorderSide.none,
    );

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: shape, // Usa a forma definida com borda
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        elevation: isSelected ? 0 : 2,
      ),
      child: child,
    );
  }
}
