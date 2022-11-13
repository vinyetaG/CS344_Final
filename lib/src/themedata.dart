import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color.fromARGB(255, 93, 135, 95),
      secondary: const Color.fromARGB(255, 159, 191, 160),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            //rounded borders
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0))),
            foregroundColor: MaterialStatePropertyAll(Colors.grey[200]))),
    textTheme: const TextTheme(
        bodyText2: TextStyle(color: Colors.white, fontSize: 16)),
    checkboxTheme: const CheckboxThemeData(
        checkColor:
            MaterialStatePropertyAll(Color.fromARGB(255, 159, 191, 160))));
