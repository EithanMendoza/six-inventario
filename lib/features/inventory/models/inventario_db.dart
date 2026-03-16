// lib/features/inventory/models/inventario_db.dart

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'product_model.dart';
import 'catalogo_inicial.dart';

class InventarioDB {
  late Future<Isar> db;

  InventarioDB() {
    db = openDB();
  }

  // Inicializa la Base de Datos
  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      final isar = await Isar.open(
        [ProductoSchema],
        directory: dir.path,
      );

      // --- LÓGICA DE AUTO-SEEDING ---
      // Si la tabla de productos está completamente vacía...
      if (await isar.productos.count() == 0) {
        final catalog = CatalogoInicial.obtenerDatos();

        // Escribimos toda la lista en la base de datos de golpe
        await isar.writeTxn(() async {
          await isar.productos.putAll(catalog);
        });
      }

      return isar;
    }
    return Future.value(Isar.getInstance());
  }

  // ================= CRUD =================

  // CREATE & UPDATE (Upsert)
  // Isar usa 'put' para ambos. Si el objeto ya tiene un ID, lo actualiza.
  Future<void> guardarProducto(Producto nuevoProducto) async {
    final isar = await db;
    // Las operaciones de escritura deben ir dentro de un writeTxn (transacción)
    await isar.writeTxn(() async {
      await isar.productos.put(nuevoProducto);
    });
  }

  // READ (Leer todos)
  Future<List<Producto>> obtenerTodosLosProductos() async {
    final isar = await db;
    // Devuelve todos los productos ordenados por descripción
    return await isar.productos.where().sortByDescripcion().findAll();
  }

  // READ (Buscar por código o texto)
  Future<List<Producto>> buscarProducto(String texto) async {
    final isar = await db;
    return await isar.productos
        .filter()
        .codigoBarrasContains(texto)
        .or()
        .descripcionContains(texto, caseSensitive: false)
        .findAll();
  }

  // DELETE (Eliminar por ID interno)
  Future<void> eliminarProducto(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.productos.delete(id);
    });
  }

  // EXTRA: Resetear todos los conteos físicos a 0
  Future<void> resetearConteos() async {
    final isar = await db;
    final productos = await obtenerTodosLosProductos();

    await isar.writeTxn(() async {
      for (var p in productos) {
        p.cantidadFisica = 0;
        await isar.productos.put(p);
      }
    });
  }
}
