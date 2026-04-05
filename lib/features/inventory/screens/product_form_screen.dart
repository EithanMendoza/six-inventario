// lib/features/inventory/screens/product_form_screen.dart

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/presentacion_model.dart';
import '../models/inventario_db.dart';

class ProductFormScreen extends StatefulWidget {
  final Producto? productoAEditar;

  const ProductFormScreen({super.key, this.productoAEditar});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final InventarioDB _db = InventarioDB();

  late TextEditingController _codigoController;
  late TextEditingController _descripcionController;

  // Controladores para los campos de autocompletado
  final TextEditingController _catSearchController = TextEditingController();
  final TextEditingController _presSearchController = TextEditingController();

  List<Categoria> _categorias = [];
  List<Presentacion> _presentaciones = [];

  Categoria? _categoriaSeleccionada;
  Presentacion? _presentacionSeleccionada;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _codigoController =
        TextEditingController(text: widget.productoAEditar?.codigoBarras ?? '');
    _descripcionController =
        TextEditingController(text: widget.productoAEditar?.descripcion ?? '');
    _cargarListas();
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _descripcionController.dispose();
    _catSearchController.dispose();
    _presSearchController.dispose();
    super.dispose();
  }

  Future<void> _cargarListas() async {
    final isar = await _db.db;
    final cats = await isar.collection<Categoria>().where().findAll();
    final pres = await isar.collection<Presentacion>().where().findAll();

    setState(() {
      _categorias = cats;
      _presentaciones = pres;
      _isLoading = false;

      if (widget.productoAEditar != null) {
        widget.productoAEditar!.categoria.loadSync();
        widget.productoAEditar!.presentacion.loadSync();
        _categoriaSeleccionada = widget.productoAEditar!.categoria.value;
        _presentacionSeleccionada = widget.productoAEditar!.presentacion.value;

        _catSearchController.text = _categoriaSeleccionada?.nombre ?? '';
        _presSearchController.text = _presentacionSeleccionada?.nombre ?? '';
      }
    });
  }

  // MÉTODO CRÍTICO: Creación al vuelo de Familias
  Future<void> _crearCategoriaAlVuelo(String nombre) async {
    final isar = await _db.db;
    final nueva = Categoria.crear(nombre.trim());
    await isar.writeTxn(() => isar.collection<Categoria>().put(nueva));
    await _cargarListas(); // Refresca memoria
    setState(() {
      _categoriaSeleccionada = nueva;
      _catSearchController.text = nueva.nombre;
    });
  }

  // MÉTODO CRÍTICO: Creación al vuelo de Empaques
  Future<void> _crearPresentacionAlVuelo(String nombre) async {
    final isar = await _db.db;
    final nueva = Presentacion.crear(nombre.trim());
    await isar.writeTxn(() => isar.collection<Presentacion>().put(nueva));
    await _cargarListas();
    setState(() {
      _presentacionSeleccionada = nueva;
      _presSearchController.text = nueva.nombre;
    });
  }

  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) return;

    // ==========================================================
    // MOTOR DE CONCILIACIÓN: FAMILIA (Categoría)
    // ==========================================================
    final catText = _catSearchController.text.trim();
    if (catText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('El campo de Familia no puede estar vacío.')));
      return;
    }

    // Si la variable es nula, o si el usuario editó el texto después de haber seleccionado algo
    if (_categoriaSeleccionada == null ||
        _categoriaSeleccionada!.nombre.toLowerCase() != catText.toLowerCase()) {
      try {
        // Intentamos buscar si ya existe en la memoria (por si lo escribió bien pero no lo tocó en la lista)
        _categoriaSeleccionada = _categorias
            .firstWhere((c) => c.nombre.toLowerCase() == catText.toLowerCase());
      } catch (e) {
        // Si no existe, lo creamos forzosamente en este instante
        await _crearCategoriaAlVuelo(catText);
      }
    }

    // ==========================================================
    // MOTOR DE CONCILIACIÓN: EMPAQUE (Presentación)
    // ==========================================================
    final presText = _presSearchController.text.trim();
    if (presText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('El campo de Empaque no puede estar vacío.')));
      return;
    }

    if (_presentacionSeleccionada == null ||
        _presentacionSeleccionada!.nombre.toLowerCase() !=
            presText.toLowerCase()) {
      try {
        _presentacionSeleccionada = _presentaciones.firstWhere(
            (p) => p.nombre.toLowerCase() == presText.toLowerCase());
      } catch (e) {
        await _crearPresentacionAlVuelo(presText);
      }
    }

    // ==========================================================
    // GUARDADO FINAL DEL PRODUCTO
    // ==========================================================
    final producto = widget.productoAEditar ?? Producto();
    producto.codigoBarras = _codigoController.text.trim();
    producto.descripcion = _descripcionController.text.trim().toUpperCase();

    // Inyectamos las variables que el motor de conciliación acaba de asegurar
    producto.categoria.value = _categoriaSeleccionada;
    producto.presentacion.value = _presentacionSeleccionada;

    try {
      await _db.guardarProducto(producto);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Error: Verifica que el código de barras no esté duplicado.'),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                          offset: const Offset(0, 4))
                    ],
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _codigoController,
                        label: 'Código de Barras',
                        icon: Icons.qr_code,
                        isNumeric: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _descripcionController,
                        label: 'Descripción',
                        icon: Icons.text_fields,
                        caps: true,
                      ),
                      const SizedBox(height: 16),

                      // AUTOCOMPLETE 1: FAMILIA
                      _buildAutocomplete<Categoria>(
                        label: 'Familia (Categoría)',
                        controller: _catSearchController,
                        icon: Icons.folder_outlined,
                        options: _categorias,
                        onSelected: (cat) =>
                            setState(() => _categoriaSeleccionada = cat),
                        onCreate: (val) => _crearCategoriaAlVuelo(val),
                      ),

                      const SizedBox(height: 16),

                      // AUTOCOMPLETE 2: EMPAQUE
                      _buildAutocomplete<Presentacion>(
                        label: 'Empaque (Presentación)',
                        controller: _presSearchController,
                        icon: Icons.inventory_2_outlined,
                        options: _presentaciones,
                        onSelected: (pres) =>
                            setState(() => _presentacionSeleccionada = pres),
                        onCreate: (val) => _crearPresentacionAlVuelo(val),
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
            label: const Text('Guardar Producto'),
            style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
          ),
        ),
      ),
    );
  }

  // --- WIDGETS MODULARIZADOS ---

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      required IconData icon,
      bool isNumeric = false,
      bool caps = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      textCapitalization:
          caps ? TextCapitalization.characters : TextCapitalization.none,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none),
      ),
      validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
    );
  }

  Widget _buildAutocomplete<T extends Object>({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required List<dynamic> options,
    required Function(T) onSelected,
    required Function(String) onCreate,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) => RawAutocomplete<T>(
        textEditingController: controller,
        focusNode: FocusNode(),
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) return const Iterable.empty();

          final filtered = options.where((dynamic option) {
            return option.nombre
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          }).toList();

          // Si no hay coincidencias exactas, permitimos la opción de crear
          return filtered.cast<T>();
        },
        displayStringForOption: (dynamic option) => option.nombre,
        fieldViewBuilder:
            (context, fieldController, focusNode, onFieldSubmitted) {
          return TextFormField(
            controller: fieldController,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.grey.shade100,
              prefixIcon: Icon(icon, color: Colors.grey.shade600),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => setState(() {
                            controller.clear();
                          }))
                  : null,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
            ),
          );
        },
        optionsViewBuilder: (context, onSelectedInternal, optionsFound) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: constraints.maxWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Opción dinámica de creación si no hay match exacto
                    if (!optionsFound.any((dynamic o) =>
                        o.nombre.toLowerCase() ==
                        controller.text.toLowerCase()))
                      ListTile(
                        leading:
                            const Icon(Icons.add_circle, color: Colors.blue),
                        title: Text('Crear "${controller.text}"'),
                        onTap: () {
                          onCreate(controller.text);
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ...optionsFound.map((dynamic option) => ListTile(
                          title: Text(option.nombre),
                          onTap: () {
                            onSelectedInternal(option);
                            onSelected(option as T);
                          },
                        )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
