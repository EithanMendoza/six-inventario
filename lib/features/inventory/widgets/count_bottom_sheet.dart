//lib/features/inventory/widgets/count_bottom_sheet.dart
import 'package:flutter/material.dart';
import '../models/product_model.dart';

enum TipoConteo { fisico, sistema }

class CountBottomSheet extends StatefulWidget {
  final Producto producto;
  final TipoConteo tipo;
  final VoidCallback onSaved;

  const CountBottomSheet({
    super.key,
    required this.producto,
    required this.tipo,
    required this.onSaved,
  });

  @override
  State<CountBottomSheet> createState() => _CountBottomSheetState();
}

class _CountBottomSheetState extends State<CountBottomSheet> {
  late TextEditingController _mathController;
  int? _resultadoPrevisto;
  bool _modoResta = false;
  bool _cargandoPresentacion = true;

  @override
  void initState() {
    super.initState();

    //leer la propiedad correcta según el tipo de conteo
    int valorInicial = widget.tipo == TipoConteo.fisico
        ? widget.producto.cantidadFisica
        : widget.producto.conteoSistema;
    _mathController = TextEditingController(text: valorInicial.toString());
    _mathController.addListener(_actualizarPreview);

    //Carga asíncrona que no bloque el hilo principal
    _cargaPresentacionAsincrona();
  }

  Future<void> _cargaPresentacionAsincrona() async {
    if (!widget.producto.presentacion.isLoaded) {
      await widget.producto.presentacion.load();
      if (mounted) {
        setState(() {
          _cargandoPresentacion = false;
        });
      }
    }
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

  void _guardar() async {
    int totalFinal =
        _resultadoPrevisto ?? _evaluarMatematicas(_mathController.text);
    if (totalFinal < 0) totalFinal = 0;

    // Guardamos el resultado en la propiedad correcta según el tipo de conteo
    if (widget.tipo == TipoConteo.fisico) {
      widget.producto.cantidadFisica = totalFinal;
    } else {
      widget.producto.conteoSistema = totalFinal;
    }

    // Extraemos el callback a una variable local antes de destruir el widget
    final funcionGuardado = widget.onSaved;

    // Cerramos el Modal inmediatamente para una UX más fluida
    Navigator.pop(context);

    // Le damos tiempo a Flutter para procesar los frames del renderizado
    await Future.delayed(const Duration(milliseconds: 300), () {
      funcionGuardado();
    });
  }

  // 1. Generador Dinámico de Opciones
  List<Map<String, dynamic>> _obtenerOpcionesRapidas() {
    // Programación Defensiva: Fuerza la carga de RAM si no está disponible.
    if (!widget.producto.presentacion.isLoaded) {
      widget.producto.presentacion.loadSync();
    }

    final presentacion = widget.producto.presentacion.value;
    final opciones = <Map<String, dynamic>>[];

    if (presentacion != null && presentacion.unidades > 1) {
      // 1. Botón Principal (Ej. "Plancha 24")
      opciones
          .add({'label': presentacion.nombre, 'valor': presentacion.unidades});

      // 2. Generación automática de botón fraccionado inteligente (Sugerido UX)
      // Si el empaque es par y mayor a 6, sugerimos la mitad (Ej. Caja 24 -> 12 uds)
      if (presentacion.unidades % 2 == 0 && presentacion.unidades >= 12) {
        opciones.add({
          'label': '${presentacion.unidades ~/ 2} uds',
          'valor': presentacion.unidades ~/ 2
        });
      }
    }
    return opciones;
  }

  @override
  Widget build(BuildContext context) {
    String prefijo = _modoResta ? '-' : '+';
    Color colorBotones = _modoResta ? Colors.red.shade50 : Colors.green.shade50;
    Color colorTextoBotones =
        _modoResta ? Colors.red.shade900 : Colors.green.shade900;

    //Titulo dinámico según el tipo de conteo
    String titulo = widget.tipo == TipoConteo.fisico
        ? 'Conteo Físico'
        : 'Conteo en Sistema';

    return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(titulo,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              Text(
                widget.producto.descripcion,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: [
                  ..._obtenerOpcionesRapidas()
                      .map((opcion) => ElevatedButton.icon(
                            onPressed: () =>
                                _sumarConBotonRapido(opcion['valor']),
                            icon: Icon(
                              _modoResta ? Icons.remove : Icons.add,
                              color: colorTextoBotones,
                            ),
                            label: Text('${opcion['valor']}'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorBotones,
                              foregroundColor: colorTextoBotones,
                            ),
                          )),
                  ElevatedButton.icon(
                    onPressed: () => _sumarConBotonRapido(1),
                    icon: Icon(_modoResta ? Icons.remove : Icons.add,
                        color: colorTextoBotones),
                    label: const Text('1'),
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
                  label:
                      const Text('Confirmar', style: TextStyle(fontSize: 16)),
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
        ));
  }
}
