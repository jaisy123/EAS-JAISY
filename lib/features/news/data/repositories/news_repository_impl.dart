import '../../domain/repositories/news_repository.dart';
import '../../domain/entities/news_entity.dart';
import '../datasources/news_local_data_source.dart';
import '../datasources/news_remote_data_source.dart';
import '../models/news_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsLocalDataSource localDataSource;
  final NewsRemoteDataSource remoteDataSource; // Tambah remote data source

  NewsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<NewsEntity>> getNewsList() async {
    try {
      // 1. Ambil data terbaru dari API internet
      final remoteNews = await remoteDataSource.getRemoteNews();
      
      // 2. Simpan hasil API ke database lokal Isar
      await localDataSource.cacheNews(remoteNews);
    } catch (_) {
      // Jika internet putus/gagal, aplikasi tidak akan crash, melainkan lanjut membaca cache Isar
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
    return models.map((model) => model.toEntity()).toList();
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