// lib/features/inventory/screens/inventory_hub_screen.dart

import 'package:flutter/material.dart';
import 'package:six_inventario/features/inventory/models/product_model.dart';

import '../models/category_model.dart';
import '../models/filtros_model.dart';
import '../models/presentacion_model.dart'; // NUEVO: Importamos el modelo
import '../controllers/inventory_controller.dart';
import '../widgets/count_bottom_sheet.dart';
import '../widgets/inventory_filters.dart';
import 'category_seetings_screen.dart';
import 'product_form_screen.dart';

class InventoryHubScreen extends StatefulWidget {
  const InventoryHubScreen({super.key});

  @override
  State<InventoryHubScreen> createState() => _InventoryHubScreenState();
}

class _InventoryHubScreenState extends State<InventoryHubScreen>
    with TickerProviderStateMixin {
  final InventoryController _controller = InventoryController();
  late TabController _tabController;
  int _currentTabLength = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _currentTabLength, vsync: this);
    _tabController.addListener(_onTabChanged);
    _controller.addListener(_actualizarTabsDinamicamente);
    _controller.cargarInventario();
  }

  void _actualizarTabsDinamicamente() {
    final nuevaCantidad = 1 + _controller.categoriasDisponibles.length;
    if (nuevaCantidad != _currentTabLength) {
      final indiceAnterior = _tabController.index;
      _tabController.removeListener(_onTabChanged);
      _tabController.dispose();

      _tabController = TabController(
        length: nuevaCantidad,
        vsync: this,
        initialIndex: indiceAnterior < nuevaCantidad ? indiceAnterior : 0,
      );
      _tabController.addListener(_onTabChanged);

      setState(() {
        _currentTabLength = nuevaCantidad;
      });
    }
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      // Si el usuario cambia de categoría, limpiamos el filtro del chip para evitar cruces
      if (_controller.presentacionActual != null) {
        _controller.cambiarPresentacion(null);
      }
      // Forzamos un rebuild de la UI para que los ChoiceChips cambien
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_actualizarTabsDinamicamente);
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // =======================================================================
  // UI PRINCIPAL (MÉTODOS EXTRAÍDOS PARA MEJOR LEGIBILIDAD)
  // =======================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. La Lista de Productos
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Pestaña "Todo" (catálogo completo)
                    _buildPagina(
                        null,
                        _controller.obtenerProductosProcesados(
                            categoriaEspecifica: null)),

                    // Pestañas por Categoría
                    ..._controller.categoriasDisponibles.map((cat) {
                      return _buildPagina(
                          cat,
                          _controller.obtenerProductosProcesados(
                              categoriaEspecifica: cat));
                    }),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

// --- SUB-WIDGET: Construcción de la Página Completa por Pestaña ---
  Widget _buildPagina(Categoria? categoria, List<Producto> productosMostrados) {
    // 1. Obtenemos los empaques desde la caché (O(1)) para esta pestaña
    final chipsActivos =
        _controller.obtenerPresentacionesParaCategoria(categoria);

    return Column(
      children: [
        // 2. La barra de filtros ahora vive dentro de la pestaña y se anima con ella
        InventoryFilters(
          controller: _controller,
          presentacionesActivas: chipsActivos,
        ),

        // 3. La lista de productos
        Expanded(
          child: productosMostrados.isEmpty
              ? const Center(
                  child: Text('No se encontraron productos con estos filtros.'))
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: productosMostrados.length,
                  itemBuilder: (context, index) {
                    final producto = productosMostrados[index];
                    bool isCounted = producto.cantidadFisica > 0;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 6.0),
                      elevation: isCounted ? 0 : 2,
                      color: isCounted ? Colors.green.shade50 : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: isCounted
                            ? BorderSide(color: Colors.green.shade200)
                            : BorderSide.none,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        title: Text(
                          producto.descripcion,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Código: ${producto.codigoBarras}'),
                            if (producto.presentacion.value != null)
                              Text(
                                'Empaque: ${producto.presentacion.value!.nombre}',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12),
                              ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Cant.',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                            Text(
                              isCounted ? '${producto.cantidadFisica}' : '0',
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
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24))),
                            builder: (context) => CountBottomSheet(
                              producto: producto,
                              onSaved: () async {
                                await _controller.actualizarConteo(producto);
                              },
                            ),
                          );
                        },
                        onLongPress: () async {
                          final recargar = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductFormScreen(
                                    productoAEditar: producto)),
                          );
                          if (recargar == true) {
                            await _controller.cargarInventario();
                          }
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

