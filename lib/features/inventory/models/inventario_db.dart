// lib/features/inventory/models/inventario_db.dart

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../mermas/models/item_merma.dart';
import 'product_model.dart';
import 'category_model.dart';
import 'presentacion_model.dart';
import '../services/migration_service.dart';
import 'catalogo_inicial.dart';

class InventarioDB {
  static InventarioDB? _instanciaGlobal;

  // AUDITORÍA 2: Singleton Asíncrono Seguro
  static Future<Isar>? _dbFuture;

  factory InventarioDB() {
    _instanciaGlobal ??= InventarioDB._internal();
    return _instanciaGlobal!;
  }

  InventarioDB._internal();

  // Getter seguro que garantiza una única inicialización
  Future<Isar> get db {
    _dbFuture ??= _openDB();
    return _dbFuture!;
  }

  Future<Isar> _openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      final isar = await Isar.open(
        [
          ProductoSchema,
          CategoriaSchema,
          PresentacionSchema,
          ItemMermaSchema,
        ],
        directory: dir.path,
      );

      // AUDITORÍA 1: Prevención del "Bucle de Resurrección"
      // Solo hace auto-seeding si la base de datos está COMPLETAMENTE virgen.
      final productosVaciados = await isar.productos.count() == 0;
      final categoriasVaciadas =
          await isar.collection<Categoria>().count() == 0;

      if (productosVaciados && categoriasVaciadas) {
        final catalog = CatalogoInicial.obtenerDatos();
        await isar.writeTxn(() async {
          await isar.productos.putAll(catalog);
        });
      }

      // Ejecuta la migración siempre al arrancar.
      // El script ya está optimizado para abortar rápido si no hay nada que migrar.
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
      await isar.productos.put(nuevoProducto);
      // Guarda las relaciones si existen
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

  Future<void> eliminarProducto(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.productos.delete(id);
    });
  }

// AUDITORÍA ACEPTADA: Reseteo de Alta Velocidad con Batch Automático
  Future<void> resetearConteos() async {
    final isar = await db;

    await isar.writeTxn(() async {
      // Bloqueamos la tabla de lectura temporalmente
      final productos = await isar.productos.where().findAll();

      // Modificación ultrarrápida en RAM
      for (var p in productos) {
        p.cantidadFisica = 0;
      }

      // Escritura atómica en disco (Batch)
      await isar.productos.putAll(productos);
    });
  }
}
