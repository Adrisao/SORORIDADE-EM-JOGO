
import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import 'pallet.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sororidade em Jogo',
      theme: tema(),
      home: const HomePage(),
    );
  }
}

// Tema do app montado a partir da paleta
ThemeData tema() {
  final esquema = ColorScheme.fromSeed(
    seedColor: Pallet.rosaMagenta,
  ).copyWith(
    primary: Pallet.rosaMagenta,
    onPrimary: Pallet.branco,
    secondary: Pallet.verdeAgua,
    onSecondary: Pallet.branco,
    tertiary: Pallet.roxoAmeixa,
    surface: Pallet.branco,
    onSurface: Pallet.textoEscuro,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: esquema,
    fontFamily: Pallet.fonte,
  );

  return base.copyWith(
    scaffoldBackgroundColor: Pallet.creme,
    textTheme: base.textTheme.apply(
      bodyColor: Pallet.textoEscuro,
      displayColor: Pallet.roxoAmeixa,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallet.rosaMagenta,
      foregroundColor: Pallet.branco,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: Pallet.fonte,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Pallet.branco,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallet.rosaMagenta,
        foregroundColor: Pallet.branco,
        disabledBackgroundColor: Pallet.lavanda,
        disabledForegroundColor: Pallet.roxoLogo,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontFamily: Pallet.fonte,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Pallet.roxoAmeixa,
        side: const BorderSide(color: Pallet.roxoAmeixa, width: 2),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontFamily: Pallet.fonte,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: Pallet.branco,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Pallet.verdeAgua,
      linearTrackColor: Pallet.lavanda,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Pallet.creme,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}
