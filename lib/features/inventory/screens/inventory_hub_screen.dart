import 'package:flutter/material.dart';

import '../models/filtros_model.dart';
import '../controllers/inventory_controller.dart';
import '../widgets/count_bottom_sheet.dart';
import 'product_form_screen.dart';

// Agregamos SingleTickerProviderStateMixin para manejar las animaciones de las pestañas
class InventoryHubScreen extends StatefulWidget {
  const InventoryHubScreen({super.key});

  @override
  State<InventoryHubScreen> createState() => _InventoryHubScreenState();
}

class _InventoryHubScreenState extends State<InventoryHubScreen>
    with SingleTickerProviderStateMixin {
  final InventoryController _controller = InventoryController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Iniciamos las 3 pestañas
    _tabController = TabController(length: 3, vsync: this);

    // Escuchamos cuando el usuario toca una pestaña para avisarle a nuestro Cerebro
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        switch (_tabController.index) {
          case 0:
            _controller.cambiarCategoria(FiltroCategoria.todas);
            break;
          case 1:
            _controller.cambiarCategoria(FiltroCategoria.cervezas);
            break;
          case 2:
            _controller.cambiarCategoria(FiltroCategoria.cigarros);
            break;
        }
      }
    });

    _controller.cargarInventario();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        // 1. BARRA DE BÚSQUEDA INTEGRADA
        title: SizedBox(
          height: 40,
          child: TextField(
            onChanged: _controller.buscar,
            decoration: InputDecoration(
              hintText: 'Buscar cervezas, cigarros...',
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
        // 2. MENÚS DE ORDEN Y ESTADO EN LA ESQUINA
        actions: [
          // Menú para Completados / Faltantes
          PopupMenuButton<FiltroEstado>(
            color: Colors.white,
            icon: const Icon(Icons.filter_alt),
            tooltip: 'Estado del inventario',
            onSelected: _controller.cambiarFiltro,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: FiltroEstado.todos,
                child: Text('Mostrar Todo',
                    style: TextStyle(
                        fontWeight:
                            _controller.filtroActual == FiltroEstado.todos
                                ? FontWeight.bold
                                : FontWeight.normal)),
              ),
              PopupMenuItem(
                value: FiltroEstado.completados,
                child: Text('Completados',
                    style: TextStyle(
                        fontWeight:
                            _controller.filtroActual == FiltroEstado.completados
                                ? FontWeight.bold
                                : FontWeight.normal)),
              ),
              PopupMenuItem(
                value: FiltroEstado.faltantes,
                child: Text('Faltantes',
                    style: TextStyle(
                        fontWeight:
                            _controller.filtroActual == FiltroEstado.faltantes
                                ? FontWeight.bold
                                : FontWeight.normal)),
              ),
            ],
          ),
          // Menú de A-Z / 0-9
          PopupMenuButton<TipoOrdenamiento>(
            color: Colors.white,
            icon: const Icon(Icons.sort),
            tooltip: 'Ordenar lista',
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
        // 3. PESTAÑAS (TABS) NATIVAS
        bottom: TabBar(
          controller: _tabController,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Todo'),
            Tab(text: 'Cervezas'),
            Tab(text: 'Cigarros'),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 4. LA LISTA (Ahora ocupa toda la pantalla debajo del AppBar)
          return _controller.productosMostrados.isEmpty
              ? const Center(child: Text('No se encontraron productos.'))
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: _controller.productosMostrados.length,
                  itemBuilder: (context, index) {
                    final producto = _controller.productosMostrados[index];
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
                        title: Text(producto.descripcion,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text('Código: ${producto.codigoBarras}'),
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
                                  top: Radius.circular(24)),
                            ),
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
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final recargar = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductFormScreen()),
          );
          if (recargar == true) {
            await _controller.cargarInventario();
          }
        },
        // --- INYECCIÓN DE ESTILO TÁCTICO ---
        backgroundColor:
            Colors.red.shade700, // 1. El color de fondo de la pastilla
        foregroundColor:
            Colors.white, // 2. El color del ícono (contraste obligatorio)
        elevation: 2, // 3. Sombra. (0 = plano minimalista, 6 = flotante viejo)
        shape: RoundedRectangleBorder(
          // 4. Geometría corporativa (mata el círculo perfecto)
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add,
            size: 28), // Puedes aumentar el tamaño del ícono aquí
      ),
    );
  }
}
