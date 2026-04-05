import 'package:isar/isar.dart';
import 'category_model.dart';
import 'presentacion_model.dart';

part 'product_model.g.dart';

@Deprecated('Mantenido estrictamente para migración de datos legacy')
enum TipoAgrupacion {
  cigarros10,
  plancha24,
  caja12,
  caja20,
  docena,
  desconocido
}

@collection
class Producto {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String codigoBarras;

  late String descripcion;

  @Deprecated('Campo en proceso de migración.')
  @enumerated
  TipoAgrupacion agrupacion = TipoAgrupacion.desconocido;

  final categoria = IsarLink<Categoria>();
  final presentacion = IsarLink<Presentacion>();

  // CONTEOS
  int cantidadFisica = 0;
  int conteoSistema = 0;
}
