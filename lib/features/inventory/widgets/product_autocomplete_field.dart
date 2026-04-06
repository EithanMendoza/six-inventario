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
      builder: (context, constraints) => RawAutocomplete<T>(
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
              labelText: widget.label,
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
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
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
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: constraints.maxWidth,
                constraints: const BoxConstraints(
                    maxHeight: 250), // Auditoría: Limita altura
                child: ListView.builder(
                  // Auditoría: Renderizado eficiente
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (showCreateOption && index == 0) {
                      return ListTile(
                        tileColor: Colors.white,
                        leading:
                            const Icon(Icons.add_circle, color: Colors.blue),
                        title: Text('Crear "${widget.controller.text}"'),
                        onTap: () {
                          widget.onCreate(widget.controller.text);
                          FocusScope.of(context).unfocus();
                        },
                      );
                    }

                    final optionIndex = showCreateOption ? index - 1 : index;
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
    );
  }
}
