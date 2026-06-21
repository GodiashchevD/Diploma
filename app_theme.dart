import 'package:flutter/material.dart';

class AppTheme {

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F6F7),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF7ED7C1),
      secondary: Color(0xFF6FA8DC),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Color(0xFF2B2B2B),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF2B2B2B)),

      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Colors.transparent,
      iconTheme: WidgetStatePropertyAll(
        IconThemeData(color: Color(0xFF9AA0A6)),
      ),
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(color: Color(0xFF9AA0A6)),
      ),
    ),
  );


  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1E1F25),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF6A5AE0),
      secondary: Color(0xFFA66CFF),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Color(0xFFC9C6FF),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),

      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color(0xFF202127),
      indicatorColor: Colors.transparent,
      iconTheme: WidgetStatePropertyAll(
        IconThemeData(color: Color(0xFF7A7A85)),
      ),
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(color: Color(0xFF7A7A85)),
      ),
    ),
  );
}