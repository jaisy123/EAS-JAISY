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
      // Memicu pengambilan data awal saat screen pertama kali dibuat
      create: (context) => locator<NewsBloc>()..add(LoadNewsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "DigiNews",
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -0.5),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          ],
        ),
        // IndexedStack berada di luar agar status navigasi & scroll tiap tab tidak hilang/me-reset
        body: IndexedStack(
          index: _currentIndex,
          children: [
            // ================= TAB 0: HOME PAGE =================
            BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                if (state is NewsLoadingState) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF1E3A8A)));
                }
                if (state is NewsErrorState) {
                  return Center(child: Text("Gagal memuat berita: ${state.errorMessage}"));
                }
                if (state is NewsLoadedState) {
                  return NewsHomePage(newsList: state.newsList);
                }
                return const SizedBox.shrink();
              },
            ),

            // ================= TAB 1: BOOKMARKS PAGE =================
            BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                if (state is NewsLoadingState) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF1E3A8A)));
                }
                if (state is NewsErrorState) {
                  return Center(child: Text("Gagal memuat cache: ${state.errorMessage}"));
                }
                if (state is NewsLoadedState) {
                  return NewsBookmarksPage(bookmarks: state.bookmarkList);
                }
                return const SizedBox.shrink();
              },
            ),

            // ================= TAB 2: PROFILE PAGE =================
            // Terisolasi penuh. Jika berita sedang loading/error, tab ini tidak akan terganggu sama sekali
            const ProfilePage(),
          ],
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