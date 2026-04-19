// lib/features/mermas/models/item_merma.dart
import 'package:isar/isar.dart';
import '../../inventory/models/product_model.dart';

part 'item_merma.g.dart';

@collection
class ItemMerma {
  Id id = Isar.autoIncrement;

  // Creamos un vínculo hacia la colección de Productos
  final producto = IsarLink<Producto>();

  int cantidad;

  ItemMerma({required this.cantidad});

  // Constructor auxiliar para facilitar la creación
  ItemMerma.crear(Producto p, this.cantidad) {
    producto.value = p;
  }
}
