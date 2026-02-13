import 'package:flutter/material.dart';

class DesignTemas {
  // Cor ouro estilo Bitcoin
  static const ouro = Color(0xFFFFD700);

  static final ThemeData claro = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      iconTheme: const IconThemeData(color: Colors.black),
    ),
    colorScheme: ColorScheme.light(primary: ouro),
  );

  static final ThemeData escuro = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    colorScheme: ColorScheme.dark(primary: ouro),
  );
}
