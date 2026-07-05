import 'package:flutter/material.dart';

class AppTheme {
  // Membaca tipe environment (DEV atau PROD) dari argumen kompilasi terminal
  static const String currentEnv = String.fromEnvironment('ENV_NAME', defaultValue: 'DEV');

  static ThemeData get themeData {
    if (currentEnv == 'PROD') {
      // 🌙 TEMA GELAP (Flavor PROD - Sesuai Gambar Detail Berita Premium)
      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1E3A8A),       
          secondary: Color(0xFFC2410C),     
          surface: Color(0xFF0F172A),       
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF1E293B),         // Warna Card saat Mode Gelap
          elevation: 0,
        ),
      );
    }

    // ☀️ TEMA TERANG (Flavor DEV - Sesuai Gambar Beranda Populer & Halaman Profil)
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF1E3A8A),       // Navy Blue untuk Teks / Brand Header
        secondary: const Color(0xFFC2410C),     // Orange untuk Tag Kategori (TEKNIK, OLAHRAGA)
        surface: Colors.grey.shade50,           // Background Beranda Bersih
        onSurface: const Color(0xFF0F172A),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1E3A8A),     // Judul Aplikasi Navy Blue
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 1,
      ),
    );
  }
}