// lib/features/mermas/widgets/lista_mermas.dart
import 'package:flutter/material.dart';
import '../models/item_merma.dart';

class ListaMermasVisual extends StatelessWidget {
  final List<ItemMerma> listaMermas;
  final void Function(int index) onEliminar;
  final void Function(int index, int cantidadActual)
      onEditar; // <-- Nuevo callback

  const ListaMermasVisual({
    super.key,
    required this.listaMermas,
    required this.onEliminar,
    required this.onEditar,
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
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: listaMermas.length,
      itemBuilder: (context, index) {
        final item = listaMermas[index];

        return Dismissible(
          // Clave única basada en el ID para evitar bugs gráficos al borrar
          key: ValueKey(item.producto.id),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child:
                const Icon(Icons.delete_sweep, color: Colors.white, size: 30),
          ),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: Colors.white,
                title: const Text('Eliminar producto'),
                content:
                    Text('¿Quitar ${item.producto.descripcion} del reporte?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Eliminar',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            onEliminar(index);
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide.none,
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              onTap: () =>
                  onEditar(index, item.cantidad), // <-- Dispara la edición
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
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              subtitle: Text('Código: ${item.producto.codigoBarras}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit,
                    color: Colors
                        .grey), // Cambiado visualmente para incitar a editar
                onPressed: () => onEditar(index, item.cantidad),
              ),
            ),
          ),
        );
      },
    );
  }
}
