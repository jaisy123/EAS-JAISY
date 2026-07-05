import 'package:isar/isar.dart';
import '../../domain/entities/news_entity.dart';

// Menandakan bahwa kelas ini akan digenerasikan menjadi skrip Isar kustom (.g.dart)
part 'news_model.g.dart';

@collection
class NewsModel {
  // Id lokal Isar otomatis
  Id id = Isar.autoIncrement;

  late int newsId;
  late String title;
  late String content;
  late String category;
  late String imageUrl;
  late String timeAgo;
  late String author;
  late int readingTimeMinutes;
  late bool isBookmarked;

  // Mengubah data dari Isar Model kembali ke Entitas murni Domain
  NewsEntity toEntity() {
    return NewsEntity(
      id: newsId,
      title: title,
      content: content,
      category: category,
      imageUrl: imageUrl,
      timeAgo: timeAgo,
      author: author,
      readingTimeMinutes: readingTimeMinutes,
      isBookmarked: isBookmarked,
    );
  }

  // Membuat Isar Model baru berdasarkan cetakan data dari Entitas Domain
  static NewsModel fromEntity(NewsEntity entity) {
    return NewsModel()
      ..newsId = entity.id
      ..title = entity.title
      ..content = entity.content
      ..category = entity.category
      ..imageUrl = entity.imageUrl
      ..timeAgo = entity.timeAgo
      ..author = entity.author
      ..readingTimeMinutes = entity.readingTimeMinutes
      ..isBookmarked = entity.isBookmarked;
  }
}