import '../entities/news_entity.dart';

abstract class NewsRepository {
  Future<List<NewsEntity>> getNewsList();
  Future<List<NewsEntity>> getBookmarkList();
  Future<void> saveInitialNews(List<NewsEntity> initialNews);
  Future<void> triggerBookmarkStatus(int newsId);
}