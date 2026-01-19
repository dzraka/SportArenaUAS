import 'package:final_project/presentation/auth/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF829683);
    const Color backgroundLight = Color(0xFFEFEFEF);
    const Color textDark = Color(0xFF2C2C2C);
    const Color surfaceWhite = Colors.white;

    return MaterialApp(
      title: 'SportArena',
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundLight,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          primary: primaryGreen,
          surface: backgroundLight,
          onSurface: textDark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundLight,
          foregroundColor: textDark,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: textDark,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
          iconTheme: IconThemeData(color: textDark),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
