import 'package:isar/isar.dart';

part 'category_model.g.dart';

@collection
class Categoria {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String nombre;

  // Constructor para facilitar la creación
  Categoria();
  
  Categoria.crear(this.nombre);
}