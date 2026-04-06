import 'package:flutter/material.dart';

class SettingListTile extends StatelessWidget {
  final String titulo;
  final VoidCallback onDeleteConfirm;
  final VoidCallback onEdit; // 1. Agregamos el callback para la edición

  const SettingListTile({
    super.key,
    required this.titulo,
    required this.onDeleteConfirm,
    required this.onEdit, // Lo pedimos en el constructor
  });

  Future<void> _mostrarConfirmacion(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text('¿Estás seguro de que deseas eliminar "$titulo"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      onDeleteConfirm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colorScheme.outlineVariant.withOpacity(0.4),
              width: 1,
            ),
          ),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          title: Text(
            titulo,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          trailing: PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Opciones',
            onSelected: (value) {
              if (value == 0) {
                onEdit();
              } else if (value == 1) {
                _mostrarConfirmacion(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, color: Colors.blueAccent),
                    SizedBox(width: 12),
                    Text(
                      'Editar',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: colorScheme.error),
                    const SizedBox(width: 12),
                    Text('Eliminar',
                        style: TextStyle(color: colorScheme.error)),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
