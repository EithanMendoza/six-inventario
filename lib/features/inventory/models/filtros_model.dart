// lib/features/inventory/models/filtros_model.dart

enum FiltroEstado {
  todos,
  completados, // Ya se contaron (cantidadFisica > 0)
  faltantes // No se han contado (cantidadFisica == 0)
}

enum TipoOrdenamiento {
  alfabeticoAsc, // A - Z
  alfabeticoDesc, // Z - A
  codigoAsc, // 0 - 9 (Por código de barras)
  codigoDesc // 9 - 0 (Por código de barras)
}

// ELIMINADO: enum FiltroCategoria { todas, cervezas, cigarros }
