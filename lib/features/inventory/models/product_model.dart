import 'package:isar/isar.dart';

part 'product_model.g.dart';

enum TipoAgrupacion {
  cigarros10,
  plancha24,
  caja12,
  caja20,
  docena,
  desconocido
}

@collection // <-- ¡Esta es la palabra mágica que activa a Isar!
class Producto {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String codigoBarras;

  late String descripcion;

  @enumerated
  TipoAgrupacion agrupacion = TipoAgrupacion.desconocido;

  int cantidadFisica = 0;
}
