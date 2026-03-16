import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/inventario_db.dart';

class ProductFormScreen extends StatefulWidget {
  final Producto? productoAEditar; // Si es null, es un producto nuevo

  const ProductFormScreen({super.key, this.productoAEditar});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final InventarioDB _db = InventarioDB();

  late TextEditingController _codigoController;
  late TextEditingController _descripcionController;
  late TipoAgrupacion _agrupacionSeleccionada;

  @override
  void initState() {
    super.initState();
    // Pre-llenamos los datos si estamos editando
    _codigoController =
        TextEditingController(text: widget.productoAEditar?.codigoBarras ?? '');
    _descripcionController =
        TextEditingController(text: widget.productoAEditar?.descripcion ?? '');
    _agrupacionSeleccionada =
        widget.productoAEditar?.agrupacion ?? TipoAgrupacion.desconocido;
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  // Traductor del enum a texto legible para el dueño
  String _obtenerTextoAgrupacion(TipoAgrupacion tipo) {
    switch (tipo) {
      case TipoAgrupacion.plancha24:
        return 'Plancha / Six (24)';
      case TipoAgrupacion.caja12:
        return 'Cartón (12)';
      case TipoAgrupacion.caja20:
        return 'Cartón de cuartitas (20)';
      case TipoAgrupacion.docena:
        return 'Media Plancha / Six (12)';
      case TipoAgrupacion.cigarros10:
        return 'Paquete de Cigarros (10)';
      case TipoAgrupacion.desconocido:
        return 'Unidades Sueltas (1)';
    }
  }

  Future<void> _guardarProducto() async {
    if (_formKey.currentState!.validate()) {
      // Usamos el producto existente o creamos uno nuevo
      final producto = widget.productoAEditar ?? Producto();

      producto.codigoBarras = _codigoController.text.trim();
      producto.descripcion = _descripcionController.text.trim().toUpperCase();
      producto.agrupacion = _agrupacionSeleccionada;
      // Si es nuevo, la cantidadFisica inicia en 0 por defecto

      await _db.guardarProducto(
          producto); // Isar actualiza si el ID ya existe, o lo crea si no.

      if (mounted) {
        Navigator.pop(context, true); // Regresamos enviando "true" de éxito
      }
    }
  }

  Future<void> _eliminarProducto() async {
    if (widget.productoAEditar != null) {
      await _db.eliminarProducto(widget.productoAEditar!.id);
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.productoAEditar != null;

    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Fondo consistente con Mermas
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar Producto' : 'Nuevo Producto'),
        actions: [
          if (esEdicion) // Solo mostramos el bote de basura si estamos editando
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () async {
                // Confirmación antes de borrar
                final confirmar = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('¿Eliminar producto?'),
                    content: const Text(
                        'Esto lo borrará de la base de datos permanentemente.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancelar')),
                      TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Eliminar',
                              style: TextStyle(color: Colors.red))),
                    ],
                  ),
                );
                if (confirmar == true) await _eliminarProducto();
              },
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _codigoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Código de Barras',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon:
                        Icon(Icons.qr_code, color: Colors.grey.shade600),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descripcionController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: 'Descripción del Producto',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon:
                        Icon(Icons.text_fields, color: Colors.grey.shade600),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TipoAgrupacion>(
                  value: _agrupacionSeleccionada,
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: 'Tipo de Agrupación',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.layers, color: Colors.grey.shade600),
                  ),
                  items: TipoAgrupacion.values.map((tipo) {
                    return DropdownMenuItem(
                      value: tipo,
                      child: Text(_obtenerTextoAgrupacion(tipo)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _agrupacionSeleccionada = val);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton.icon(
            onPressed: _guardarProducto,
            icon: const Icon(Icons.save),
            label:
                const Text('Guardar Producto', style: TextStyle(fontSize: 16)),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
