import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../models/category_model.dart';
import '../models/presentacion_model.dart';
import '../models/inventario_db.dart';

class CategorySettingsController extends ChangeNotifier {
  final InventarioDB _db = InventarioDB();

  List<Categoria> categorias = [];
  List<Presentacion> presentaciones = [];
  bool isLoading = true;

  CategorySettingsController() {
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    isLoading = true;
    notifyListeners();

    final isar = await _db.db;
    categorias = await isar.collection<Categoria>().where().findAll();
    presentaciones = await isar.collection<Presentacion>().where().findAll();

    isLoading = false;
    notifyListeners();
  }

  Future<void> crearCategoria(String nombre) async {
    if (nombre.trim().isEmpty)
      throw Exception('El nombre no puede estar vacío.');
    final isar = await _db.db;
    final nueva = Categoria.crear(nombre.trim());
    await isar.writeTxn(() => isar.collection<Categoria>().put(nueva));
    await cargarDatos();
  }

  // INTEGRACIÓN DE NUEVA LÓGICA: Soporta Tipo y Unidades separados
  Future<void> crearPresentacion(String tipo, int unidades) async {
    if (tipo.trim().isEmpty || unidades < 1)
      throw Exception('Datos de empaque inválidos.');
    final isar = await _db.db;
    final nueva = Presentacion.crear(tipo.trim(), unidades);
    await isar.writeTxn(() => isar.collection<Presentacion>().put(nueva));
    await cargarDatos();
  }

  Future<void> eliminarCategoria(Categoria cat) async {
    final isar = await _db.db;
    try {
      await isar.writeTxn(() => isar.collection<Categoria>().delete(cat.id));
      await cargarDatos();
    } catch (e) {
      throw Exception(
          'No se pudo eliminar la Familia. Puede que esté en uso por un producto.');
    }
  }

  Future<void> eliminarPresentacion(Presentacion pres) async {
    final isar = await _db.db;
    try {
      await isar
          .writeTxn(() => isar.collection<Presentacion>().delete(pres.id));
      await cargarDatos();
    } catch (e) {
      throw Exception(
          'No se pudo eliminar el Empaque. Puede que esté en uso por un producto.');
    }
  }

  // --- Lógica para Editar Familias (Categorías) ---
  Future<void> editarCategoria(Categoria categoria, String nuevoNombre) async {
    if (nuevoNombre.trim().isEmpty) {
      throw Exception('El nombre no puede estar vacío.');
    }

    final isar = await _db.db;

    // Actualizamos la propiedad del objeto existente
    categoria.nombre = nuevoNombre.trim();

    // Isar detecta el ID y actualiza el registro en lugar de crear uno nuevo
    await isar.writeTxn(() => isar.collection<Categoria>().put(categoria));

    await cargarDatos(); // Refresca la lista en la UI
  }

  // --- Lógica para Editar Empaques (Presentaciones) ---
  Future<void> editarPresentacion(
      Presentacion presentacion, String nuevoTipo, int nuevasUnidades) async {
    if (nuevoTipo.trim().isEmpty || nuevasUnidades < 1) {
      throw Exception('Datos de empaque inválidos.');
    }

    final isar = await _db.db;

    // Actualizamos las propiedades
    presentacion.tipo = nuevoTipo.trim();
    presentacion.unidades = nuevasUnidades;

    await isar
        .writeTxn(() => isar.collection<Presentacion>().put(presentacion));

    await cargarDatos(); // Refresca la lista en la UI
  }
}
