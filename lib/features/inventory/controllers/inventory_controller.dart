// lib/features/inventory/controllers/inventory_controller.dart

import 'dart:async'; // Necesario para el Debouncer (Timer)
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

  // EL NÚCLEO DE LA OPCIÓN A: Mapa de caché para la UI síncrona
  final Map<int?, List<Producto>> _productosFiltrados = {};

  List<Categoria> categoriasDisponibles = [];
  bool isLoading = true;

  String _busquedaActual = '';
  FiltroEstado _filtroActual = FiltroEstado.todos;
  TipoOrdenamiento _ordenActual = TipoOrdenamiento.alfabeticoAsc;
  Presentacion? _presentacionActual;

  FiltroEstado get filtroActual => _filtroActual;
  TipoOrdenamiento get ordenActual => _ordenActual;
  Presentacion? get presentacionActual => _presentacionActual;

  final Map<int?, List<Presentacion>> _cachePresentaciones = {};

  // ==========================================
  // AUDITORÍA: Controles de Concurrencia
  // ==========================================
  int _idConsultaActual = 0;
  Timer? _debounceTimer; // Escudo protector contra exceso de consultas a BD

  // Método consumido por inventory_hub_screen.dart (100% Síncrono)
  List<Producto> obtenerProductosProcesados({Categoria? categoriaEspecifica}) {
    return _productosFiltrados[categoriaEspecifica?.id] ?? [];
  }

  bool modoAuditoria = false;

  void toggleModoAuditoria() {
    modoAuditoria = !modoAuditoria;
    notifyListeners();
  }

  Future<void> cargarInventario() async {
    isLoading = true;
    notifyListeners();

    final isar = await _db.db;
    categoriasDisponibles =
        await isar.collection<Categoria>().where().findAll();

    await _generarCachePresentaciones(isar);

    // Llenamos el mapa por primera vez
    await _actualizarResultados();
  }

  // MÉTODO MAESTRO: Calcula asíncronamente las listas con protección de concurrencia
  Future<void> _actualizarResultados() async {
    final int idEstaConsulta = ++_idConsultaActual; // Tomamos turno
    final isar = await _db.db;

    // MAPA TEMPORAL: Evita parpadeos en la UI y limpia llaves de categorías borradas (Fugas de memoria)
    final Map<int?, List<Producto>> nuevoMapaCalculado = {};

    // A) Consulta para la pestaña "Todo" (null)
    final resultadosTodo = await InventoryFilterService.ejecutarPipeline(
      isar: isar,
      busqueda: _busquedaActual,
      categoria: null,
      presentacion: _presentacionActual,
      estado: _filtroActual,
      orden: _ordenActual,
    );

    // SEGURIDAD: Si el usuario ya movió otra cosa mientras calculábamos, abortamos silenciosamente
    if (idEstaConsulta != _idConsultaActual) return;

    nuevoMapaCalculado[null] = resultadosTodo;

    // B) Ejecución Paralela: Lanzamos todas las consultas de categorías al mismo tiempo
    final futures = categoriasDisponibles.map((cat) async {
      final res = await InventoryFilterService.ejecutarPipeline(
        isar: isar,
        busqueda: _busquedaActual,
        categoria: cat,
        presentacion: _presentacionActual,
        estado: _filtroActual,
        orden: _ordenActual,
      );
      return MapEntry(cat.id, res);
    });

    // Esperamos a que todas las consultas paralelas terminen
    final resultadosCategorias = await Future.wait(futures);

    // Verificamos por última vez el token antes de tocar la pantalla del usuario
    if (idEstaConsulta != _idConsultaActual) return;

    for (var entry in resultadosCategorias) {
      nuevoMapaCalculado[entry.key] = entry.value;
    }

    // C) Actualización Atómica Final
    _productosFiltrados.clear(); // Limpiamos la RAM basura de forma segura
    _productosFiltrados.addAll(nuevoMapaCalculado); // Inyectamos la data nueva

    isLoading = false;
    notifyListeners(); // Avisamos a la UI que el diccionario ya está listo
  }

  List<Presentacion> obtenerPresentacionesParaCategoria(Categoria? cat) {
    return _cachePresentaciones[cat?.id] ?? [];
  }

  Future<void> _generarCachePresentaciones(Isar isar) async {
    _cachePresentaciones.clear();

    // 1. Extraemos todo a una lista TEMPORAL (se destruirá al terminar la función liberando la RAM)
    final catalogoTemporal = await isar.productos.where().findAll();

    // 2. Cargamos las relaciones estructurales en paralelo (Evita el N+1)
    await Future.wait([
      ...catalogoTemporal.map((p) => p.categoria.load()),
      ...catalogoTemporal.map((p) => p.presentacion.load()),
    ]);

    // 3. RESTAURAMOS TU LÓGICA ORIGINAL: Chips para la pestaña "Todo" (null)
    final Map<int, Presentacion> unicasGlobal = {};
    for (var p in catalogoTemporal) {
      if (p.presentacion.value != null) {
        unicasGlobal[p.presentacion.value!.id] = p.presentacion.value!;
      }
    }
    _cachePresentaciones[null] = unicasGlobal.values.toList();

    // 4. RESTAURAMOS TU LÓGICA ORIGINAL: Chips exclusivos por Categoría
    for (var cat in categoriasDisponibles) {
      final Map<int, Presentacion> unicasCat = {};
      for (var p in catalogoTemporal) {
        if (p.categoria.value?.id == cat.id && p.presentacion.value != null) {
          unicasCat[p.presentacion.value!.id] = p.presentacion.value!;
        }
      }
      _cachePresentaciones[cat.id] = unicasCat.values.toList();
    }
  }

  void buscar(String texto) {
    _busquedaActual = texto;
    isLoading = true;
    notifyListeners(); // Mostramos indicador de carga al teclear

    // Si el usuario teclea otra letra, cancelamos la cuenta regresiva anterior
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    // Esperamos 300ms de inactividad antes de golpear la base de datos
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _actualizarResultados();
    });
  }

  void cambiarFiltro(FiltroEstado nuevoFiltro) async {
    _filtroActual = nuevoFiltro;
    isLoading = true;
    notifyListeners();
    await _actualizarResultados();
  }

  void cambiarOrden(TipoOrdenamiento nuevoOrden) async {
    _ordenActual = nuevoOrden;
    isLoading = true;
    notifyListeners();
    await _actualizarResultados();
  }

  void cambiarPresentacion(Presentacion? nuevaPresentacion) async {
    _presentacionActual = nuevaPresentacion;
    isLoading = true;
    notifyListeners();
    await _actualizarResultados();
  }

  Future<void> actualizarConteo(Producto producto) async {
    await _db.guardarProducto(producto);
    // Solo actualizamos las listas de resultados, sin reconstruir cachés estructurales
    await _actualizarResultados();
  }
}
