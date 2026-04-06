// lib/features/inventory/widgets/product_text_field.dart

import 'package:flutter/material.dart';

class ProductTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isNumeric;
  final bool caps;

  const ProductTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isNumeric = false,
    this.caps = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      textCapitalization:
          caps ? TextCapitalization.characters : TextCapitalization.none,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Requerido';
        // Auditoría: Validación estricta para campos que deben ser numéricos
        if (isNumeric && int.tryParse(v.trim()) == null) {
          return 'Debe ser un número válido';
        }
        return null;
      },
    );
  }
}
