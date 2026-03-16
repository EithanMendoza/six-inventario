// lib/main.dart

import 'package:flutter/material.dart';
import 'package:six_inventario/core/main_layout.dart';
import 'core/app_theme.dart';

void main() {
  runApp(const AuditoriaApp());
}

class AuditoriaApp extends StatelessWidget {
  const AuditoriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auditoría Inventario',
      debugShowCheckedModeBanner: false,

      // Conectamos tu tema extraído
      theme: AppTheme.lightTheme,

      // Si algún día quieres modo oscuro, solo descomenta esta línea:
      // darkTheme: AppTheme.darkTheme,

      home: const MainLayout(),
    );
  }
}
