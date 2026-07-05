import 'dart:convert';
import 'dart:async';
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
    // TIPS PERFORMA: Tambahkan &pageSize=20 agar load data tidak terlalu berat 
    // dan &sortBy=publishedAt untuk mendapatkan berita paling segar.
    final url = Uri.parse(
      'https://newsapi.org/v2/everything?q=indonesia&language=id&sortBy=publishedAt&pageSize=20&apiKey=0d25651d57504e3ebae33148140e8172',
    );
    try {
      final response = await client
          .get(
            url,
            headers: {
              'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articles = data['articles'] ?? [];

        // VALIDASI EXTRA: Memfilter artikel yang rusak atau dihapus oleh sistem NewsAPI
        final validArticles = articles.where((article) {
          final String title = article['title'] ?? '';
          return title.isNotEmpty && title != '[Removed]';
        }).toList();

        return validArticles.asMap().entries.map((entry) {
          int index = entry.key;
          var article = entry.value;

          String sourceName = "NewsAPI";
          if (article['source'] != null && article['source']['name'] != null) {
            sourceName = article['source']['name'];
          }

          return NewsModel()
            ..newsId = index + 1
            ..title = article['title'] ?? 'Tanpa Judul'
            ..content = article['description'] ?? article['content'] ?? 'Tidak ada deskripsi.'
            ..category = "TOP HEADLINES"
            // Mengamankan jika urlToImage dari API bernilai null atau string kosong
            ..imageUrl = (article['urlToImage'] != null && article['urlToImage'].toString().isNotEmpty)
                ? article['urlToImage']
                : 'https://picsum.photos/600/400'
            ..timeAgo = article['publishedAt'] ?? 'Baru saja'
            ..author = sourceName
            ..readingTimeMinutes = 5
            ..isBookmarked = false;
        }).toList();
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        final String errorMessage = errorData['message'] ?? 'Gagal mengambil data dari NewsAPI.org';
        throw Exception('$errorMessage (Status: ${response.statusCode})');
      }
    } on TimeoutException {
      throw Exception('Koneksi ke server habis waktu (Timeout). Periksa VPN atau internet Anda.');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil berita: $e');
    }
  }
}