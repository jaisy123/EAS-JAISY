import 'package:flutter/material.dart';
import '../../domain/entities/news_entity.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsEntity news;
  const NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(news.title)),
      body: Center(child: Text(news.content)),
    );
  }
}