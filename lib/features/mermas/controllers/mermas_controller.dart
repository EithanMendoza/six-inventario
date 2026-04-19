// lib/features/mermas/controllers/mermas_controller.dart
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../models/item_merma.dart';
import '../../inventory/models/product_model.dart';
import '../../inventory/models/inventario_db.dart';

class MermasController extends ChangeNotifier {
  static final MermasController _instance = MermasController._internal();
  factory MermasController() => _instance;

  MermasController._internal() {
    _cargarMermasDesdeDB(); // Carga inicial al instanciar
  }

  final InventarioDB _db = InventarioDB();
  List<ItemMerma> _listaMermas = [];

  // Exponer una copia inmutable para la vista
  List<ItemMerma> get listaMermas => List.unmodifiable(_listaMermas);

  Future<void> _cargarMermasDesdeDB() async {
    final isar = await _db.db;
    _listaMermas = await isar.itemMermas.where().findAll();

    // Importante: Cargar los vínculos de los productos para poder leer sus nombres y códigos
    for (var item in _listaMermas) {
      await item.producto.load();
    }
    notifyListeners();
  }

  Future<void> agregarMerma(Producto producto, int cantidad) async {
    final isar = await _db.db;

    await isar.writeTxn(() async {
      // Buscar si el producto ya está en el borrador de mermas
      final existente = await isar.itemMermas
          .filter()
          .producto((q) => q.idEqualTo(producto.id))
          .findFirst();

      if (existente != null) {
        existente.cantidad += cantidad;
        await isar.itemMermas.put(existente);
      } else {
        final nuevo = ItemMerma.crear(producto, cantidad);
        await isar.itemMermas.put(nuevo);
        await nuevo.producto.save();
      }
    });

    await _cargarMermasDesdeDB();
  }

  Future<void> actualizarCantidad(int index, int nuevaCantidad) async {
    if (nuevaCantidad <= 0) {
      await eliminarMerma(index); // Si edita a 0, lo borramos de la BD
    } else {
      final isar = await _db.db;
      final itemParaActualizar = _listaMermas[index];

      await isar.writeTxn(() async {
        itemParaActualizar.cantidad = nuevaCantidad;
        await isar.itemMermas
            .put(itemParaActualizar); // Actualizamos el registro en Isar
      });

      await _cargarMermasDesdeDB();
    }
  }

  Future<void> eliminarMerma(int index) async {
    final isar = await _db.db;
    final idParaEliminar = _listaMermas[index].id;

    await isar.writeTxn(() async {
      await isar.itemMermas.delete(idParaEliminar);
    });

    await _cargarMermasDesdeDB();
  }

  Future<void> limpiarLista() async {
    final isar = await _db.db;
    await isar.writeTxn(() async {
      await isar.itemMermas.clear(); // Vacía toda la tabla
    });

    await _cargarMermasDesdeDB();
  }
}
