import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final int id;
  final String title;
  final String content;
  final String category;
  final String imageUrl;
  final String timeAgo;
  final String author;
  final int readingTimeMinutes;
  final bool isBookmarked;

  const NewsEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.imageUrl,
    required this.timeAgo,
    required this.author,
    required this.readingTimeMinutes,
    this.isBookmarked = false,
  });

  // Fungsi untuk menyalin objek dengan perubahan status bookmark (State Mutation)
  NewsEntity copyWith({bool? isBookmarked}) {
    return NewsEntity(
      id: id,
      title: title,
      content: content,
      category: category,
      imageUrl: imageUrl,
      timeAgo: timeAgo,
      author: author,
      readingTimeMinutes: readingTimeMinutes,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        category,
        imageUrl,
        timeAgo,
        author,
        readingTimeMinutes,
        isBookmarked,
      ];
}