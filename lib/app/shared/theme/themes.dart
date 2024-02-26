import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

part 'color_schemes.g.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.roboto().fontFamily,
  colorScheme: _lightColorScheme,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: _lightColorScheme.primary,
    foregroundColor: _lightColorScheme.background,
    iconTheme: IconThemeData(
      color: _lightColorScheme.background,
    ),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: _lightColorScheme.background,
    surfaceTintColor: _lightColorScheme.background,
  ),
  scaffoldBackgroundColor: Colors.white,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.resolveWith(
        (Set<MaterialState> states) => _lightColorScheme.background,
      ),
      // backgroundColor: MaterialStateProperty.resolveWith(
      //   (states) => _lightColorScheme.onPrimaryContainer,
      // ),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.roboto().fontFamily,
  colorScheme: _darkColorScheme,
  appBarTheme: const AppBarTheme(
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.resolveWith(
        (Set<MaterialState> states) => _darkColorScheme.onBackground,
      ),
      backgroundColor: MaterialStateProperty.resolveWith(
        (Set<MaterialState> states) => _darkColorScheme.onPrimary,
      ),
    ),
  ),
);
