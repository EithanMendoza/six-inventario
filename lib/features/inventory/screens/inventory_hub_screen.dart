// lib/features/inventory/screens/inventory_hub_screen.dart

import 'package:flutter/material.dart';
import '../controllers/inventory_controller.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../widgets/inventory_app_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/inventory_filters.dart';
import '../widgets/count_bottom_sheet.dart';
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

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _controller.removeListener(_actualizarTabsDinamicamente);
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
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

      setState(() => _currentTabLength = nuevaCantidad);
    }
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      if (_controller.presentacionActual != null) {
        _controller.cambiarPresentacion(null);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InventoryAppBar(
        controller: _controller,
        tabController: _tabController,
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildPagina(null),
              ..._controller.categoriasDisponibles
                  .map((cat) => _buildPagina(cat)),
            ],
          );
        },
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildPagina(Categoria? categoria) {
    final productos =
        _controller.obtenerProductosProcesados(categoriaEspecifica: categoria);
    final chipsActivos =
        _controller.obtenerPresentacionesParaCategoria(categoria);

    return Column(
      children: [
        InventoryFilters(
          controller: _controller,
          presentacionesActivas: chipsActivos,
        ),
        Expanded(
          child: productos.isEmpty
              ? const Center(child: Text('No hay productos con estos filtros.'))
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final producto = productos[index];
                    return ProductCard(
                      producto: producto,
                      onTap: () => _abrirConteo(producto),
                      onLongPress: () => _abrirEdicion(producto),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _abrirConteo(Producto producto) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => CountBottomSheet(
        producto: producto,
        onSaved: () => _controller.actualizarConteo(producto),
      ),
    );
  }

  void _abrirEdicion(Producto producto) async {
    final recargar = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProductFormScreen(productoAEditar: producto)));
    if (recargar == true) _controller.cargarInventario();
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () async {
        final recargar = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProductFormScreen()));
        if (recargar == true) _controller.cargarInventario();
      },
      backgroundColor: Colors.red.shade700,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.add, size: 28),
    );
  }
}
