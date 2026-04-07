// lib/features/mermas/controllers/mermas_controller.dart
import 'package:flutter/material.dart';
import '../models/item_merma.dart';
import '../../inventory/models/product_model.dart';

class MermasController extends ChangeNotifier {
  // Patrón Singleton para acceso global
  static final MermasController _instance = MermasController._internal();
  factory MermasController() => _instance;
  MermasController._internal();

  final List<ItemMerma> _listaMermas = [];

  // Exponer una copia inmutable para evitar modificaciones fuera del controlador
  List<ItemMerma> get listaMermas => List.unmodifiable(_listaMermas);

  void agregarMerma(Producto producto, int cantidad) {
    // Evitar duplicados: si ya existe, sumar la cantidad
    final index =
        _listaMermas.indexWhere((item) => item.producto.id == producto.id);
    if (index >= 0) {
      _listaMermas[index] = ItemMerma(
          producto: producto,
          cantidad: _listaMermas[index].cantidad + cantidad);
    } else {
      _listaMermas.add(ItemMerma(producto: producto, cantidad: cantidad));
    }
    notifyListeners();
  }

  void eliminarMerma(int index) {
    _listaMermas.removeAt(index);
    notifyListeners();
  }

  void limpiarLista() {
    _listaMermas.clear();
    notifyListeners();
  }

  void actualizarCantidad(int index, int nuevaCantidad) {
    if (nuevaCantidad <= 0) {
      eliminarMerma(index); // Si el usuario edita a 0, mejor lo eliminamos
    } else {
      final itemActual = _listaMermas[index];
      _listaMermas[index] = ItemMerma(
        producto: itemActual.producto,
        cantidad: nuevaCantidad,
      );
      notifyListeners();
    }
  }
}
