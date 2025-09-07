import 'package:flutter/material.dart';

class GreeniqPreviewButton extends StatelessWidget {
  const GreeniqPreviewButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.visibility_outlined, size: 18),
      label: const Text('Preview'),
      onPressed: onTap,
    );
  }
}

