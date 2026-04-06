import 'package:flutter/material.dart';

class SettingEntryDialog extends StatefulWidget {
  final bool esPresentacion;
  // Parámetros opcionales para la edición
  final String? valorInicialTexto;
  final int? valorInicialUnidades;

  const SettingEntryDialog({
    super.key,
    required this.esPresentacion,
    this.valorInicialTexto,
    this.valorInicialUnidades,
  });

  @override
  State<SettingEntryDialog> createState() => _SettingEntryDialogState();
}

class _SettingEntryDialogState extends State<SettingEntryDialog> {
  final _textoController = TextEditingController();
  final _unidadesController = TextEditingController(text: '1');

  // Propiedad computada para saber si estamos editando
  bool get _esEdicion => widget.valorInicialTexto != null;

  @override
  void initState() {
    super.initState();
    // Si pasamos valores iniciales, llenamos los controladores
    if (widget.valorInicialTexto != null) {
      _textoController.text = widget.valorInicialTexto!;
    }
    if (widget.valorInicialUnidades != null) {
      _unidadesController.text = widget.valorInicialUnidades.toString();
    }
  }

  @override
  void dispose() {
    _textoController.dispose();
    _unidadesController.dispose();
    super.dispose();
  }

  void _submit() {
    final texto = _textoController.text.trim();
    if (texto.isEmpty) return;

    final unidades = int.tryParse(_unidadesController.text.trim()) ?? 1;

    // Retorna los datos exactamente igual que antes
    Navigator.pop(context, {'texto': texto, 'unidades': unidades});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Cambiamos el título dinámicamente según si es edición o creación
      title: Text(widget.esPresentacion
          ? (_esEdicion ? 'Editar Empaque' : 'Nuevo Empaque')
          : (_esEdicion ? 'Editar Familia' : 'Nueva Familia')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textoController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText:
                  widget.esPresentacion ? 'Tipo (Ej: Caja, Plancha)' : 'Nombre',
              border: const OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          if (widget.esPresentacion) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _unidadesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Unidades por empaque',
                border: OutlineInputBorder(),
              ),
            ),
          ]
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _submit,
          // Cambiamos el texto del botón si quieres ser más específico
          child: Text(_esEdicion ? 'Actualizar' : 'Guardar'),
        ),
      ],
    );
  }
}
