// lib/features/inventory/screens/category_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../models/category_model.dart';
import '../models/presentacion_model.dart';
import '../models/inventario_db.dart';

class CategorySettingsScreen extends StatefulWidget {
  const CategorySettingsScreen({super.key});

  @override
  State<CategorySettingsScreen> createState() => _CategorySettingsScreenState();
}

class _CategorySettingsScreenState extends State<CategorySettingsScreen> {
  final InventarioDB _db = InventarioDB();

  List<Categoria> _categorias = [];
  List<Presentacion> _presentaciones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  // PASO 1: Carga simultánea de ambas dimensiones
  Future<void> _cargarDatos() async {
    final isar = await _db.db;
    final cats = await isar.collection<Categoria>().where().findAll();
    final pres = await isar.collection<Presentacion>().where().findAll();

    setState(() {
      _categorias = cats;
      _presentaciones = pres;
      _isLoading = false;
    });
  }

// PASO 3: Método Unificado con Reglas de Negocio Estrictas
  Future<void> _agregarElemento(String nombreBruto, bool esCategoria) async {
    final nombreLimpio = nombreBruto.trim();
    if (nombreLimpio.isEmpty) return;

    final existeDuplicado = esCategoria
        ? _categorias
            .any((c) => c.nombre.toLowerCase() == nombreLimpio.toLowerCase())
        : _presentaciones
            .any((p) => p.nombre.toLowerCase() == nombreLimpio.toLowerCase());

    if (existeDuplicado) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Este elemento ya existe en el catálogo.'),
              backgroundColor: Colors.orange),
        );
      }
      return;
    }

    final isar = await _db.db;

    await isar.writeTxn(() async {
      if (esCategoria) {
        // CORREGIDO: Acceso explícito a la colección
        await isar.collection<Categoria>().put(Categoria.crear(nombreLimpio));
      } else {
        // CORREGIDO: Acceso explícito a la colección
        await isar
            .collection<Presentacion>()
            .put(Presentacion.crear(nombreLimpio));
      }
    });

    _cargarDatos();
  }

  // Eliminación unificada
  Future<void> _eliminarElemento(int id, bool esCategoria) async {
    final isar = await _db.db;
    await isar.writeTxn(() async {
      if (esCategoria) {
        // CORREGIDO: Acceso explícito a la colección
        await isar.collection<Categoria>().delete(id);
      } else {
        // CORREGIDO: Acceso explícito a la colección
        await isar.collection<Presentacion>().delete(id);
      }
    });
    _cargarDatos();
  }

  void _mostrarDialogoNuevoElemento(bool esCategoria) {
    final controller = TextEditingController();
    final tipo = esCategoria ? 'Categoría' : 'Empaque';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nuevo $tipo'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: esCategoria
                ? 'Ej. Abarrotes, Limpieza...'
                : 'Ej. Plancha 24, Unidad...',
          ),
          textCapitalization: TextCapitalization.words,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _agregarElemento(controller.text, esCategoria);
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminacion(dynamic elemento, bool esCategoria) {
    final tipo = esCategoria ? 'Categoría' : 'Empaque';
    final nombre = elemento.nombre;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar $tipo'),
        content: Text(
            '¿Estás seguro de que deseas eliminar "$nombre"? Los productos asociados se quedarán sin este valor en sus registros.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _eliminarElemento(elemento.id, esCategoria);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // PASO 2: Envoltura DefaultTabController
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Catálogo del Sistema'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Familias', icon: Icon(Icons.folder)),
              Tab(text: 'Empaques', icon: Icon(Icons.inventory_2)),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildListView(_categorias, true),
                  _buildListView(_presentaciones, false),
                ],
              ),
        // El FAB detecta en qué pestaña estamos para saber qué crear
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              final tabIndex = DefaultTabController.of(context).index;
              _mostrarDialogoNuevoElemento(tabIndex == 0);
            },
            child: const Icon(Icons.add),
          );
        }),
      ),
    );
  }

  // PASO 4: Constructor genérico de listas
  Widget _buildListView(List<dynamic> elementos, bool esCategoria) {
    if (elementos.isEmpty) {
      final tipo = esCategoria ? 'categorías' : 'empaques';
      return Center(child: Text('No hay $tipo registrados.'));
    }

    return ListView.builder(
      itemCount: elementos.length,
      itemBuilder: (context, index) {
        final item = elementos[index];
        return ListTile(
          leading: Icon(esCategoria ? Icons.folder : Icons.inventory_2,
              color: Colors.grey.shade700),
          title: Text(item.nombre),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmarEliminacion(item, esCategoria),
          ),
        );
      },
    );
  }
}
