import 'package:flutter/material.dart';

MaterialColor PrimaryMaterialColor = MaterialColor(
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
  radioTheme: RadioThemeData(
    fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
  ),
  fontFamily: "Roboto-Regular",
  primaryColor: Color(0xff111111),
  primarySwatch: PrimaryMaterialColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        Color(0xff111111),
      ),
    ),
  ),
);
