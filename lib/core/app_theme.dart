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
        primary: colorPrimario,
        // Forzamos el rojo en los contenedores (afecta a FABs y botones)
        primaryContainer: colorPrimario,
        // Obligamos a que el texto/iconos sobre esos contenedores sea blanco
        onPrimaryContainer: Colors.white,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: colorPrimario,
        foregroundColor: Colors.white,
      ),
      // Esto es crucial: elimina el tinte rosado del fondo de los diálogos y tarjetas
      dialogTheme: const DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
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
