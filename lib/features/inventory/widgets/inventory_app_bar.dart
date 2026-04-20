// lib/features/inventory/widgets/inventory_app_bar.dart
import 'package:flutter/material.dart';
import 'package:six_inventario/core/app_theme.dart';
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
            hintText: 'Buscar',
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
        ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              return IconButton(
                icon: Icon(
                  controller.modoAuditoria
                      ? Icons.admin_panel_settings
                      : Icons.admin_panel_settings_outlined,
                  color: controller.modoAuditoria ? Colors.amber : Colors.white,
                ),
                tooltip: 'Modo Auditoría',
                onPressed: controller.toggleModoAuditoria,
              );
            }),
        _buildFilterMenu(),
        _buildSortMenu(context),
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
    // MAGIA AQUÍ: Envolvemos el menú para que escuche los cambios de color en tiempo real
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        Color colorIcono;
        switch (controller.filtroActual) {
          case FiltroEstado.completados:
            colorIcono = Colors.greenAccent;
            break;
          case FiltroEstado.faltantes:
            colorIcono = Colors.orangeAccent;
            break;
          case FiltroEstado.todos:
          default:
            colorIcono = Colors.white; // O el color de tu AppBar
            break;
        }

        return PopupMenuButton<FiltroEstado>(
          icon: Icon(Icons.filter_alt, color: colorIcono),
          onSelected: controller.cambiarFiltro,
          itemBuilder: (context) => [
            _buildPopupItem(FiltroEstado.todos, 'Mostrar Todo'),
            _buildPopupItem(FiltroEstado.completados, 'Contados'),
            _buildPopupItem(FiltroEstado.faltantes, 'Sin contar'),
          ],
        );
      },
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
                  : FontWeight.normal,
              color: controller.filtroActual == valor
                  ? AppTheme.colorPrimario
                  : Colors.black87)),
    );
  }

  Widget _buildSortMenu(BuildContext context) {
    // También lo hacemos reactivo para que el icono principal cambie de color
    return ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final bool isDefault =
              controller.ordenActual == TipoOrdenamiento.recientes;

          return PopupMenuButton<TipoOrdenamiento>(
            icon: Icon(
              Icons.sort,
              color: isDefault ? Colors.white : Colors.lightBlueAccent,
            ),
            onSelected: controller.cambiarOrden,
            itemBuilder: (ctx) => [
              // GRUPO 1: Tiempo (Iconos de reloj muy claros)
              _buildSortItem(ctx, TipoOrdenamiento.recientes, 'Más Recientes',
                  Icons.access_time),
              _buildSortItem(ctx, TipoOrdenamiento.antiguos, 'Más Antiguos',
                  Icons.history),

              const PopupMenuDivider(),

              // GRUPO 2: Alfabético (Flechas direccionales)
              _buildSortItem(ctx, TipoOrdenamiento.alfabeticoAsc, 'A - Z',
                  Icons.arrow_downward),
              _buildSortItem(ctx, TipoOrdenamiento.alfabeticoDesc, 'Z - A',
                  Icons.arrow_upward),

              const PopupMenuDivider(),

              // GRUPO 3: Códigos (Flechas direccionales)
              _buildSortItem(
                  ctx, TipoOrdenamiento.codigoAsc, '0 - 9', Icons.arrow_upward),
              _buildSortItem(ctx, TipoOrdenamiento.codigoDesc, '9 - 0',
                  Icons.arrow_downward),
            ],
          );
        });
  }

  // 3. Modificamos la función para que reciba el BuildContext
  PopupMenuItem<TipoOrdenamiento> _buildSortItem(BuildContext context,
      TipoOrdenamiento valor, String texto, IconData icono) {
    final bool isSelected = controller.ordenActual == valor;

    // 4. ¡Ahora esto funcionará perfectamente porque ya sabe qué es context!
    final colorPrimario = Theme.of(context).colorScheme.primary;

    return PopupMenuItem(
      value: valor,
      child: Row(
        children: [
          Icon(icono,
              size: 20,
              color: isSelected ? colorPrimario : Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(
            texto,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? colorPrimario : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48);
}
