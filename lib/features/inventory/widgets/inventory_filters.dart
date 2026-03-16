import 'package:flutter/material.dart';
import '../models/filtros_model.dart';
import '../controllers/inventory_controller.dart';

class InventoryFilters extends StatelessWidget {
  final InventoryController controller;

  const InventoryFilters({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila 1: Categorías (Cervezas / Cigarros)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Icon(Icons.category, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Todo el catálogo'),
                selected: controller.categoriaActual == FiltroCategoria.todas,
                onSelected: (_) =>
                    controller.cambiarCategoria(FiltroCategoria.todas),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('🍺 Cervezas'),
                selected:
                    controller.categoriaActual == FiltroCategoria.cervezas,
                selectedColor: Colors.amber.shade200,
                onSelected: (_) =>
                    controller.cambiarCategoria(FiltroCategoria.cervezas),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('🚬 Cigarros'),
                selected:
                    controller.categoriaActual == FiltroCategoria.cigarros,
                selectedColor: Colors.blueGrey.shade200,
                onSelected: (_) =>
                    controller.cambiarCategoria(FiltroCategoria.cigarros),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Fila 2: Estados (Completados / Faltantes)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Todo'),
                selected: controller.filtroActual == FiltroEstado.todos,
                onSelected: (_) => controller.cambiarFiltro(FiltroEstado.todos),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Completados'),
                selected: controller.filtroActual == FiltroEstado.completados,
                selectedColor: Colors.green.shade100,
                onSelected: (_) =>
                    controller.cambiarFiltro(FiltroEstado.completados),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Faltantes'),
                selected: controller.filtroActual == FiltroEstado.faltantes,
                selectedColor: Colors.red.shade100,
                onSelected: (_) =>
                    controller.cambiarFiltro(FiltroEstado.faltantes),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
