import 'package:flutter/material.dart';

MaterialColor primaryMaterialColor = const MaterialColor(
  4279308561,
  <int, Color>{
    50: Color.fromRGBO(
      17,
      17,
      17,
      .1,
    ),
    100: Color.fromRGBO(
      17,
      17,
      17,
      .2,
    ),
    200: Color.fromRGBO(
      17,
      17,
      17,
      .3,
    ),
    300: Color.fromRGBO(
      17,
      17,
      17,
      .4,
    ),
    400: Color.fromRGBO(
      17,
      17,
      17,
      .5,
    ),
    500: Color.fromRGBO(
      17,
      17,
      17,
      .6,
    ),
    600: Color.fromRGBO(
      17,
      17,
      17,
      .7,
    ),
    700: Color.fromRGBO(
      17,
      17,
      17,
      .8,
    ),
    800: Color.fromRGBO(
      17,
      17,
      17,
      .9,
    ),
    900: Color.fromRGBO(
      17,
      17,
      17,
      1,
    ),
  },
);

ThemeData myTheme = ThemeData(
  fontFamily: "customFont",
  primaryColor: const Color(0xff111111),
  primarySwatch: primaryMaterialColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        const Color(0xff111111),
      ),
    ),
  ),
);
