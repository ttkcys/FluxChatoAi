import 'package:flutter/material.dart';

class Themes {
  static ThemeData themeData(
      {required bool isDarkTheme, required BuildContext context}) {
    return isDarkTheme
        ? ThemeData(
      scaffoldBackgroundColor: const Color(0xFF2E2E2E),
      primarySwatch: Colors.indigo,
      primaryColorDark: Colors.blue,
      dividerColor: Colors.white,
      disabledColor: Colors.grey,
      cardColor: const Color(0xFF363636),
      canvasColor: Colors.black12,
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        color: Color(0xFF363636),
      ),
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
        colorScheme: const ColorScheme.dark(),
      ),
    )
        : ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF0F0F0),
      primarySwatch: Colors.indigo,
      primaryColorDark: Colors.blue,
      dividerColor: Colors.black12,
      disabledColor: Colors.grey,
      cardColor: Colors.white,
      canvasColor: Colors.grey[50],
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        color: Colors.white,
      ),
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
        colorScheme: const ColorScheme.light(),
      ),
    );
  }
}
