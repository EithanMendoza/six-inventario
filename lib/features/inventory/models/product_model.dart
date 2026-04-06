// lib/features/inventory/models/product_model.dart
import 'package:isar/isar.dart';
import 'category_model.dart';
import 'presentacion_model.dart';

part 'product_model.g.dart';

@Deprecated(r'Migracion legacy')
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

  @Index(unique: true, replace: true)
  late String codigoBarras;

  // Eliminamos IndexType.words para resolver el error "Member not found"
  @Index()
  late String descripcion;

  @Deprecated(r'Campo en proceso de migracion')
  @enumerated
  TipoAgrupacion agrupacion = TipoAgrupacion.desconocido;

  final categoria = IsarLink<Categoria>();
  final presentacion = IsarLink<Presentacion>();

  int cantidadFisica = 0;
  int conteoSistema = 0;

  Producto();
}
