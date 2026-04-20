// lib/features/inventory/widgets/product_autocomplete_field.dart

import 'package:flutter/material.dart';

class ProductAutocompleteField<T extends Object> extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final List<T> options;
  final String Function(T) getNombre;
  final Function(T) onSelected;
  final Function(String) onCreate;

  const ProductAutocompleteField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    required this.options,
    required this.getNombre,
    required this.onSelected,
    required this.onCreate,
  });

  @override
  State<ProductAutocompleteField<T>> createState() =>
      _ProductAutocompleteFieldState<T>();
}

class _ProductAutocompleteFieldState<T extends Object>
    extends State<ProductAutocompleteField<T>> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Etiqueta externa: Al sacarla del InputDecoration,
          // evitamos que Flutter cree un "techo" invisible demasiado alto.
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
            child: Text(
              widget.label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // 2. El Autocomplete con su caja física exacta
          RawAutocomplete<T>(
            optionsViewOpenDirection: OptionsViewOpenDirection.up,
            textEditingController: widget.controller,
            focusNode: _focusNode,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) return const Iterable.empty();
              return widget.options.where((option) => widget
                  .getNombre(option)
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase()));
            },
            displayStringForOption: widget.getNombre,
            fieldViewBuilder:
                (context, fieldController, focusNode, onFieldSubmitted) {
              return TextFormField(
                controller: fieldController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  // IMPORTANTE: Ya no usamos labelText aquí
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  prefixIcon: Icon(widget.icon, color: Colors.grey.shade600),
                  suffixIcon: widget.controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            widget.controller.clear();
                            setState(() {});
                          })
                      : null,
                  // Padding interno para que la caja gris se vea proporcional
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              );
            },
            optionsViewBuilder: (context, onSelectedInternal, optionsFound) {
              final optionsList = optionsFound.toList();
              final showCreateOption = !optionsList.any((o) =>
                  widget.getNombre(o).toLowerCase() ==
                  widget.controller.text.toLowerCase());

              final itemCount = optionsList.length + (showCreateOption ? 1 : 0);

              return Align(
                // 3. Alineación nativa: Se apoyará exactamente en el borde gris
                alignment: Alignment.bottomLeft,
                child: Material(
                  elevation: 6, // Sombra sutil para despegarlo del fondo
                  borderRadius: BorderRadius.circular(8),
                  clipBehavior: Clip.antiAlias, // Redondeo limpio
                  child: Container(
                    width: constraints.maxWidth,
                    color: Colors.white,
                    constraints: const BoxConstraints(maxHeight: 250),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        if (showCreateOption && index == 0) {
                          return ListTile(
                            tileColor: Colors.white,
                            leading: const Icon(Icons.add_circle,
                                color: Colors.blue),
                            title: Text('Crear "${widget.controller.text}"'),
                            onTap: () {
                              widget.onCreate(widget.controller.text);
                              FocusScope.of(context).unfocus();
                            },
                          );
                        }

                        final optionIndex =
                            showCreateOption ? index - 1 : index;
                        final option = optionsList[optionIndex];

                        return ListTile(
                          tileColor: Colors.white,
                          title: Text(widget.getNombre(option)),
                          onTap: () {
                            onSelectedInternal(option);
                            widget.onSelected(option);
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
