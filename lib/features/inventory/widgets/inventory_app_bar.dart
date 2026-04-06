// lib/features/inventory/widgets/inventory_app_bar.dart
import 'package:flutter/material.dart';
import '../controllers/inventory_controller.dart';
import '../models/filtros_model.dart';
import '../screens/category_settings_screen.dart';

class InventoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final InventoryController controller;
  final TabController tabController;

  const InventoryAppBar({
    super.key,
    required this.controller,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 16,
      title: SizedBox(
        height: 40,
        child: TextField(
          onChanged: controller.buscar,
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
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
          tooltip: 'Gestionar Categorías',
          onPressed: () async {
            // 1. NAVEGACIÓN ATÓMICA: La app "se detiene" en esta pantalla.
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CategorySettingsScreen()),
            );
            controller.cargarInventario();
          },
        ),
        _buildFilterMenu(),
        _buildSortMenu(),
        const SizedBox(width: 6),
      ],
      bottom: TabBar(
        controller: tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54,
        indicatorColor: Colors.white, // Restaurado a tu estilo
        indicatorWeight: 3,
        tabs: [
          const Tab(text: 'Todo'),
          ...controller.categoriasDisponibles
              .map((cat) => Tab(text: cat.nombre)),
        ],
      ),
    );
  }

  Widget _buildFilterMenu() {
    return PopupMenuButton<FiltroEstado>(
      icon: const Icon(Icons.filter_alt),
      onSelected: controller.cambiarFiltro,
      itemBuilder: (context) => [
        _buildPopupItem(FiltroEstado.todos, 'Mostrar Todo'),
        _buildPopupItem(FiltroEstado.completados, 'Completados'),
        _buildPopupItem(FiltroEstado.faltantes, 'Faltantes'),
      ],
    );
  }

  PopupMenuItem<FiltroEstado> _buildPopupItem(
      FiltroEstado valor, String texto) {
    return PopupMenuItem(
      value: valor,
      child: Text(texto,
          style: TextStyle(
              fontWeight: controller.filtroActual == valor
                  ? FontWeight.bold
                  : FontWeight.normal)),
    );
  }

  Widget _buildSortMenu() {
    return PopupMenuButton<TipoOrdenamiento>(
      icon: const Icon(Icons.sort),
      onSelected: controller.cambiarOrden,
      itemBuilder: (context) => const [
        PopupMenuItem(
            value: TipoOrdenamiento.alfabeticoAsc, child: Text('A - Z')),
        PopupMenuItem(
            value: TipoOrdenamiento.alfabeticoDesc, child: Text('Z - A')),
        PopupMenuItem(value: TipoOrdenamiento.codigoAsc, child: Text('0 - 9')),
        PopupMenuItem(value: TipoOrdenamiento.codigoDesc, child: Text('9 - 0')),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48);
}
