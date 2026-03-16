import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CountBottomSheet extends StatefulWidget {
  final Producto producto;
  final VoidCallback onSaved;

  const CountBottomSheet({
    super.key,
    required this.producto,
    required this.onSaved,
  });

  @override
  State<CountBottomSheet> createState() => _CountBottomSheetState();
}

class _CountBottomSheetState extends State<CountBottomSheet> {
  late TextEditingController _mathController;
  int? _resultadoPrevisto;
  bool _modoResta = false;

  @override
  void initState() {
    super.initState();
    _mathController =
        TextEditingController(text: widget.producto.cantidadFisica.toString());
    _mathController.addListener(_actualizarPreview);
  }

  @override
  void dispose() {
    _mathController.removeListener(_actualizarPreview);
    _mathController.dispose();
    super.dispose();
  }

  int _evaluarMatematicas(String input) {
    try {
      String exp = input.toLowerCase().replaceAll('x', '*').replaceAll(' ', '');
      if (exp.isEmpty) return 0;

      if (exp.startsWith('-')) exp = '0$exp';
      exp = exp.replaceAll('-', '+-');

      List<String> sumandos = exp.split('+');
      int totalCalculado = 0;

      for (String sumando in sumandos) {
        if (sumando.isEmpty) continue;

        List<String> factores = sumando.split('*');
        int subtotal = 1;
        for (String factor in factores) {
          subtotal *= int.parse(factor);
        }
        totalCalculado += subtotal;
      }
      return totalCalculado;
    } catch (e) {
      return 0;
    }
  }

  void _actualizarPreview() {
    final texto = _mathController.text.trim();
    if (texto.isEmpty || int.tryParse(texto) != null) {
      if (_resultadoPrevisto != null) setState(() => _resultadoPrevisto = null);
      return;
    }

    final calc = _evaluarMatematicas(texto);
    if (_resultadoPrevisto != calc) {
      setState(() => _resultadoPrevisto = calc);
    }
  }

  void _sumarConBotonRapido(int cantidadExtra) {
    int totalActual = _evaluarMatematicas(_mathController.text);
    int cantidadReal = _modoResta ? -cantidadExtra : cantidadExtra;

    int nuevoTotal = totalActual + cantidadReal;
    if (nuevoTotal < 0) nuevoTotal = 0;

    _mathController.text = nuevoTotal.toString();
  }

  void _guardar() {
    int totalFinal =
        _resultadoPrevisto ?? _evaluarMatematicas(_mathController.text);
    widget.producto.cantidadFisica = totalFinal < 0 ? 0 : totalFinal;
    widget.onSaved();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // --- NUEVO: Lista dinámica de botones según el empaque ---
    List<Map<String, dynamic>> opcionesRapidas = [];

    switch (widget.producto.agrupacion) {
      case TipoAgrupacion.plancha24:
        opcionesRapidas = [
          {'label': '24', 'valor': 24},
          {'label': '6', 'valor': 6},
        ];
        break;
      case TipoAgrupacion.caja12:
        opcionesRapidas = [
          {'label': '12', 'valor': 12}
        ];
        break;
      case TipoAgrupacion.caja20:
        opcionesRapidas = [
          {'label': '20', 'valor': 20}
        ];
        break;
      case TipoAgrupacion.docena:
        opcionesRapidas = [
          {'label': '12', 'valor': 12},
          {
            'label': '6',
            'valor': 6
          }, // La media plancha también suele traer six
        ];
        break;
      case TipoAgrupacion.cigarros10:
        opcionesRapidas = [
          {'label': '10', 'valor': 10}
        ];
        break;
      case TipoAgrupacion.desconocido:
        opcionesRapidas = [];
        break;
    }

    String prefijo = _modoResta ? '-' : '+';
    Color colorBotones = _modoResta ? Colors.red.shade50 : Colors.green.shade50;
    Color colorTextoBotones =
        _modoResta ? Colors.red.shade900 : Colors.green.shade900;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.producto.descripcion,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _mathController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '0',
              hintStyle: TextStyle(color: Colors.grey.shade300),
            ),
            onTap: () => _mathController.selection = TextSelection(
              baseOffset: 0,
              extentOffset: _mathController.text.length,
            ),
          ),

          if (_resultadoPrevisto != null)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Text(
                '= $_resultadoPrevisto',
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),

          const Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sumar',
                  style: TextStyle(
                      color: _modoResta ? Colors.grey : Colors.green,
                      fontWeight: FontWeight.bold)),
              Switch(
                value: _modoResta,
                activeColor: Colors.red,
                activeTrackColor: Colors.red.shade200,
                inactiveThumbColor: Colors.green,
                inactiveTrackColor: Colors.green.shade200,
                onChanged: (val) {
                  setState(() {
                    _modoResta = val;
                  });
                },
              ),
              Text('Restar',
                  style: TextStyle(
                      color: _modoResta ? Colors.red : Colors.grey,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),

          // --- MODIFICADO: Uso de "Wrap" para que no marque error si hay muchos botones ---
          Wrap(
            spacing: 8.0, // Espacio horizontal entre botones
            runSpacing: 8.0, // Espacio vertical si saltan de línea
            alignment: WrapAlignment.center,
            children: [
              // Imprime todos los botones dinámicos (Plancha, Six, etc.)
              for (var opcion in opcionesRapidas)
                ElevatedButton.icon(
                  onPressed: () => _sumarConBotonRapido(opcion['valor']),
                  icon: Icon(
                    _modoResta ? Icons.remove : Icons.add,
                    color: colorTextoBotones,
                  ),
                  label: Text('${opcion['label']}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorBotones,
                    foregroundColor: colorTextoBotones,
                  ),
                ),

              // El botón de Sueltos siempre debe existir
              ElevatedButton.icon(
                onPressed: () => _sumarConBotonRapido(1),
                icon: Icon(_modoResta ? Icons.remove : Icons.add,
                    color: colorTextoBotones),
                label: Text('1'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorBotones,
                  foregroundColor: colorTextoBotones,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: _guardar,
              icon: const Icon(Icons.check_circle),
              label: const Text('Confirmar', style: TextStyle(fontSize: 16)),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
