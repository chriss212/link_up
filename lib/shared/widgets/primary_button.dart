import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool filled;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (filled) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEB7A36), // Bright orange
          foregroundColor: Colors.white, // Text color
          shape: const StadiumBorder(),
          minimumSize: const Size.fromHeight(48),
        ),
        onPressed: onPressed,
        child: Text(label),
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: scheme.primary),
        minimumSize: const Size.fromHeight(48),
        shape: const StadiumBorder(),
      ),
      child: Text(label, style: TextStyle(color: scheme.primary)),
    );
  }
}
