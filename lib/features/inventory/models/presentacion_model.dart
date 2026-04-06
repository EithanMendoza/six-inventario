import 'package:isar/isar.dart';

part 'presentacion_model.g.dart';

@collection
class Presentacion {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String tipo; // Ej: "Caja", "Plancha", "Paquete"

  late int unidades; // Ej: 24, 12, 1

  // @ignore evita que Isar intente guardar este campo en la base de datos.
  // Se calcula al vuelo para la interfaz gráfica.
  @ignore
  String get nombre => unidades > 1 ? '$tipo $unidades' : tipo;

  Presentacion();

  Presentacion.crear(this.tipo, this.unidades);
}
