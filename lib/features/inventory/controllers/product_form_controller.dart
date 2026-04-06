// lib/features/inventory/controllers/product_form_controller.dart

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/presentacion_model.dart';
import '../models/inventario_db.dart';

class ProductFormController extends ChangeNotifier {
  final InventarioDB db;
  final Producto? productoAEditar;

  final formKey = GlobalKey<FormState>();

  late TextEditingController codigoController;
  late TextEditingController descripcionController;
  final TextEditingController catSearchController = TextEditingController();
  final TextEditingController presSearchController = TextEditingController();

  List<Categoria> categorias = [];
  List<Presentacion> presentaciones = [];

  Categoria? categoriaSeleccionada;
  Presentacion? presentacionSeleccionada;

  bool isLoading = true;
  bool _isSaving = false; // <-- CANDADO ATÓMICO: Previene el doble tap

  ProductFormController({required this.db, this.productoAEditar}) {
    codigoController =
        TextEditingController(text: productoAEditar?.codigoBarras ?? '');
    descripcionController =
        TextEditingController(text: productoAEditar?.descripcion ?? '');
    _cargarListas();
  }

  @override
  void dispose() {
    codigoController.dispose();
    descripcionController.dispose();
    catSearchController.dispose();
    presSearchController.dispose();
    super.dispose();
  }

  Future<void> _cargarListas() async {
    final isar = await db.db;
    categorias = await isar.collection<Categoria>().where().findAll();
    presentaciones = await isar.collection<Presentacion>().where().findAll();

    if (productoAEditar != null) {
      productoAEditar!.categoria.loadSync();
      productoAEditar!.presentacion.loadSync();
      categoriaSeleccionada = productoAEditar!.categoria.value;
      presentacionSeleccionada = productoAEditar!.presentacion.value;

      catSearchController.text = categoriaSeleccionada?.nombre ?? '';
      presSearchController.text = presentacionSeleccionada?.nombre ?? '';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> crearCategoriaAlVuelo(String nombre) async {
    final isar = await db.db;
    final nueva = Categoria.crear(nombre.trim());
    await isar.writeTxn(() => isar.collection<Categoria>().put(nueva));
    await _cargarListas();
    categoriaSeleccionada = nueva;
    catSearchController.text = nueva.nombre;
    notifyListeners();
  }

  void setCategoria(Categoria cat) {
    categoriaSeleccionada = cat;
    notifyListeners();
  }

  void setPresentacion(Presentacion pres) {
    presentacionSeleccionada = pres;
    notifyListeners();
  }

  // ==========================================================
  // MOTOR DE PARSEO INTELIGENTE (TEXTO -> DATOS ESTRUCTURADOS)
  // ==========================================================
  Map<String, dynamic> _parsearPresentacion(String texto) {
    final textoLimpio = texto.toLowerCase();

    // Casos especiales hardcodeados para UX
    if (textoLimpio.contains('six')) return {'tipo': 'Six', 'unidades': 6};
    if (textoLimpio.contains('docena'))
      return {'tipo': 'Docena', 'unidades': 12};

    // RegEx: Busca la primera palabra (letras) seguida de un número en cualquier parte.
    // Ej: "Caja de 24" -> group(1)="caja", group(2)="24"
    final match = RegExp(r'([a-záéíóúñ]+)[^\d]*(\d+)').firstMatch(textoLimpio);

    if (match != null && match.groupCount >= 2) {
      String tipo = match.group(1)!;
      tipo = tipo[0].toUpperCase() + tipo.substring(1); // Capitalizar
      return {'tipo': tipo, 'unidades': int.parse(match.group(2)!)};
    }

    // Fallback: Si no escribieron números (Ej: "Botella"), asumimos 1 unidad.
    final tipoLimpio = texto.trim();
    final tipoFinal = tipoLimpio.isNotEmpty
        ? tipoLimpio[0].toUpperCase() + tipoLimpio.substring(1).toLowerCase()
        : 'Unidad';

    return {'tipo': tipoFinal, 'unidades': 1};
  }

  Future<void> crearPresentacionAlVuelo(String nombreRaw) async {
    final isar = await db.db;
    final datos = _parsearPresentacion(nombreRaw);

    final nueva = Presentacion.crear(datos['tipo'], datos['unidades']);

    await isar.writeTxn(() => isar.collection<Presentacion>().put(nueva));
    await _cargarListas();
    presentacionSeleccionada = nueva;
    presSearchController.text = nueva.nombre;
    notifyListeners();
  }

  Future<bool> guardarProducto() async {
    if (!formKey.currentState!.validate()) return false;
    if (_isSaving) return false;
    _isSaving = true;

    try {
      final catText = catSearchController.text.trim();
      final presText = presSearchController.text.trim();

      if (catText.isEmpty || presText.isEmpty)
        throw Exception('Familia y Empaque son obligatorios.');

      categoriaSeleccionada = categorias.firstWhere(
        (c) => c.nombre.toLowerCase() == catText.toLowerCase(),
        orElse: () => Categoria.crear(catText),
      );

      // Conciliación con el nuevo motor de Parseo
      final datosPres = _parsearPresentacion(presText);
      presentacionSeleccionada = presentaciones.firstWhere(
        // Validamos buscando exactitud en tipo y unidades, no en el nombre raw
        (p) =>
            p.tipo.toLowerCase() ==
                datosPres['tipo'].toString().toLowerCase() &&
            p.unidades == datosPres['unidades'],
        orElse: () =>
            Presentacion.crear(datosPres['tipo'], datosPres['unidades']),
      );

      final producto = productoAEditar ?? Producto();
      producto.codigoBarras = codigoController.text.trim();
      producto.descripcion = descripcionController.text.trim().toUpperCase();

      final isar = await db.db;

      await isar.writeTxn(() async {
        if (categoriaSeleccionada!.id == Isar.autoIncrement) {
          await isar.collection<Categoria>().put(categoriaSeleccionada!);
        }
        if (presentacionSeleccionada!.id == Isar.autoIncrement) {
          await isar.collection<Presentacion>().put(presentacionSeleccionada!);
        }

        producto.categoria.value = categoriaSeleccionada;
        producto.presentacion.value = presentacionSeleccionada;

        await isar.collection<Producto>().put(producto);
        await producto.categoria.save();
        await producto.presentacion.save();
      });

      return true;
    } catch (e) {
      if (categoriaSeleccionada?.id == Isar.autoIncrement)
        categoriaSeleccionada = null;
      if (presentacionSeleccionada?.id == Isar.autoIncrement)
        presentacionSeleccionada = null;
      throw Exception('Error: Revisa los datos o el código de barras.');
    } finally {
      _isSaving = false;
    }
  }
}
