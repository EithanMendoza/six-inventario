// lib/features/mermas/screens/mermas_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';

import '../../inventory/models/product_model.dart';
import '../../inventory/models/inventario_db.dart';
import '../services/merma_pdf_service.dart';
import '../controllers/mermas_controller.dart'; // <-- Importar el controlador

import '../widgets/buscador_mermas.dart';
import '../widgets/barra_cantidad_mermas.dart';
import '../widgets/lista_mermas.dart';

class MermasScreen extends StatefulWidget {
  const MermasScreen({super.key});

  @override
  State<MermasScreen> createState() => _MermasScreenState();
}

class _MermasScreenState extends State<MermasScreen> {
  final InventarioDB _db = InventarioDB();
  final MermaPdfService _pdfService = MermaPdfService();

  // Instancia global del controlador
  final MermasController _mermasController = MermasController();

  List<Producto> _catalogo = [];
  bool _isLoading = true;
  bool _isGeneratingPdf = false;

  Producto? _productoSeleccionado;
  TextEditingController? _searchController;
  StreamSubscription<void>? _dbSubscription;

  bool _buscadorEnfocado = false;
  bool _cantidadEnfocada = false;

  bool get _mostrarBotonGenerar => !_buscadorEnfocado && !_cantidadEnfocada;

  @override
  void initState() {
    super.initState();
    _cargarCatalogo();
    _escucharCambiosDB();
  }

  Future<void> _escucharCambiosDB() async {
    final isar = await _db.db;
    _dbSubscription = isar.productos.watchLazy().listen((_) {
      if (mounted) _cargarCatalogo();
    });
  }

  @override
  void dispose() {
    _dbSubscription?.cancel();
    _searchController?.dispose();
    super.dispose();
  }

  Future<void> _cargarCatalogo() async {
    final productos = await _db.obtenerTodosLosProductos();
    setState(() {
      _catalogo = productos;
      _isLoading = false;
    });
  }

  Future<void> _confirmarLimpieza() async {
    if (_mermasController.listaMermas.isEmpty) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('¿Vacíar reporte?'),
        content: const Text('Se eliminarán todos los productos de esta lista.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Vacíar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      _mermasController.limpiarLista();
    }
  }

  Future<void> _generarYCompartirPDF() async {
    setState(() => _isGeneratingPdf = true);
    try {
      await _pdfService.generarYCompartirPDF(_mermasController.listaMermas);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar PDF: $e')),
      );
    } finally {
      setState(() => _isGeneratingPdf = false);
    }
  }

  Future<void> _mostrarDialogoEdicion(
      BuildContext context, int index, int cantidadActual) async {
    final TextEditingController _editController =
        TextEditingController(text: cantidadActual.toString());

    final nuevaCantidad = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Editar cantidad'),
        content: TextField(
          controller: _editController,
          keyboardType: TextInputType.number,
          autofocus: true,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            hintText: '0',
          ),
          onTap: () => _editController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _editController.text.length,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final val = int.tryParse(_editController.text) ?? 0;
              Navigator.pop(ctx, val);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (nuevaCantidad != null && mounted) {
      _mermasController.actualizarCantidad(index, nuevaCantidad);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimario = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        toolbarHeight: 10,
        backgroundColor: colorPrimario,
        foregroundColor: Colors.white,
      ),
      // Escuchamos los cambios en el controlador de mermas
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            _buscadorEnfocado = false;
            _cantidadEnfocada = false;
          });
        },
        child: ListenableBuilder(
          listenable: _mermasController,
          builder: (context, _) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final listaActual = _mermasController.listaMermas;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      BuscadorMermas(
                        catalogo: _catalogo,
                        onSelected: (producto) {
                          setState(() => _productoSeleccionado = producto);
                        },
                        onControllerCreated: (controller) {
                          _searchController = controller;
                        },
                        onFocusChange: (enfocado) {
                          setState(() => _buscadorEnfocado = enfocado);
                        },
                      ),
                      const SizedBox(height: 12),
                      BarraCantidadMermas(
                        hasProductoSeleccionado: _productoSeleccionado != null,
                        onAgregar: (cantidad) {
                          _mermasController.agregarMerma(
                              _productoSeleccionado!, cantidad);
                          setState(() => _productoSeleccionado = null);
                          _searchController?.clear();
                        },
                        onFocusChange: (enfocado) {
                          setState(() => _cantidadEnfocada = enfocado);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Productos a reportar:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      if (listaActual.isNotEmpty)
                        TextButton.icon(
                          onPressed: _confirmarLimpieza,
                          icon: const Icon(Icons.delete_sweep,
                              color: Colors.red, size: 20),
                          label: const Text('Limpiar',
                              style: TextStyle(color: Colors.red)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListaMermasVisual(
                    listaMermas: listaActual,
                    onEliminar: _mermasController.eliminarMerma,
                    onEditar: (index, cantidadActual) => {
                      _mostrarDialogoEdicion(context, index, cantidadActual)
                    },
                  ),
                ),
                if (_mostrarBotonGenerar)
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double
                            .infinity, // Asegura que el botón se estire de lado a lado
                        child: FilledButton.icon(
                          onPressed: _mermasController.listaMermas.isEmpty ||
                                  _isGeneratingPdf
                              ? null
                              : _generarYCompartirPDF,
                          icon: _isGeneratingPdf
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2))
                              : const Icon(Icons.picture_as_pdf),
                          label: Text(_isGeneratingPdf
                              ? 'Procesando...'
                              : 'Generar Reporte'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
