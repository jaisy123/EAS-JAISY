import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/news_entity.dart';

class NewsBookmarksPage extends StatelessWidget {
  final List<NewsEntity> bookmarks;

  const NewsBookmarksPage({super.key, required this.bookmarks});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Info Banner Offline Khas Gambar 4
        Container(
          width: double.infinity,
          color: const Color(0xFFC2410C),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check, color: Colors.white, size: 14),
              SizedBox(width: 6),
              Text(
                "TERSEDIA UNTUK BACA OFFLINE",
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: bookmarks.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada berita yang disimpan offline.",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookmarks.length,
                  separatorBuilder: (context, index) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final item = bookmarks[index];
                    return GestureDetector(
                      onTap: () => context.push('/detail', extra: item),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.imageUrl, 
                              width: double.infinity, 
                              height: 160, 
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback jika link gambar rusak atau gagal dimuat saat offline
                                return Container(
                                  width: double.infinity,
                                  height: 160,
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: Icon(Icons.broken_image, color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.category.toUpperCase(),
                            style: const TextStyle(color: Color(0xFFC2410C), fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.title,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          // Menggunakan Material Icon asli agar tampilan lebih konsisten di semua device
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 12, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                "${item.readingTimeMinutes} min baca  •  ${item.timeAgo}",
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}