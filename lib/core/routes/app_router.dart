import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/news/presentation/pages/main_navigation_screen.dart';
import '../../features/news/presentation/pages/news_detail_page.dart';
import '../../features/news/domain/entities/news_entity.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute( // Gunakan GoRoute, bukan GoRouter
        path: '/',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: '/detail',
        builder: (context, state) {
          final news = state.extra as NewsEntity;
          return NewsDetailPage(news: news);
        },
      ),
    ],
  );
}