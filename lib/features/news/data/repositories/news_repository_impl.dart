import '../../domain/repositories/news_repository.dart';
import '../../domain/entities/news_entity.dart';
import '../datasources/news_local_data_source.dart';
import '../datasources/news_remote_data_source.dart';
import '../models/news_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsLocalDataSource localDataSource;
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<NewsEntity>> getNewsList() async {
    try {
      // 1. Ambil data terbaru dari API internet
      final remoteNews = await remoteDataSource.getRemoteNews();
      
      // 2. Ambil data cache lokal yang saat ini ada untuk memeriksa status bookmark
      final existingLocalNews = await localDataSource.getCachedNews();
      
      // SINKRONISASI: Pertahankan status bookmark dari lokal agar tidak tertimpa false dari API
      final synchronizedNews = remoteNews.map((remoteItem) {
        final localMatch = existingLocalNews.firstWhere(
          // Sesuaikan parameter unik pembanding, misal berdasarkan title atau newsId
          (localItem) => localItem.title == remoteItem.title, 
          orElse: () => remoteItem,
        );
        
        // Tetapkan status bookmark lama ke data baru
        remoteItem.isBookmarked = localMatch.isBookmarked;
        return remoteItem;
      }).toList();
      
      // Simpan hasil sinkronisasi ke database lokal Isar
      await localDataSource.cacheNews(synchronizedNews);
    } catch (_) {
      // Jika internet putus, logikanya langsung melompat ke pembacaan cache lokal di bawah
    }

    // 3. Ambil data dari lokal Isar untuk ditampilkan ke UI
    final models = await localDataSource.getCachedNews();
    final entities = models.map((model) => model.toEntity()).toList();
    
    // ATURAN NPM GENAP (66): Urutkan alfabetis normal A-Z berdasarkan Judul
    entities.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    
    return entities;
  }

  @override
  Future<List<NewsEntity>> getBookmarkList() async {
    final models = await localDataSource.getBookmarkedNews();
    final entities = models.map((model) => model.toEntity()).toList();
    
    // Opsional: Tetap urutkan alfabetis jika diperlukan di halaman Bookmark
    entities.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return entities;
  }

  @override
  Future<void> saveInitialNews(List<NewsEntity> initialNews) async {
    final models = initialNews.map((entity) => NewsModel.fromEntity(entity)).toList();
    await localDataSource.cacheNews(models);
  }

  @override
  Future<void> triggerBookmarkStatus(int newsId) async {
    await localDataSource.toggleBookmark(newsId);
  }
}