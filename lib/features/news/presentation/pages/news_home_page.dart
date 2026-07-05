import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/news_entity.dart';

class NewsHomePage extends StatelessWidget {
  final List<NewsEntity> newsList;

  const NewsHomePage({super.key, required this.newsList});

  @override
  Widget build(BuildContext context) {
    if (newsList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Ambil berita pertama sebagai Headline teratas
    final headline = newsList.first;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // BAGIAN BERITA TERBARU HEADER
        const Text(
          "Berita Terbaru",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
        ),
        const SizedBox(height: 12),

        // 1. HEADLINE CARD (Sesuai Gambar Atas)
        GestureDetector(
          onTap: () => context.push('/detail', extra: headline),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(headline.imageUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFC2410C), borderRadius: BorderRadius.circular(4)),
                  child: const Text("TERKINI", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 40),
                Text(
                  headline.title,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.white70, size: 12),
                    const SizedBox(width: 4),
                    Text(headline.timeAgo, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 2. LIST BERITA BAWAH (Urutan Alfabetis A-Z)
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: newsList.length,
          separatorBuilder: (context, index) => const Divider(height: 24),
          itemBuilder: (context, index) {
            final item = newsList[index];
            return GestureDetector(
              onTap: () => context.push('/detail', extra: item),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.category.toUpperCase(),
                          style: const TextStyle(color: Color(0xFFC2410C), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.title,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, height: 1.3),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${item.timeAgo} • ${item.readingTimeMinutes} menit baca",
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(item.imageUrl, width: 90, height: 70, fit: BoxFit.cover),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}