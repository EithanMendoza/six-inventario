import 'package:flutter/material.dart';

// Modelos y Servicios
import '../../inventory/models/product_model.dart';
import '../../inventory/models/inventario_db.dart';
import '../models/item_merma.dart';
import '../services/merma_pdf_service.dart';

// Widgets modulares
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

  List<Producto> _catalogo = [];
  final List<ItemMerma> _listaMermas = [];

  bool _isLoading = true;
  bool _isGeneratingPdf = false;

  Producto? _productoSeleccionado;
  TextEditingController? _searchController;

  @override
  void initState() {
    super.initState();
    _cargarCatalogo();
  }

  Future<void> _cargarCatalogo() async {
    final productos = await _db.obtenerTodosLosProductos();
    setState(() {
      _catalogo = productos;
      _isLoading = false;
    });
  }

  void _agregarMerma(Producto producto, int cantidad) {
    setState(() {
      _listaMermas.add(ItemMerma(producto: producto, cantidad: cantidad));
    });
  }

  void _eliminarMerma(int index) {
    setState(() {
      _listaMermas.removeAt(index);
    });
  }

  Future<void> _limpiarLista() async {
    if (_listaMermas.isEmpty) return; // No abrimos alerta si ya está vacía

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('¿Vacíar reporte?'),
        content: const Text(
            'Se eliminarán todos los productos de esta lista. Tendrás que agregarlos de nuevo.'),
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
      setState(() {
        _listaMermas.clear();
      });
    }
  }

  Future<void> _generarYCompartirPDF() async {
    setState(() => _isGeneratingPdf = true);
    try {
      await _pdfService.generarYCompartirPDF(_listaMermas);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar PDF: $e')),
      );
    } finally {
      setState(() => _isGeneratingPdf = false);
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CONTENEDOR CON LOS 3 COMPONENTES
                Container(
                  margin: const EdgeInsets.all(16.0),
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
                    children: [
                      BuscadorMermas(
                        catalogo: _catalogo,
                        onSelected: (producto) {
                          setState(() => _productoSeleccionado = producto);
                        },
                        onControllerCreated: (controller) {
                          _searchController = controller;
                        },
                      ),
                      const SizedBox(height: 12),
                      BarraCantidadMermas(
                        hasProductoSeleccionado: _productoSeleccionado != null,
                        onAgregar: (cantidad) {
                          _agregarMerma(_productoSeleccionado!, cantidad);
                          setState(() => _productoSeleccionado = null);
                          _searchController?.clear();
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      // El botón solo aparece si hay elementos en la lista
                      if (_listaMermas.isNotEmpty)
                        TextButton.icon(
                          onPressed: _limpiarLista,
                          icon: const Icon(Icons.delete_sweep,
                              color: Colors.red, size: 20),
                          label: const Text('Limpiar',
                              style: TextStyle(color: Colors.red)),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListaMermasVisual(
                    listaMermas: _listaMermas,
                    onEliminar: _eliminarMerma,
                  ),
                ),
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton.icon(
            onPressed: _listaMermas.isEmpty || _isGeneratingPdf
                ? null
                : _generarYCompartirPDF,
            icon: _isGeneratingPdf
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.picture_as_pdf),
            label: Text(_isGeneratingPdf ? 'Procesando...' : 'Generar Reporte',
                style: const TextStyle(fontSize: 14)),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.red.shade700,
              disabledBackgroundColor: Colors.grey.shade300,
            ),
          ),
        ),
      ),
    );
  }
}
