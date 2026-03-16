import 'package:flutter/material.dart';
import '../controllers/inventory_controller.dart';

class InventorySearchBar extends StatelessWidget {
  final InventoryController controller;

  const InventorySearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SearchBar(
        hintText: 'Buscar cerveza o cigarro...',
        leading: const Icon(Icons.search),
        elevation: WidgetStateProperty.all(1.0),
        // Conectamos directamente la función del controlador
        onChanged: controller.buscar,
      ),
    );
  }
}
