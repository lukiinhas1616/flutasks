import 'package:flutter/material.dart';

class GlobalButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isLoading;
  final IconData? icon;

  const GlobalButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.isOutlined = false,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isOutlined ? Colors.white : theme.colorScheme.onPrimary;
    final textStyle = theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w400,
      color: color,
    );

    final child = isLoading
        ? CircularProgressIndicator(color: color)
        : Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: color, size: 24),
              Text(label, style: textStyle),
            ],
          );

    // OutlinedButton
    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          side: BorderSide(
            color: theme.colorScheme.primary,
            width: 2.0,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: child,
      );
    }

    // Default Button
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: const Color(0xffe6f3ff),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: child,
    );
  }
}
