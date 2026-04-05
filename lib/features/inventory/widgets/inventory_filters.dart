import 'package:flutter/material.dart';
import '../models/presentacion_model.dart';
import '../controllers/inventory_controller.dart';

class InventoryFilters extends StatelessWidget {
  final InventoryController controller;
  // Añadimos esta lista para que la pantalla principal le diga qué empaques mostrar
  // dependiendo de la categoría (Tab) en la que estemos.
  final List<Presentacion> presentacionesActivas;

  const InventoryFilters({
    super.key,
    required this.controller,
    required this.presentacionesActivas,
  });

  @override
  Widget build(BuildContext context) {
    // Si la lista está vacía, no dibujamos nada para no robar espacio en la pantalla
    if (presentacionesActivas.length <= 1) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila 1: Presentaciones (Empaques) Dinámicos
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('Todas'),
                selected: controller.presentacionActual == null,
                onSelected: (_) => controller.cambiarPresentacion(null),
              ),
              // Iteramos sobre las presentaciones filtradas
              ...presentacionesActivas.map((pres) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ChoiceChip(
                    label: Text(pres.nombre),
                    selected: controller.presentacionActual?.id == pres.id,
                    selectedColor:
                        Theme.of(context).primaryColor.withOpacity(0.2),
                    onSelected: (_) => controller.cambiarPresentacion(pres),
                  ),
                );
              })
            ],
          ),
        ),
      ],
    );
  }
}
