import 'package:flutter/material.dart';
import '../../inventory/models/product_model.dart';

class BuscadorMermas extends StatelessWidget {
  final List<Producto> catalogo;
  final ValueChanged<Producto> onSelected;

  // Necesitamos esto para que la pantalla principal pueda limpiar la caja de texto
  // después de agregar un producto a la lista.
  final void Function(TextEditingController) onControllerCreated;

  const BuscadorMermas({
    super.key,
    required this.catalogo,
    required this.onSelected,
    required this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Autocomplete<Producto>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty)
            return const Iterable<Producto>.empty();
          final busqueda = textEditingValue.text.toLowerCase();
          return catalogo.where((p) =>
              p.descripcion.toLowerCase().contains(busqueda) ||
              p.codigoBarras.contains(busqueda));
        },
        displayStringForOption: (Producto p) => p.descripcion,
        onSelected: onSelected,
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          onControllerCreated(controller);
          return TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: 'Buscar merma...',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              prefixIcon:
                  Icon(Icons.search, color: Colors.grey.shade500, size: 20),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          );
        },
        // --- AQUÍ ESTÁ LA MAGIA PARA CAMBIAR EL COLOR Y DISEÑO DEL MENÚ ---
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: Colors.white,
              surfaceTintColor: Colors.transparent, // Evita el tinte rojo/rosa
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8),
              clipBehavior: Clip.antiAlias,
              child: Container(
                // Limitamos el ancho y el ALTO máximo
                width: MediaQuery.of(context).size.width - 32,
                constraints: const BoxConstraints(
                    maxHeight: 280), // Altura para ~4.5 items
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true, // Importante: Se adapta al contenido
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Producto option = options.elementAt(index);
                    return ListTile(
                      dense: true, // Hace el item más compacto
                      title: Text(
                        option.descripcion,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      subtitle: Text('Cód: ${option.codigoBarras}',
                          style: const TextStyle(fontSize: 11)),
                      onTap: () => onSelected(option),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
