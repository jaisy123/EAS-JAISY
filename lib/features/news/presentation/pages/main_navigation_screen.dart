import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../../../../core/di/injection.dart';
import 'news_home_page.dart';
import 'news_bookmarks_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<NewsBloc>()..add(LoadNewsEvent()),
      child: Scaffold(
        appBar: AppBar(
          // PERBAIKAN 1: Mengubah FontWeight.black menjadi FontWeight.w900 (paling tebal)
          title: const Text("DigiNews", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          ],
        ),
        body: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NewsLoadedState) {
              // PERBAIKAN 2: Menghapus keyword 'const' di depan list array agar tidak invalid_constant
              final List<Widget> pages = [
                NewsHomePage(newsList: state.newsList),
                NewsBookmarksPage(bookmarks: state.bookmarkList),
                const ProfilePage(),
              ];
              return pages[_currentIndex];
            } else if (state is NewsErrorState) {
              return Center(child: Text("Terjadi gangguan internet: ${state.errorMessage}"));
            }
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFF1E3A8A),
          unselectedItemColor: Colors.grey,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: "Bookmarks"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
          ],
        ),
      ),
    );
  }
}