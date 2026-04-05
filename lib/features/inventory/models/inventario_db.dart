// lib/features/inventory/models/inventario_db.dart

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'product_model.dart';
import 'category_model.dart';
import 'presentacion_model.dart';
import '../services/migration_service.dart';
import 'catalogo_inicial.dart';

class InventarioDB {
  static InventarioDB? _instanciaGlobal;
  late Future<Isar> db;

  factory InventarioDB() {
    _instanciaGlobal ??= InventarioDB._internal();
    return _instanciaGlobal!;
  }

  InventarioDB._internal() {
    db = openDB();
  }

  // Inicializa la Base de Datos
  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      final isar = await Isar.open(
        [
          ProductoSchema,
          CategoriaSchema,
          PresentacionSchema,
        ],
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

      // Ejecuta la división del enum viejo en Categorías y Presentaciones
      await MigrationService.migrarEstructuraCompleta(isar);

      return isar;
    }
    return Future.value(Isar.getInstance());
  }

  // ================= CRUD =================

  Future<List<Producto>> obtenerTodosLosProductos() async {
    final isar = await db;
    return await isar.productos.where().findAll();
  }

  Future<void> guardarProducto(Producto nuevoProducto) async {
    final isar = await db;
    await isar.writeTxn(() async {
      // Guarda los datos primitivos (incluyendo cantidadFisica y el nuevo conteoSistema)
      await isar.productos.put(nuevoProducto);

      // Guarda las relaciones estructurales
      await nuevoProducto.categoria.save();
      await nuevoProducto.presentacion.save();
    });
  }

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
