import 'package:isar/isar.dart';
import '../models/news_model.dart';

abstract class NewsLocalDataSource {
  Future<List<NewsModel>> getCachedNews();
  Future<List<NewsModel>> getBookmarkedNews();
  Future<void> cacheNews(List<NewsModel> newsList);
  Future<void> toggleBookmark(int newsId);
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final Isar isar;

  NewsLocalDataSourceImpl({required this.isar});

  @override
  Future<List<NewsModel>> getCachedNews() async {
    return await isar.newsModels.where().findAll();
  }

  @override
  Future<List<NewsModel>> getBookmarkedNews() async {
    return await isar.newsModels.filter().isBookmarkedEqualTo(true).findAll();
  }

  @override
  Future<void> cacheNews(List<NewsModel> newsList) async {
    await isar.writeTxn(() async {
      for (var news in newsList) {
        final existing = await isar.newsModels.filter().newsIdEqualTo(news.newsId).findFirst();
        
        if (existing != null) {
          news.id = existing.id; // Proteksi agar ID tidak duplikat
          
          // SOLUSI: Pertahankan status bookmark yang sudah diatur oleh pengguna di lokal
          news.isBookmarked = existing.isBookmarked;
        }
        
        await isar.newsModels.put(news);
      }
    });
  }

  @override
  Future<void> toggleBookmark(int newsId) async {
    await isar.writeTxn(() async {
      final news = await isar.newsModels.filter().newsIdEqualTo(newsId).findFirst();
      if (news != null) {
        news.isBookmarked = !news.isBookmarked;
        await isar.newsModels.put(news);
      }
    });
  }
}