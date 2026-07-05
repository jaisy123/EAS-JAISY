import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> getRemoteNews();
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final http.Client client;

  NewsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<NewsModel>> getRemoteNews() async {
    // Menggunakan API Berita Indonesia Terbuka (Bisa diganti URL API pilihanmu)
    final url = Uri.parse('https://api-berita-indonesia.vercel.noocandle.com/cnn/nasional/');
    
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articles = data['data']['posts'];

      // Mapping hasil JSON API ke dalam Isar NewsModel
      return articles.asMap().entries.map((entry) {
        int index = entry.key;
        var article = entry.value;
        
        return NewsModel()
          ..newsId = index + 1
          ..title = article['title'] ?? 'Tanpa Judul'
          ..content = article['description'] ?? 'Tidak ada deskripsi.'
          ..category = "NASIONAL"
          ..imageUrl = article['thumbnail'] ?? 'https://picsum.photos/600/400'
          ..timeAgo = article['pubDate'] ?? 'Baru saja'
          ..author = "CNN Indonesia"
          ..readingTimeMinutes = 5
          ..isBookmarked = false;
      }).toList();
    } else {
      throw Exception('Gagal mengambil data dari API');
    }
  }
}