// lib/features/inventory/services/migration_service.dart

import 'package:isar/isar.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/presentacion_model.dart';

class MigrationService {
  static Future<void> migrarEstructuraCompleta(Isar isar) async {
    final todosLosProductos =
        await isar.collection<Producto>().where().findAll();
    if (todosLosProductos.isEmpty) return;

    // 1. CARGA PREVENTIVA (Fuera de la transacción de escritura)
    // Usamos loadSync() aquí porque no hay ninguna transacción activa.
    for (final p in todosLosProductos) {
      p.presentacion.loadSync();
      p.categoria.loadSync();
    }

    // 2. PRE-CACHE O(1)
    final categoriasExistentes = {
      for (var c in await isar.collection<Categoria>().where().findAll())
        c.nombre: c
    };
    final presentacionesExistentes = {
      for (var p in await isar.collection<Presentacion>().where().findAll())
        p.nombre: p
    };

    int registrosMigrados = 0;

    // 3. ÚNICA TRANSACCIÓN DE ESCRITURA
    await isar.writeTxn(() async {
      for (final producto in todosLosProductos) {
        // Ahora el .value ya está en memoria gracias al paso 1
        if (producto.presentacion.value == null) {
          String nombreCat;
          String tipoPres;
          int unidadesPres = 1;

          switch (producto.agrupacion) {
            case TipoAgrupacion.cigarros10:
              nombreCat = 'Cigarros';
              tipoPres = 'Cigarros';
              unidadesPres = 10;
              break;
            case TipoAgrupacion.plancha24:
              nombreCat = 'Cervezas';
              tipoPres = 'Plancha';
              unidadesPres = 24;
              break;
            case TipoAgrupacion.caja12:
              nombreCat = 'Cervezas';
              tipoPres = 'Caja';
              unidadesPres = 12;
              break;
            case TipoAgrupacion.caja20:
              nombreCat = 'Cervezas';
              tipoPres = 'Caja';
              unidadesPres = 20;
              break;
            case TipoAgrupacion.docena:
              nombreCat = 'General';
              tipoPres = 'Docena';
              unidadesPres = 12;
              break;
            default:
              nombreCat = 'General';
              tipoPres = 'Unidad';
              unidadesPres = 1;
          }

          // Conciliación en RAM
          Categoria categoria =
              categoriasExistentes[nombreCat] ??= Categoria.crear(nombreCat);
          if (categoria.id == Isar.autoIncrement) {
            await isar.collection<Categoria>().put(categoria);
          }

          String nombreCalculado =
              unidadesPres > 1 ? '$tipoPres $unidadesPres' : tipoPres;
          Presentacion presentacion =
              presentacionesExistentes[nombreCalculado] ??=
                  Presentacion.crear(tipoPres, unidadesPres);

          if (presentacion.id == Isar.autoIncrement) {
            await isar.collection<Presentacion>().put(presentacion);
          }

          // Vinculación y persistencia
          producto.categoria.value = categoria;
          producto.presentacion.value = presentacion;

          await isar.collection<Producto>().put(producto);
          await producto.categoria.save();
          await producto.presentacion.save();

          registrosMigrados++;
        }
      }
    });

    if (registrosMigrados > 0) {
      print(
          'Auditoría: $registrosMigrados productos migrados sin colisión de transacciones.');
    }
  }
}
