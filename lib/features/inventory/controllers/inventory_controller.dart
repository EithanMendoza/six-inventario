// lib/features/inventory/controllers/inventory_controller.dart

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/presentacion_model.dart';
import '../models/filtros_model.dart';
import '../models/inventario_db.dart';
import '../services/inventory_filter_service.dart';

class InventoryController extends ChangeNotifier {
  final InventarioDB _db = InventarioDB();

  List<Producto> _catalogoCompleto = [];

  List<Producto> obtenerProductosProcesados({Categoria? categoriaEspecifica}) {
    return InventoryFilterService.ejecutarPipeline(
      catalogoBase: _catalogoCompleto,
      busqueda: _busquedaActual,
      categoria: categoriaEspecifica, // Se inyecta según el Tab actual de la UI
      presentacion: _presentacionActual,
      estado: _filtroActual,
      orden: _ordenActual,
    );
  }

  List<Categoria> categoriasDisponibles = [];
  bool isLoading = true;

  String _busquedaActual = '';
  FiltroEstado _filtroActual = FiltroEstado.todos;
  TipoOrdenamiento _ordenActual = TipoOrdenamiento.alfabeticoAsc;
  Presentacion? _presentacionActual;

  FiltroEstado get filtroActual => _filtroActual;
  TipoOrdenamiento get ordenActual => _ordenActual;
  Presentacion? get presentacionActual => _presentacionActual;

  // CACHÉ: Mapa para acceso instantáneo a los chips. Key = Categoria ID (null para "Todo")
  final Map<int?, List<Presentacion>> _cachePresentaciones = {};

  Future<void> cargarInventario() async {
    isLoading = true;
    notifyListeners();

    _catalogoCompleto = await _db.obtenerTodosLosProductos();
    final isar = await _db.db;

    for (var p in _catalogoCompleto) {
      await p.categoria.load();
      await p.presentacion.load();
    }

    categoriasDisponibles =
        await isar.collection<Categoria>().where().findAll();

    // NUEVO: Generamos el mapa de acceso rápido antes de dibujar la UI
    _generarCachePresentaciones();

    _aplicarFiltrosYOrden();
  }

  List<Presentacion> obtenerPresentacionesParaCategoria(Categoria? cat) {
    // Lectura O(1). Cero cálculos en el hilo de la interfaz.
    return _cachePresentaciones[cat?.id] ?? [];
  }

  void _generarCachePresentaciones() {
    _cachePresentaciones.clear();

    // 1. Pre-calcular chips para la pestaña "Todo" (null)
    final Map<int, Presentacion> unicasGlobal = {};
    for (var p in _catalogoCompleto) {
      if (p.presentacion.value != null) {
        unicasGlobal[p.presentacion.value!.id] = p.presentacion.value!;
      }
    }
    _cachePresentaciones[null] = unicasGlobal.values.toList();

    // 2. Pre-calcular chips para cada categoría
    for (var cat in categoriasDisponibles) {
      final Map<int, Presentacion> unicasCat = {};
      for (var p in _catalogoCompleto) {
        if (p.categoria.value?.id == cat.id && p.presentacion.value != null) {
          unicasCat[p.presentacion.value!.id] = p.presentacion.value!;
        }
      }
      _cachePresentaciones[cat.id] = unicasCat.values.toList();
    }
  }

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

  void cambiarPresentacion(Presentacion? nuevaPresentacion) {
    _presentacionActual = nuevaPresentacion;
    _aplicarFiltrosYOrden();
  }

  Future<void> actualizarConteo(Producto producto) async {
    await _db.guardarProducto(producto);
    await cargarInventario();
  }

  void _aplicarFiltrosYOrden() {
    List<Producto> listaTemporal = List.from(_catalogoCompleto);

    if (_busquedaActual.isNotEmpty) {
      listaTemporal = listaTemporal.where((p) {
        return p.descripcion.toLowerCase().contains(_busquedaActual) ||
            p.codigoBarras.contains(_busquedaActual);
      }).toList();
    }

    if (_presentacionActual != null) {
      listaTemporal = listaTemporal
          .where((p) => p.presentacion.value?.id == _presentacionActual!.id)
          .toList();
    }

    if (_filtroActual == FiltroEstado.completados) {
      listaTemporal = listaTemporal.where((p) => p.cantidadFisica > 0).toList();
    } else if (_filtroActual == FiltroEstado.faltantes) {
      listaTemporal =
          listaTemporal.where((p) => p.cantidadFisica == 0).toList();
    }

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

    isLoading = false;
    notifyListeners();
  }
}
