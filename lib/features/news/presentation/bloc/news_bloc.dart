import 'package:flutter_bloc/flutter_bloc.dart';
import 'news_event.dart';
import 'news_state.dart';
import '../../domain/usecases/news_usecases.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsUseCases useCases;

  NewsBloc({required this.useCases}) : super(NewsInitialState()) {
    on<LoadNewsEvent>(_onLoadNews);
    on<ToggleBookmarkEvent>(_onToggleBookmark);
  }

  Future<void> _onLoadNews(LoadNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoadingState());
    try {
      final news = await useCases.fetchNews();
      final bookmarks = await useCases.fetchBookmarks();
      emit(NewsLoadedState(newsList: news, bookmarkList: bookmarks));
    } catch (e) {
      emit(NewsErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onToggleBookmark(ToggleBookmarkEvent event, Emitter<NewsState> emit) async {
    try {
      await useCases.toggleBookmark(event.newsId);
      final news = await useCases.fetchNews();
      final bookmarks = await useCases.fetchBookmarks();
      emit(NewsLoadedState(newsList: news, bookmarkList: bookmarks));
    } catch (e) {
      emit(NewsErrorState(errorMessage: e.toString()));
    }
  }
}