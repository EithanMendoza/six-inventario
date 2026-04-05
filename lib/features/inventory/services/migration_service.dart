import 'package:isar/isar.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/presentacion_model.dart';

class MigrationService {
  static Future<void> migrarEstructuraCompleta(Isar isar) async {
    // CAMBIO: Acceso explícito a la colección
    final todosLosProductos =
        await isar.collection<Producto>().where().findAll();
    int registrosMigrados = 0;

    await isar.writeTxn(() async {
      for (final producto in todosLosProductos) {
        await producto.categoria.load();
        await producto.presentacion.load();

        if (producto.presentacion.value == null) {
          String nombreCat;
          String nombrePres;

          switch (producto.agrupacion) {
            case TipoAgrupacion.cigarros10:
              nombreCat = 'Cigarros';
              nombrePres = '10 pzas';
              break;
            case TipoAgrupacion.plancha24:
              nombreCat = 'Cervezas';
              nombrePres = 'Plancha 24';
              break;
            case TipoAgrupacion.caja12:
              nombreCat = 'Cervezas';
              nombrePres = 'Caja 12';
              break;
            case TipoAgrupacion.caja20:
              nombreCat = 'Cervezas';
              nombrePres = 'Caja 20';
              break;
            case TipoAgrupacion.docena:
              nombreCat = 'General';
              nombrePres = 'Docena';
              break;
            case TipoAgrupacion.desconocido:
            default:
              nombreCat = 'General';
              nombrePres = 'Unidad';
              break;
          }

          // CAMBIO: isar.collection<Categoria>()
          var categoriaDB = await isar
              .collection<Categoria>()
              .filter()
              .nombreEqualTo(nombreCat)
              .findFirst();
          if (categoriaDB == null) {
            categoriaDB = Categoria.crear(nombreCat);
            await isar.collection<Categoria>().put(categoriaDB);
          }

          // CAMBIO: isar.collection<Presentacion>()
          var presentacionDB = await isar
              .collection<Presentacion>()
              .filter()
              .nombreEqualTo(nombrePres)
              .findFirst();
          if (presentacionDB == null) {
            presentacionDB = Presentacion.crear(nombrePres);
            await isar.collection<Presentacion>().put(presentacionDB);
          }

          producto.categoria.value = categoriaDB;
          producto.presentacion.value = presentacionDB;
          await producto.categoria.save();
          await producto.presentacion.save();

          registrosMigrados++;
        }
      }
    });

    if (registrosMigrados > 0) {
      print(
          'Migración Estructural (v2): $registrosMigrados productos actualizados.');
    }
  }
}
