// lib/theme.dart

import 'package:flutter/material.dart';
import 'package:switch_app/constants/colors.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    primaryColor: Color.fromRGBO(190, 180, 249, 1),
    primaryColorLight: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    secondaryHeaderColor: Color.fromRGBO(193, 184, 245, 0.355),
    // iconTheme: IconThemeData(color: dark),
    splashColor: Color.fromRGBO(156, 141, 242, 1),
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Arial',
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
    appBarTheme: AppBarTheme(
      backgroundColor: bgColor,
      foregroundColor: bgColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, // Enable fill color for TextField
      fillColor: bgColor, // Set the fill color for TextField
      border: OutlineInputBorder(),
      // Set default border
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Color.fromRGBO(136, 84, 255, 1),
    splashColor: Color.fromRGBO(86, 51, 167, 1),
    secondaryHeaderColor: Color.fromARGB(149, 71, 70, 70),
    dividerColor: bgColor,
    scaffoldBackgroundColor: Colors.black,
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Arial',
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
    appBarTheme: AppBarTheme(
      backgroundColor: dark,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, // Enable fill color for TextField
      fillColor: dark, // Dark mode fill color for TextField
      border: OutlineInputBorder(), // Set default border
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),
  );

  // Default Container Color
  static Color defaultContainerColor(bool isDarkTheme) {
    return isDarkTheme
        ? Color.fromRGBO(108, 80, 115, 1)
        : secondaryColor; // Use light or dark container color
  }
}
