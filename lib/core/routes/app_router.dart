import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Wajib ditambahkan
import 'package:go_router/go_router.dart';
import '../../features/news/presentation/pages/main_navigation_screen.dart';
import '../../features/news/presentation/pages/news_detail_page.dart';
import '../../features/news/domain/entities/news_entity.dart';
import '../../features/news/presentation/bloc/news_bloc.dart'; // Sesuaikan path NewsBloc Anda

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: '/detail',
        builder: (context, state) {
          // 1. Konversi extra menjadi Map<String, dynamic> sesuai kiriman dari HomePage
          final extraData = state.extra as Map<String, dynamic>;
          
          // 2. Ekstrak data NewsEntity dan NewsBloc menggunakan key yang sesuai
          final newsItem = extraData['news'] as NewsEntity;
          final newsBloc = extraData['bloc'] as NewsBloc;

          // 3. Bungkus dengan BlocProvider.value agar halaman detail reaktif & bebas error merah
          return BlocProvider.value(
            value: newsBloc,
            child: NewsDetailPage(news: newsItem),
          );
        },
      ),
    ],
  );
}