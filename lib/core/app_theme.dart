// lib/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  static const Color colorPrimario = Color(0xFFE2211C);

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: colorPrimario,
        brightness: Brightness.light,
      ).copyWith(
        primary: colorPrimario, // ¡Aquí obligamos a usar el rojo exacto puro!
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor:
            colorPrimario, // Obligamos a que la barra superior sea rojo fuerte
        foregroundColor:
            Colors.white, // Obligamos a que el texto e iconos sean blancos
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: colorPrimario,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }
}
