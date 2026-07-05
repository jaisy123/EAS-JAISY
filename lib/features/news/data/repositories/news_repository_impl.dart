import '../../domain/repositories/news_repository.dart';
import '../../domain/entities/news_entity.dart';
import '../datasources/news_local_data_source.dart';
import '../models/news_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsLocalDataSource localDataSource;

  NewsRepositoryImpl({required this.localDataSource});

  @override
  Future<List<NewsEntity>> getNewsList() async {
    final models = await localDataSource.getCachedNews();
    
    // Konversi Isar Model ke murni Domain Entity
    final entities = models.map((model) => model.toEntity()).toList();
    
    // ATURAN ANTI-AI CHALLENGE (NPM GENAP - 66): 
    // Mengurutkan berita secara alfabetis normal dari A sampai Z berdasarkan Judul Berita
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