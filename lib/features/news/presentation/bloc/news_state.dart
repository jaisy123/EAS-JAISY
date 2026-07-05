import 'package:equatable/equatable.dart';
import '../../domain/entities/news_entity.dart';

abstract class NewsState extends Equatable {
  const NewsState();
  
  @override
  List<Object?> get props => [];
}

// Keadaan awal saat aplikasi baru dinyalakan
class NewsInitialState extends NewsState {}

// Keadaan saat aplikasi sedang membaca database lokal
class NewsLoadingState extends NewsState {}

// Keadaan saat data sukses dimuat (Membawa list berita utama dan list bookmarks)
class NewsLoadedState extends NewsState {
  final List<NewsEntity> newsList;
  final List<NewsEntity> bookmarkList;

  const NewsLoadedState({
    required this.newsList,
    required this.bookmarkList,
  });

  @override
  List<Object?> get props => [newsList, bookmarkList];
}

// Keadaan jika terjadi kendala sistem
class NewsErrorState extends NewsState {
  final String errorMessage;

  const NewsErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}