// --- SUB-WIDGET: Lista de Productos ---
  Widget _buildListaProductos(List<Producto> productosMostrados) {
    // 1. Manejamos el estado vacío de forma independiente para cada Tab
    if (productosMostrados.isEmpty) {
      return const Center(
          child: Text('No se encontraron productos con estos filtros.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount:
          productosMostrados.length, // <-- CORREGIDO: Usamos el parámetro local
      itemBuilder: (context, index) {
        final producto = productosMostrados[
            index]; // <-- CORREGIDO: Usamos el parámetro local
        bool isCounted = producto.cantidadFisica > 0;

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
                // Mostramos el empaque en la tarjeta para mayor claridad visual
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
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24))),
                builder: (context) => CountBottomSheet(
                  producto: producto,
                  onSaved: () async {
                    await _controller.actualizarConteo(producto);
                  },
                ),
              );
            },
            onLongPress: () async {
              final recargar = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProductFormScreen(productoAEditar: producto)),
              );
              if (recargar == true) {
                await _controller.cargarInventario();
              }
            },
          ),
        );
      },
    );
  }

  // --- SUB-WIDGET: AppBar ---
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 16,
      title: SizedBox(
        height: 40,
        child: TextField(
          onChanged: _controller.buscar,
          decoration: InputDecoration(
            hintText: 'Buscar productos...',
            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            prefixIcon:
                Icon(Icons.search, color: Colors.grey.shade600, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'Ajustes de Catálogo',
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CategorySettingsScreen()),
            );
            _controller.cargarInventario();
          },
        ),
        PopupMenuButton<FiltroEstado>(
          color: Colors.white,
          icon: const Icon(Icons.filter_alt),
          onSelected: _controller.cambiarFiltro,
          itemBuilder: (context) => [
            PopupMenuItem(
                value: FiltroEstado.todos,
                child: Text('Mostrar Todo',
                    style: TextStyle(
                        fontWeight:
                            _controller.filtroActual == FiltroEstado.todos
                                ? FontWeight.bold
                                : FontWeight.normal))),
            PopupMenuItem(
                value: FiltroEstado.completados,
                child: Text('Completados',
                    style: TextStyle(
                        fontWeight:
                            _controller.filtroActual == FiltroEstado.completados
                                ? FontWeight.bold
                                : FontWeight.normal))),
            PopupMenuItem(
                value: FiltroEstado.faltantes,
                child: Text('Faltantes',
                    style: TextStyle(
                        fontWeight:
                            _controller.filtroActual == FiltroEstado.faltantes
                                ? FontWeight.bold
                                : FontWeight.normal))),
          ],
        ),
        PopupMenuButton<TipoOrdenamiento>(
          color: Colors.white,
          icon: const Icon(Icons.sort),
          onSelected: _controller.cambiarOrden,
          itemBuilder: (context) => const [
            PopupMenuItem(
                value: TipoOrdenamiento.alfabeticoAsc, child: Text('A - Z')),
            PopupMenuItem(
                value: TipoOrdenamiento.alfabeticoDesc, child: Text('Z - A')),
            PopupMenuItem(
                value: TipoOrdenamiento.codigoAsc,
                child: Text('Código Ascendente (0-9)')),
            PopupMenuItem(
                value: TipoOrdenamiento.codigoDesc,
                child: Text('Código Descendente (9-0)')),
          ],
        ),
        const SizedBox(width: 6),
      ],
      bottom: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorWeight: 3,
        tabs: [
          const Tab(text: 'Todo'),
          ..._controller.categoriasDisponibles
              .map((cat) => Tab(text: cat.nombre)),
        ],
      ),
    );
  }

  // --- SUB-WIDGET: Floating Action Button ---
  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final recargar = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProductFormScreen()),
        );
        if (recargar == true) {
          await _controller.cargarInventario();
        }
      },
      backgroundColor: Colors.red.shade700,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.add, size: 28),
    );
  }
}
