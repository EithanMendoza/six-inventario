import 'package:isar/isar.dart';

part 'presentacion_model.g.dart';

@collection
class Presentacion {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String nombre; // "Plancha 24", "Caja 12", "Unidad"

  Presentacion();

  Presentacion.crear(this.nombre);
}
