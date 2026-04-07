// lib/features/inventory/widgets/product_card.dart
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../../mermas/controllers/mermas_controller.dart';
import 'count_bottom_sheet.dart';

class ProductCard extends StatelessWidget {
  final Producto producto;
  final bool modoAuditoria;
  final Function(TipoConteo) onTap;
  final VoidCallback onLongPress;

  const ProductCard({
    super.key,
    required this.producto,
    this.modoAuditoria = false,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCounted = producto.cantidadFisica > 0;
    final int diferencia = producto.cantidadFisica - producto.conteoSistema;

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
      child: InkWell(
        // RESTAURADO: Tocar en CUALQUIER PARTE de la tarjeta abre el conteo Físico
        onTap: () => onTap(TipoConteo.fisico),
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          producto.descripcion,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text('Código: ${producto.codigoBarras}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                        /*if (producto.presentacion.value != null)
                          Text(
                            'Empaque: ${producto.presentacion.value!.nombre}',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 12),
                          ),*/
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // El Físico ya no es un botón separado, hereda el toque de toda la tarjeta
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Column(
                          children: [
                            const Text('Físico',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                            Text(
                              '${producto.cantidadFisica}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: isCounted
                                    ? Colors.green.shade700
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // El Sistema mantiene su propio botón encapsulado
                      if (modoAuditoria) ...[
                        const SizedBox(width: 8),
                        Container(
                            width: 1, height: 40, color: Colors.grey.shade300),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () => onTap(TipoConteo
                              .sistema), // Este toque anula el general
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Column(
                              children: [
                                const Text('Sistema',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                                Text(
                                  '${producto.conteoSistema}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: producto.conteoSistema > 0
                                        ? Colors.blue.shade700
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    ],
                  )
                ],
              ),
            ),
            if (modoAuditoria) _buildAuditoriaPanel(context, diferencia),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditoriaPanel(BuildContext context, int diferencia) {
    // Si no hay diferencia, no mostramos el panel. Menos ruido visual.
    if (diferencia == 0) return const SizedBox.shrink();

    Color bgColor;
    Color textColor;
    String texto;
    Widget? accion;

    if (diferencia > 0) {
      bgColor = Colors.orange.shade100;
      textColor = Colors.orange.shade900;
      texto = '+$diferencia Sobrante';
    } else {
      bgColor = Colors.red.shade100;
      textColor = Colors.red.shade900;
      texto = '$diferencia Faltante';
      accion = IconButton(
        icon: const Icon(Icons.assignment_returned_outlined, color: Colors.red),
        tooltip: 'Enviar a Mermas',
        onPressed: () {
          MermasController().agregarMerma(producto, diferencia.abs());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${diferencia.abs()}x ${producto.descripcion} añadido a mermas'),
              backgroundColor: Colors.red.shade700,
              duration: const Duration(seconds: 2),
            ),
          );
        },
      );
    }

    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 8, top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(texto,
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
            if (accion != null) accion else const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
