import 'package:flutter/material.dart';

class BarraCantidadMermas extends StatefulWidget {
  final bool hasProductoSeleccionado;
  final void Function(int cantidad) onAgregar;
  final ValueChanged<bool>? onFocusChange;

  const BarraCantidadMermas({
    super.key,
    required this.hasProductoSeleccionado,
    required this.onAgregar,
    required this.onFocusChange,
  });

  @override
  State<BarraCantidadMermas> createState() => _BarraCantidadMermasState();
}

class _BarraCantidadMermasState extends State<BarraCantidadMermas> {
  final TextEditingController _cantidadController = TextEditingController();

  void _procesarAgregado() {
    if (!widget.hasProductoSeleccionado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Busca un producto primero')),
      );
      return;
    }

    final cantidadText = _cantidadController.text.trim();
    final cantidad = int.tryParse(cantidadText);

    if (cantidad == null || cantidad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cantidad no válida')),
      );
      return;
    }

    widget.onAgregar(cantidad);
    _cantidadController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fila limpia sin paddings externos. El contenedor padre dictará los márgenes.
    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 48, // Altura estandarizada
          child: Focus(
            onFocusChange: (enfocado) {
              widget.onFocusChange?.call(enfocado);
            },
            child: TextField(
              controller: _cantidadController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: 'Cant.',
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 48, // Altura estandarizada
            child: FilledButton.icon(
              onPressed: _procesarAgregado,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Agregar'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
