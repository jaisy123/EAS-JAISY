import '../entities/news_entity.dart';
import '../repositories/news_repository.dart';

class NewsUseCases {
  final NewsRepository repository;

  NewsUseCases({required this.repository});

  // Ambil daftar berita utama (Otomatis terurut A-Z sesuai NPM Genap Jaisy)
  Future<List<NewsEntity>> fetchNews() async {
    return await repository.getNewsList();
  }

  // Ambil daftar berita yang di-bookmark secara offline
  Future<List<NewsEntity>> fetchBookmarks() async {
    return await repository.getBookmarkList();
  }

  // Inisialisasi data dummy koran digital saat pertama kali aplikasi dibuka
  Future<void> initializeDefaultNews(List<NewsEntity> defaultNews) async {
    await repository.saveInitialNews(defaultNews);
  }

  // Mengubah status simpan/hapus bookmark artikel berita
  Future<void> toggleBookmark(int newsId) async {
    await repository.triggerBookmarkStatus(newsId);
  }
}