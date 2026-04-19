import 'package:flutter/material.dart';
import '../models/presentacion_model.dart';
import '../controllers/inventory_controller.dart';

// 1. Ahora es StatefulWidget para poder mantener en memoria las posiciones (Keys)
class InventoryFilters extends StatefulWidget {
  final InventoryController controller;
  final List<Presentacion> presentacionesActivas;

  const InventoryFilters({
    super.key,
    required this.controller,
    required this.presentacionesActivas,
  });

  @override
  State<InventoryFilters> createState() => _InventoryFiltersState();
}

class _InventoryFiltersState extends State<InventoryFilters> {
  // 2. Diccionario para guardar las llaves únicas de cada Chip
  final Map<int, GlobalKey> _keys = {};
  final GlobalKey _todasKey = GlobalKey();

  // Variable para recordar qué estaba seleccionado y evitar animaciones innecesarias
  int? _lastSelectedId = -999;

  // Función para obtener o crear una llave única para cada presentación
  GlobalKey _getKeyFor(int? id) {
    if (id == null) return _todasKey;
    if (!_keys.containsKey(id)) {
      _keys[id] = GlobalKey();
    }
    return _keys[id]!;
  }

  // 3. LA MAGIA DEL SCROLL AUTOMÁTICO
  void _animarHaciaSeleccion(int? idSeleccionado) {
    final key = _getKeyFor(idSeleccionado);

    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        alignment:
            0.5, // 0.5 significa que centrará el Chip perfectamente en la pantalla
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.presentacionesActivas.length <= 1) {
      return const SizedBox.shrink();
    }

    // 4. Verificamos si cambió la selección antes de mandar la animación
    final idActual = widget.controller.presentacionActual?.id;
    if (_lastSelectedId != idActual) {
      _lastSelectedId = idActual;

      // Esperamos a que Flutter termine de dibujar el frame para tener las posiciones correctas
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _animarHaciaSeleccion(idActual);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              ChoiceChip(
                key: _getKeyFor(null), // <- Inyectamos su GPS
                label: const Text('Todas'),
                selected: widget.controller.presentacionActual == null,
                onSelected: (_) => widget.controller.cambiarPresentacion(null),
              ),
              ...widget.presentacionesActivas.map((pres) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ChoiceChip(
                    key: _getKeyFor(pres.id), // <- Inyectamos su GPS
                    label: Text(pres.nombre),
                    selected:
                        widget.controller.presentacionActual?.id == pres.id,
                    selectedColor:
                        Theme.of(context).primaryColor.withOpacity(0.2),
                    onSelected: (_) =>
                        widget.controller.cambiarPresentacion(pres),
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
