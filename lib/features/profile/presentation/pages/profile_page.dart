import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Wajib ditambahkan untuk memanggil MethodChannel

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String _originalNpm = "20123066";
  final String _email = "jaisy.20123066@utdi.ac.id";
  
  // Inisialisasi jembatan udara ke Kotlin (Harus sama persis dengan yang di MainActivity.kt)
  static const _platform = MethodChannel('com.jaisy.eas/npm');
  
  String _reversedNpmFromNative = "Memuat..."; // Tempat menampung hasil dari Kotlin
  int _profileTapCount = 0;

  @override
  void initState() {
    super.override();
    _fetchNpmFromNative(); // Jalankan pemanggilan native saat halaman dibuka
  }

  // Fungsi memanggil fungsi reverse di Kotlin secara asynchronous
  Future<void> _fetchNpmFromNative() async {
    try {
      final String result = await _platform.invokeMethod('reverseNpmNative', {
        'npm': _originalNpm,
      });
      setState(() {
        _reversedNpmFromNative = result;
      });
    } catch (e) {
      setState(() {
        _reversedNpmFromNative = "Gagal memuat native";
      });
    }
  }

  void _handleProfileTap() {
    setState(() {
      _profileTapCount++;
    });

    if (_profileTapCount == 6) {
      _showAcademicEasterEgg();
      _profileTapCount = 0;
    }
  }

  void _showAcademicEasterEgg() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.verified_user, color: Color(0xFF1E3A8A)),
              SizedBox(width: 8),
              Text("Verifikasi Orisinalitas", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Aplikasi ini dikembangkan sepenuhnya oleh:",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              SizedBox(height: 12),
              Text(
                "Muhamad Jaisy Hisbulloh",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC2410C)),
              ),
              SizedBox(height: 6),
              Text("NPM: 20123066", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Text("Logika Pembalik: Android Native (Kotlin)", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Konfirmasi", style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: _handleProfileTap,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF1E3A8A), width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "https://picsum.photos/id/91/150/150",
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Color(0xFFC2410C), shape: BoxShape.circle),
                      child: const Icon(Icons.fingerprint, color: Colors.white, size: 14),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Muhamad Jaisy Hisbulloh",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                textAlign: Center,
              ),
              const SizedBox(height: 4),
              
              // Menampilkan data yang ditarik murni dari mesin MainActivity.kt
              Text(
                "NPM Terbalik (Native): $_reversedNpmFromNative",
                style: const TextStyle(color: Color(0xFFC2410C), fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(_email, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: _buildStatItems()),
        const SizedBox(height: 32),
        const Text("PENGATURAN AKUN", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A), letterSpacing: 0.5)),
        const SizedBox(height: 12),
        _buildListTile(Icons.notifications_none, "Notifikasi"),
        _buildThemeTile(context),
        _buildListTile(Icons.language, "Bahasa", trailingText: "Indonesia"),
        _buildListTile(Icons.security, "Kebijakan Privasi"),
        _buildListTile(Icons.logout, "Keluar", textColor: Colors.red),
        const SizedBox(height: 40),
        Center(
          child: Text(
            "DigiNews v1.0.0 (NPM 66)\n© 2026 Authority of Information",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
          ),
        )
      ],
    );
  }

  List<Widget> _buildStatItems() => [_statCard("124", "Simpan"), _statCard("48", "Komentar"), _statCard("Premium", "Status", isSpecial: true)];
  Widget _statCard(String value, String label, {bool isSpecial = false}) => Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)), child: Column(children: [Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isSpecial ? const Color(0xFF1E3A8A) : Colors.black)), Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey))]));
  Widget _buildListTile(IconData icon, String title, {String? trailingText, Color? textColor}) => ListTile(contentPadding: EdgeInsets.zero, leading: Icon(icon, color: textColor ?? const Color(0xFF1E3A8A)), title: Text(title, style: TextStyle(fontSize: 14, color: textColor)), trailing: trailingText != null ? Text(trailingText, style: const TextStyle(color: Colors.grey, fontSize: 13)) : const Icon(Icons.chevron_right, color: Colors.grey, size: 18));
  Widget _buildThemeTile(BuildContext context) { final isDark = Theme.of(context).brightness == Brightness.dark; return ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.dark_mode_outlined, color: Color(0xFF1E3A8A)), title: const Text("Tema", style: TextStyle(fontSize: 14)), subtitle: Text(isDark ? "Gelap (Flavor PROD)" : "Terang (Flavor DEV)", style: const TextStyle(fontSize: 11)), trailing: Switch(value: isDark, onChanged: (_) {})); }
}