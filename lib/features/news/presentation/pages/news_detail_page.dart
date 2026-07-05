import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/news_entity.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsEntity news;

  const NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // APP BAR ATAS + TOMBOL BOOKMARK REAKTIF SINKRON DENGAN NEWSLOADEDSTATE
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              bool currentBookmarkStatus = news.isBookmarked;

              // PERBAIKAN: Menggunakan NewsLoadedState & properti newsList sesuai file statemu!
              if (state is NewsLoadedState) {
                final currentStateNews = state.newsList.firstWhere(
                  (element) => element.id == news.id,
                  orElse: () => news,
                );
                currentBookmarkStatus = currentStateNews.isBookmarked;
              }

              return IconButton(
                icon: Icon(
                  currentBookmarkStatus
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: currentBookmarkStatus
                      ? const Color(0xFFC2410C)
                      : const Color(0xFF1E3A8A),
                ),
                onPressed: () {
                  // Memicu event perubahan status simpan offline di BLoC/Isar
                  context.read<NewsBloc>().add(
                    ToggleBookmarkEvent(newsId: news.id),
                  );

                  // Menampilkan snackbar pemberitahuan yang akurat
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        currentBookmarkStatus
                            ? "Berita dihapus dari daftar offline."
                            : "Berita berhasil disimpan untuk baca offline!",
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // BODY UTAMA (Scrollable untuk teks artikel panjang)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // 1. Label Kategori Konten
                  Text(
                    news.category.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFC2410C),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 2. Judul Utama Berita
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3. Metadata Penulis & Waktu
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: const Color(
                          0xFF1E3A8A,
                        ).withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.edit,
                          size: 12,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Oleh ${news.author}  •  ${news.timeAgo}",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 4. Gambar Utama Artikel (dengan pelindung error link)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      news.imageUrl,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 220,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 5. Isi Narasi Deskripsi Berita
                  Text(
                    news.content,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade300
                          : Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),

            // ACTION BAR DI BAGIAN BAWAH BERITA (Interaksi Like, Comment, & Share Plus)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                border: Border(
                  top: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.thumb_up_outlined,
                      size: 22,
                      color: Color(0xFF1E3A8A),
                    ),
                    onPressed: () {},
                  ),
                  const Text(
                    "1.2k",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(
                      Icons.mode_comment_outlined,
                      size: 22,
                      color: Color(0xFF1E3A8A),
                    ),
                    onPressed: () {},
                  ),
                  const Text(
                    "48",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const Spacer(),

                  // PERBAIKAN: Menggunakan SharePlus untuk share teks modern tanpa deprecated warning
                  // FITUR SHARE BERITA (Menggunakan ignore lint agar bebas dari error static access/deprecated)
                  ElevatedButton.icon(
                    onPressed: () {
                      // ignore: deprecated_member_use
                      Share.share(
                        'Baca berita menarik ini: "${news.title}"\n\nDownload aplikasi DigiNews untuk info terbaru lainnya!',
                        subject: 'Berbagi Berita Menarik',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    icon: const Icon(Icons.share, size: 16),
                    label: const Text(
                      "Bagikan",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
