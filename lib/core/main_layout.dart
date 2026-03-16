import 'package:flutter/material.dart';

// Importa tus dos pantallas (ajusta las rutas exactas de tus carpetas)
import '../features/mermas/screens/mermas_screen.dart';
import '../features/inventory/screens/inventory_hub_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _indiceActual = 0;

  // Las pantallas que vivirán en la Bottom Bar
  final List<Widget> _pantallas = const [
    InventoryHubScreen(),
    MermasScreen(),
    // Aquí puedes meter el módulo de Entradas/Escaner en el futuro
  ];

  void _cambiarTab(int index) {
    setState(() {
      _indiceActual = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El IndexedStack mantiene el estado de las listas sin recargar la base de datos
      body: IndexedStack(
        index: _indiceActual,
        children: _pantallas,
      ),
      bottomNavigationBar: Container(
        // Le ponemos una línea superior súper fina y elegante en lugar de una sombra gruesa
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1.0),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _indiceActual,
          onTap: _cambiarTab,
          elevation:
              0, // Matamos la sombra por defecto para un look plano y moderno
          backgroundColor: Colors.white, // Toma el color del Container
          selectedItemColor: Theme.of(context)
              .colorScheme
              .primary, // Color de tu tema al seleccionar
          unselectedItemColor:
              Colors.grey.shade500, // Gris sobrio para los inactivos
          selectedFontSize: 12, // Letra pequeña y profesional
          unselectedFontSize: 12,
          type: BottomNavigationBarType
              .fixed, // Evita animaciones raras al hacer clic

          // Opcional: Si lo quieres ULTRA minimalista, cambia estos a false para quitar los textos
          showSelectedLabels: true,
          showUnselectedLabels: true,

          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.inventory_2_outlined, size: 24),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.inventory_2, size: 24),
              ),
              label: 'Productos',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.remove_shopping_cart_outlined, size: 24),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.remove_shopping_cart, size: 24),
              ),
              label: 'Mermas',
            ),
          ],
        ),
      ),
    );
  }
}
