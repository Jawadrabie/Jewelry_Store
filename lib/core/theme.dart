import 'package:flutter/material.dart';

// class AppTheme {
//   static ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: Colors.blue,
//       brightness: Brightness.light,
//     ),
//     useMaterial3: true,
//   );
//
//   static ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: Colors.blue,
//       brightness: Brightness.dark,
//     ),
//     useMaterial3: true,
//   );
// }

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.teal,
    colorScheme: ColorScheme.light(
      primary: Colors.teal,
      secondary: Colors.tealAccent,
      surface: Colors.white,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
    colorScheme: ColorScheme.dark(
      primary: Colors.teal,
      secondary: Colors.tealAccent,
      surface: Colors.grey[800]!,
    ),
  );
}
