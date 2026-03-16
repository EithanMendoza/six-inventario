import 'package:flutter/material.dart';
import '../models/item_merma.dart';

class ListaMermasVisual extends StatelessWidget {
  final List<ItemMerma> listaMermas;
  final void Function(int index) onEliminar;

  const ListaMermasVisual({
    super.key,
    required this.listaMermas,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    if (listaMermas.isEmpty) {
      return Center(
        child: Text(
          'No hay mermas agregadas aún.\nBusca un producto arriba.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade500),
        ),
      );
    }

    return ListView.builder(
      // Se agrega padding inferior para que el último elemento no quede oculto por botones flotantes o barras
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: listaMermas.length,
      itemBuilder: (context, index) {
        final item = listaMermas[index];
        return Card(
          // Propiedades clonadas de inventory_hub
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide.none,
          ),
          child: ListTile(
            // Padding interno clonado de inventory_hub
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),

            leading: CircleAvatar(
              backgroundColor: Colors.red.shade50,
              child: Text(
                '${item.cantidad}',
                style: TextStyle(
                    color: Colors.red.shade900, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              item.producto.descripcion,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Text('Código: ${item.producto.codigoBarras}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => onEliminar(index),
            ),
          ),
        );
      },
    );
  }
}
