// lib/features/inventory/widgets/product_card.dart
import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ProductCard({
    super.key,
    required this.producto,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCounted = producto.cantidadFisica > 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      elevation: isCounted ? 0 : 2,
      color: isCounted ? Colors.green.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isCounted
            ? BorderSide(color: Colors.green.shade200)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        title: Text(
          producto.descripcion,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Código: ${producto.codigoBarras}'),
            if (producto.presentacion.value != null)
              Text(
                'Empaque: ${producto.presentacion.value!.nombre}',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 12),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('Cant.',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            Text(
              isCounted ? '${producto.cantidadFisica}' : '0',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: isCounted ? Colors.green.shade700 : Colors.black,
              ),
            ),
          ],
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
