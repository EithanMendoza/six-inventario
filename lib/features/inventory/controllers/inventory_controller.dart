// lib/features/inventory/controllers/inventory_controller.dart

import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/filtros_model.dart';
import '../models/inventario_db.dart';

class InventoryController extends ChangeNotifier {
  final InventarioDB _db = InventarioDB();

  // El catálogo original intacto
  List<Producto> _catalogoCompleto = [];

  // La lista que la UI va a dibujar (ya filtrada y ordenada)
  List<Producto> productosMostrados = [];
  bool isLoading = true;

  // Variables de estado actuales
  String _busquedaActual = '';
  FiltroEstado _filtroActual = FiltroEstado.todos;
  TipoOrdenamiento _ordenActual = TipoOrdenamiento.alfabeticoAsc;

  // --- NUEVO: Estado de la Categoría ---
  FiltroCategoria _categoriaActual = FiltroCategoria.todas;

  // --- GETTERS ---
  FiltroEstado get filtroActual => _filtroActual;
  TipoOrdenamiento get ordenActual => _ordenActual;

  // --- NUEVO: Getter de la Categoría ---
  FiltroCategoria get categoriaActual => _categoriaActual;

  // --- INICIALIZACIÓN ---
  Future<void> cargarInventario() async {
    isLoading = true;
    notifyListeners(); // Avisa a la UI que muestre el circulito de carga

    _catalogoCompleto = await _db.obtenerTodosLosProductos();
    _aplicarFiltrosYOrden(); // Procesa la lista por primera vez
  }

  // --- MÉTODOS PARA CAMBIAR EL ESTADO DESDE LA UI ---
  void buscar(String texto) {
    _busquedaActual = texto.toLowerCase();
    _aplicarFiltrosYOrden();
  }

  void cambiarFiltro(FiltroEstado nuevoFiltro) {
    _filtroActual = nuevoFiltro;
    _aplicarFiltrosYOrden();
  }

  void cambiarOrden(TipoOrdenamiento nuevoOrden) {
    _ordenActual = nuevoOrden;
    _aplicarFiltrosYOrden();
  }

  // --- NUEVO: Método para cambiar la categoría ---
  void cambiarCategoria(FiltroCategoria nuevaCategoria) {
    _categoriaActual = nuevaCategoria;
    _aplicarFiltrosYOrden();
  }

  // --- MÉTODO PARA GUARDAR CAMBIOS ---
  Future<void> actualizarConteo(Producto producto) async {
    // 1. Guardamos el cambio físico en la base de datos de Isar
    await _db.guardarProducto(producto);

    // 2. Recargamos la lista para que la interfaz se ponga verde y actualice el número
    await cargarInventario();
  }

  // --- LA MAGIA: Lógica de Filtrado y Ordenamiento Modular ---
  void _aplicarFiltrosYOrden() {
    // 1. Empezamos con la lista completa
    List<Producto> listaTemporal = List.from(_catalogoCompleto);

    // 2. Filtro por Búsqueda (Coincidencia parcial en nombre o código)
    if (_busquedaActual.isNotEmpty) {
      listaTemporal = listaTemporal.where((p) {
        final coincideNombre =
            p.descripcion.toLowerCase().contains(_busquedaActual);
        final coincideCodigo = p.codigoBarras.contains(_busquedaActual);
        return coincideNombre || coincideCodigo;
      }).toList();
    }

    // --- NUEVO: 3. Filtro por Categoría (Cervezas vs Cigarros) ---
    if (_categoriaActual == FiltroCategoria.cigarros) {
      // Si son cigarros, filtramos los que tienen la agrupación exacta
      listaTemporal = listaTemporal
          .where((p) => p.agrupacion == TipoAgrupacion.cigarros10)
          .toList();
    } else if (_categoriaActual == FiltroCategoria.cervezas) {
      // Si son cervezas, traemos todo lo que NO sea agrupación de cigarros
      listaTemporal = listaTemporal
          .where((p) => p.agrupacion != TipoAgrupacion.cigarros10)
          .toList();
    }

    // 4. Filtro por Estado (Completados / Faltantes)
    if (_filtroActual == FiltroEstado.completados) {
      listaTemporal = listaTemporal.where((p) => p.cantidadFisica > 0).toList();
    } else if (_filtroActual == FiltroEstado.faltantes) {
      listaTemporal =
          listaTemporal.where((p) => p.cantidadFisica == 0).toList();
    }

    // 5. Ordenamiento
    listaTemporal.sort((a, b) {
      switch (_ordenActual) {
        case TipoOrdenamiento.alfabeticoAsc:
          return a.descripcion.compareTo(b.descripcion);
        case TipoOrdenamiento.alfabeticoDesc:
          return b.descripcion.compareTo(a.descripcion);
        case TipoOrdenamiento.codigoAsc:
          return a.codigoBarras.compareTo(b.codigoBarras);
        case TipoOrdenamiento.codigoDesc:
          return b.codigoBarras.compareTo(a.codigoBarras);
      }
    });

    // 6. Actualizamos la lista final y avisamos a la pantalla
    productosMostrados = listaTemporal;
    isLoading = false;
    notifyListeners(); // ¡Esto dispara el redibujado solo donde importa!
  }
}
