import 'package:equatable/equatable.dart';
import '../../domain/entities/news_entity.dart'

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

// Event untuk memicu loading awal dan membaca data dari Isar
class LoadNewsEvent extends NewsEvent {}

// Event untuk mengubah status bookmark artikel
class ToggleBookmarkEvent extends NewsEvent {
  final int newsId;

  const ToggleBookmarkEvent({required this.newsId});

  @override
  List<Object?> get props => [newsId];
}