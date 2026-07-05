import 'package:isar/isar.dart';
import '../../domain/entities/news_entity.dart';

part 'news_model.g.dart';

@collection
class NewsModel {
  Id id = Isar.autoIncrement;

  late int newsId;
  late String title;
  
  // Mengubah beberapa field menjadi nullable karena data dari API sering kosong
  String? content;
  late String category;
  String? imageUrl;
  late String timeAgo;
  String? author;
  late int readingTimeMinutes;
  late bool isBookmarked;

  NewsEntity toEntity() {
    return NewsEntity(
      id: newsId,
      title: title,
      // Berikan fallback string kosong di sini jika NewsEntity kamu mewajibkan non-nullable
      content: content ?? 'Tidak ada deskripsi.', 
      category: category,
      imageUrl: imageUrl ?? 'https://picsum.photos/600/400',
      timeAgo: timeAgo,
      author: author ?? 'Unknown',
      readingTimeMinutes: readingTimeMinutes,
      isBookmarked: isBookmarked,
    );
  }

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