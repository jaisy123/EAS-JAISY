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
    final url = Uri.parse(
      'https://newsapi.org/v2/top-headlines?country=id&apiKey=e8c8118de54f49979c0fa9babe4edb7a'
    );
    
    try {
      // Menambahkan User-Agent agar tidak diblokir oleh NewsAPI
      final response = await client.get(
        url,
        headers: {
          'User-Agent': 'Flutter-News-App',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articles = data['articles'] ?? [];

        return articles.asMap().entries.map((entry) {
          int index = entry.key;
          var article = entry.value;
          
          String sourceName = "NewsAPI";
          if (article['source'] != null && article['source']['name'] != null) {
            sourceName = article['source']['name'];
          }
          
          return NewsModel()
            ..newsId = index + 1
            ..title = article['title'] ?? 'Tanpa Judul'
            // Fleksibel: mengambil description, jika null ambil content
            ..content = article['description'] ?? article['content'] ?? 'Tidak ada deskripsi.'
            ..category = "TOP HEADLINES"
            ..imageUrl = article['urlToImage'] ?? 'https://picsum.photos/600/400'
            ..timeAgo = article['publishedAt'] ?? 'Baru saja'
            ..author = sourceName
            ..readingTimeMinutes = 5
            ..isBookmarked = false;
        }).toList();
      } else {
        // Mengurai error response dari NewsAPI (jika ada pesan spesifik seperti apiKeyInvalid)
        final Map<String, dynamic> errorData = json.decode(response.body);
        final String errorMessage = errorData['message'] ?? 'Gagal mengambil data dari NewsAPI.org';
        throw Exception('$errorMessage (Status: ${response.statusCode})');
      }
    } catch (e) {
      // Menangkap error jaringan atau parsing data
      throw Exception('Terjadi kesalahan saat mengambil berita: $e');
    }
  }
}