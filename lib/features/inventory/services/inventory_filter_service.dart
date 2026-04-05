// lib/features/inventory/services/inventory_filter_service.dart

import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/presentacion_model.dart';
import '../models/filtros_model.dart';

class InventoryFilterService {
  static List<Producto> ejecutarPipeline({
    required List<Producto> catalogoBase,
    String busqueda = '',
    Categoria? categoria,
    Presentacion? presentacion,
    FiltroEstado estado = FiltroEstado.todos,
    TipoOrdenamiento orden = TipoOrdenamiento.alfabeticoAsc,
  }) {
    // 1. Clonamos la lista base para evitar mutaciones accidentales
    var resultado = catalogoBase.toList();

    // 2. Filtro de Categoría (Dimensión principal)
    if (categoria != null) {
      resultado = resultado
          .where((p) => p.categoria.value?.id == categoria.id)
          .toList();
    }

    // 3. Filtro de Presentación (Sub-dimensión)
    if (presentacion != null) {
      resultado = resultado
          .where((p) => p.presentacion.value?.id == presentacion.id)
          .toList();
    }

    // 4. Filtro de Búsqueda de texto
    if (busqueda.isNotEmpty) {
      final b = busqueda.toLowerCase();
      resultado = resultado.where((p) {
        return p.descripcion.toLowerCase().contains(b) ||
            p.codigoBarras.contains(b);
      }).toList();
    }

    // 5. Filtro de Estado Físico
    if (estado == FiltroEstado.completados) {
      resultado = resultado.where((p) => p.cantidadFisica > 0).toList();
    } else if (estado == FiltroEstado.faltantes) {
      resultado = resultado.where((p) => p.cantidadFisica == 0).toList();
    }

    // 6. Motor de Ordenamiento Final
    resultado.sort((a, b) {
      switch (orden) {
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

    return resultado;
  }
}
