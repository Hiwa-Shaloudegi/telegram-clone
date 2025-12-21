import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Telegram Colors
  static const Color primaryColorLight = Color(0xFF527DA3);
  static const Color primaryColorDark = Color(0xFF527DA3);

  static const Color scaffoldBgLight = Color(0xFFFFFFFF);
  static const Color scaffoldBgDark = Color(0xFF17212B);

  static const Color appbarBgLight = Color(0xFF527DA3);
  static const Color appbarBgDark = Color(0xFF17212B);

  // Text Styles
  static TextTheme get _textTheme => GoogleFonts.robotoTextTheme();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColorLight,
      scaffoldBackgroundColor: scaffoldBgLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: appbarBgLight,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColorLight,
        brightness: Brightness.light,
        surface: scaffoldBgLight,
      ),
      textTheme: _textTheme,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColorLight, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColorLight,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColorDark,
      scaffoldBackgroundColor: scaffoldBgDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: appbarBgDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColorDark,
        brightness: Brightness.dark,
        surface: scaffoldBgDark,
        onSurface: Colors.white,
      ),
      textTheme: _textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColorDark, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColorDark,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
