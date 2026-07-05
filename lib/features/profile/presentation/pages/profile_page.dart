import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // AVATAR & IDENTITAS MAHASISWA (Jaisy - 20123066)
        Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xFF1E3A8A), width: 2), borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network("https://picsum.photos/id/91/150/150", width: 100, height: 100, fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Color(0xFFC2410C), shape: BoxShape.circle),
                    child: const Icon(Icons.edit, color: Colors.white, size: 14),
                  )
                ],
              ),
              const SizedBox(height: 16),
              const Text("Jaisy", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
              const Text("jaisy.20123066@utdi.ac.id", style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // STATS COUNTER GRID FLAT
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildStatItems(),
        ),
        const SizedBox(height: 32),

        // PENGATURAN AKUN SECTION
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

  List<Widget> _buildStatItems() {
    return [
      _statCard("124", "Simpan"),
      _statCard("48", "Komentar"),
      _statCard("Premium", "Status", isSpecial: true),
    ];
  }

  static Widget _statCard(String value, String label, {bool isSpecial = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isSpecial ? const Color(0xFF1E3A8A) : Colors.black)),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  static Widget _buildListTile(IconData icon, String title, {String? trailingText, Color? textColor}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: textColor ?? const Color(0xFF1E3A8A)),
      title: Text(title, style: TextStyle(fontSize: 14, color: textColor)),
      trailing: trailingText != null 
          ? Text(trailingText, style: const TextStyle(color: Colors.grey, fontSize: 13))
          : const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
    );
  }

  static Widget _buildThemeTile(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.dark_mode_outlined, color: Color(0xFF1E3A8A)),
      title: const Text("Tema", style: TextStyle(fontSize: 14)),
      subtitle: Text(isDark ? "Gelap (Flavor PROD)" : "Terang (Flavor DEV)", style: const TextStyle(fontSize: 11)),
      trailing: Switch(
        value: isDark,
        onChanged: (_) {}, // Diatur otomatis oleh flavor kompilasi terminal
      ),
    );
  }
}