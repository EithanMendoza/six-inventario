// lib/features/inventory/services/inventory_filter_service.dart

import 'package:isar/isar.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/presentacion_model.dart';
import '../models/filtros_model.dart';

class InventoryFilterService {
  static Future<List<Producto>> ejecutarPipeline({
    required Isar isar,
    String busqueda = '',
    Categoria? categoria,
    Presentacion? presentacion,
    FiltroEstado estado = FiltroEstado.todos,
    TipoOrdenamiento orden = TipoOrdenamiento.recientes,
  }) async {
    // 1. Iniciamos con un filtro que siempre sea cierto para mover el estado
    // de QFilterCondition a QAfterFilterCondition inmediatamente.
    var query = isar.productos.filter().idGreaterThan(-1);

    // 2. Aplicamos filtros condicionales
    if (busqueda.isNotEmpty) {
      final b = busqueda.toLowerCase();
      query = query.group((q) => q
          .descripcionContains(b, caseSensitive: false)
          .or()
          .codigoBarrasContains(b, caseSensitive: false));
    }

    if (categoria != null) {
      query = query.categoria((q) => q.idEqualTo(categoria.id));
    }

    if (presentacion != null) {
      query = query.presentacion((q) => q.idEqualTo(presentacion.id));
    }

    if (estado == FiltroEstado.completados) {
      query = query.cantidadFisicaGreaterThan(0);
    } else if (estado == FiltroEstado.faltantes) {
      query = query.cantidadFisicaEqualTo(0);
    }

    // 3. Ordenamiento (Ahora los métodos sortBy siempre estarán disponibles)
    List<Producto> resultados;
    switch (orden) {
      case TipoOrdenamiento.alfabeticoAsc:
        resultados = await query.sortByDescripcion().findAll();
        break;
      case TipoOrdenamiento.alfabeticoDesc:
        resultados = await query.sortByDescripcionDesc().findAll();
        break;
      case TipoOrdenamiento.codigoAsc:
        resultados = await query.sortByCodigoBarras().findAll();
        break;
      case TipoOrdenamiento.codigoDesc:
        resultados = await query.sortByCodigoBarrasDesc().findAll();
        break;
      case TipoOrdenamiento.recientes:
        final listaAscendente = await query.findAll();
        resultados = listaAscendente.reversed.toList();
        break;
      case TipoOrdenamiento.antiguos:
        resultados = await query.findAll();
        break;
    }

    // 4. Carga de relaciones (Anti N+1)
    await Future.wait([
      ...resultados.map((p) => p.categoria.load()),
      ...resultados.map((p) => p.presentacion.load()),
    ]);

    return resultados;
  }
}
