// lib/core/theme/theme.dart
import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeConfig {
  static ThemeData get theme => AppTheme.lightTheme;  // Ou AppTheme.darkTheme para o tema escuro

  // Caso queira adicionar mais lógicas como temas personalizados
  static ThemeData get customTheme {
    return ThemeData(
      primaryColor: Colors.orange,
      hintColor: Colors.pink,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.grey),
      ),
      // Adicione outras personalizações aqui, se necessário
    );
  }
}