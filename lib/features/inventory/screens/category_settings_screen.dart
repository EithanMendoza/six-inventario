import 'package:flutter/material.dart';
import '../controllers/category_settings_controller.dart';
import '../widgets/setting_entry_dialog.dart';
import '../widgets/setting_list_tile.dart';

class CategorySettingsScreen extends StatefulWidget {
  const CategorySettingsScreen({super.key});

  @override
  State<CategorySettingsScreen> createState() => _CategorySettingsScreenState();
}

class _CategorySettingsScreenState extends State<CategorySettingsScreen> {
  late final CategorySettingsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CategorySettingsController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _mostrarDialogoNuevoElemento(
      BuildContext context, bool esCategoria) async {
    final resultado = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => SettingEntryDialog(esPresentacion: !esCategoria),
    );

    if (resultado != null && mounted) {
      try {
        if (esCategoria) {
          await _controller.crearCategoria(resultado['texto']);
        } else {
          // Utiliza los dos campos requeridos en la nueva implementación
          await _controller.crearPresentacion(
              resultado['texto'], resultado['unidades']);
        }
      } catch (e) {
        _mostrarError(e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  void _mostrarError(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ajustes de Catálogo'),
          bottom: const TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.black54,
            tabs: [
              Tab(icon: Icon(Icons.folder), text: 'Familias'),
              Tab(icon: Icon(Icons.inventory_2), text: 'Empaques'),
            ],
          ),
        ),
        body: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            if (_controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return TabBarView(
              children: [
                _buildListView(_controller.categorias, true),
                _buildListView(_controller.presentaciones, false),
              ],
            );
          },
        ),
        // El FAB detecta el índice de la pestaña sobre la marcha de forma eficiente
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () {
              final tabIndex = DefaultTabController.of(context).index;
              _mostrarDialogoNuevoElemento(context, tabIndex == 0);
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget _buildListView(List<dynamic> elementos, bool esCategoria) {
    if (elementos.isEmpty) {
      return Center(
          child: Text(
              'No hay ${esCategoria ? 'categorías' : 'empaques'} registrados.'));
    }

    return ListView.builder(
      itemCount: elementos.length,
      itemBuilder: (context, index) {
        final item = elementos[index];
        // Utilizamos el getter dinámico 'nombre' que configuramos en la refactorización del modelo de Presentación
        return SettingListTile(
          titulo: item.nombre,
          onDeleteConfirm: () async {
            try {
              if (esCategoria) {
                await _controller.eliminarCategoria(item);
              } else {
                await _controller.eliminarPresentacion(item);
              }
            } catch (e) {
              _mostrarError(e.toString().replaceAll('Exception: ', ''));
            }
          },
          onEdit: () async {
            final result = await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (context) => SettingEntryDialog(
                esPresentacion: !esCategoria,
                // Extrae los valores según el tipo de objeto
                valorInicialTexto: esCategoria ? item.nombre : item.tipo,
                valorInicialUnidades: esCategoria ? null : item.unidades,
              ),
            );

            if (result != null) {
              try {
                if (esCategoria) {
                  await _controller.editarCategoria(item, result['texto']);
                } else {
                  await _controller.editarPresentacion(
                      item, result['texto'], result['unidades']);
                }
              } catch (e) {
                _mostrarError(e.toString().replaceAll('Exception: ', ''));
              }
            }
          },
        );
      },
    );
  }
}
