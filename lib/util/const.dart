import 'package:flutter/material.dart';
class Constants{

  static String appName = "Tugas UAS";

  //Colors for theme
//  Color(0xfffcfcff);
  static Color? lightPrimary =  Colors.orange[600];
  static Color? darkPrimary = Colors.black;
  static Color? lightAccent =  Colors.orange[600];
  static Color? darkAccent = Colors.red[400];
  static Color? lightBG = Color(0xfffcfcff);
  static Color? darkBG = Colors.orange[600];
  static Color? ratingBG = Colors.yellow[600];

  static ThemeData lightTheme = ThemeData(
    backgroundColor: Color(0xfffcfcff),
    primaryColor: lightPrimary,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: lightAccent, //thereby
    ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: lightAccent),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: darkAccent, //thereby
    ),
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        headline5: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}