import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  // 1. Memastikan seluruh binding framework Flutter siap sebelum proses inisialisasi async
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Menjalankan Dependency Injection (Membuka Isar DB & HTTP Client otomatis)
  await setupLocator();

  // 3. Meluncurkan aplikasi utama
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan MaterialApp.router karena kita memakai sistem navigasi go_router
    return MaterialApp.router(
      title: 'DigiNews Jaisy',
      debugShowCheckedModeBanner: false,
      
      // Mengambil tema dinamis (Multi-Flavor) yang sudah kita rancang di Layer Core
      theme: AppTheme.themeData,
      
      // Menghubungkan konfigurasi rute halaman (Home, Detail) dari AppRouter
      routerConfig: AppRouter.router,
    );
  }
}