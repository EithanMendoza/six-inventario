// lib/features/inventory/screens/product_form_screen.dart

import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/inventario_db.dart';
import '../controllers/product_form_controller.dart';
import '../widgets/product_text_field.dart';
import '../widgets/product_autocomplete_field.dart';

class ProductFormScreen extends StatefulWidget {
  final Producto? productoAEditar;
  const ProductFormScreen({super.key, this.productoAEditar});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  late final ProductFormController _controller;

  @override
  void initState() {
    super.initState();
    // Inyección de Dependencias
    _controller = ProductFormController(
        db: InventarioDB(), productoAEditar: widget.productoAEditar);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _ejecutarGuardado() async {
    try {
      final guardadoOk = await _controller.guardarProducto();
      if (guardadoOk && mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
          title: Text(widget.productoAEditar == null
              ? 'Nuevo Producto'
              : 'Editar Producto')),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.isLoading)
            return const Center(child: CircularProgressIndicator());

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _controller.formKey,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    ProductTextField(
                        controller: _controller.codigoController,
                        label: 'Código de Barras',
                        icon: Icons.qr_code,
                        isNumeric: true),
                    const SizedBox(height: 16),
                    ProductTextField(
                        controller: _controller.descripcionController,
                        label: 'Descripción',
                        icon: Icons.text_fields,
                        caps: true),
                    const SizedBox(height: 16),
                    ProductAutocompleteField(
                      label: 'Familia (Categoría)',
                      controller: _controller.catSearchController,
                      icon: Icons.folder_outlined,
                      options: _controller.categorias,
                      getNombre: (c) => c.nombre,
                      onSelected: _controller.setCategoria,
                      onCreate: _controller.crearCategoriaAlVuelo,
                    ),
                    const SizedBox(height: 16),
                    ProductAutocompleteField(
                      label: 'Empaque (Presentación)',
                      controller: _controller.presSearchController,
                      icon: Icons.inventory_2_outlined,
                      options: _controller.presentaciones,
                      getNombre: (p) => p.nombre,
                      onSelected: _controller.setPresentacion,
                      onCreate: _controller.crearPresentacionAlVuelo,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton.icon(
              onPressed: _ejecutarGuardado,
              icon: const Icon(Icons.save),
              label: const Text('Guardar Producto')),
        ),
      ),
    );
  }
}
