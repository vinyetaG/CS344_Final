import 'package:flutter/material.dart';

///Name: Gerald Vinyeta
///Date: 12/14/2022
///Description: Describes the general appearance for material widgets in the app.
///Bugs: N/A
///Reflection: I feel like Flutter could make material state properties
///            easier to implement, but not too bad.
ThemeData appTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color.fromARGB(255, 93, 135, 95),
      secondary: const Color.fromARGB(255, 159, 191, 160),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0))),
            foregroundColor: MaterialStatePropertyAll(Colors.grey[200]))),
    textTheme: TextTheme(
        bodyMedium: const TextStyle(color: Colors.white, fontSize: 16),
        titleLarge: TextStyle(
            color: Colors.grey[800],
            fontSize: 28,
            fontWeight: FontWeight.bold)),
    checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((var states) {
      if (states.contains(MaterialState.selected)) {
        return appTheme.colorScheme.primary;
      }
      return null;
    })),
    scaffoldBackgroundColor: Colors.grey[800]);
