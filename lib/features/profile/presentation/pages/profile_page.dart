import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  final String _originalNpm = "20123066";
  final String _email = "jaisy.20123066@utdi.ac.id";
  
  static const _platform = MethodChannel('com.jaisy.eas/npm');
  
  String _reversedNpmFromNative = ""; 
  int _profileTapCount = 0;
  
  late final AnimationController _lottieController;
  bool _isHighlighted = false; 

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _lottieController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isHighlighted = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _lottieController.dispose(); 
    super.dispose();
  }

  Future<void> _handleReverseNpmAction() async {
    try {
      final String result = await _platform.invokeMethod('reverseNpmNative', {
        'npm': _originalNpm,
      });
      
      if (!mounted) return;
      
      setState(() {
        _reversedNpmFromNative = result;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("NPM Berhasil Dibalik lewat Kotlin Native!")),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _reversedNpmFromNative = "Error Native";
      });
    }
  }

  void _handleProfileTap() {
    setState(() {
      _profileTapCount++;
    });

    if (_profileTapCount == 6) {
      setState(() {
        _isHighlighted = true; 
      });
      _lottieController.forward(from: 0.0);
      _profileTapCount = 0; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 20),
        
        // AREA FOTO PROFIL + LAYER LOTTIE
        Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: _handleProfileTap,
                child: Stack(
                  alignment: Alignment.center, 
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.person,
                        size: 65,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    if (_isHighlighted)
                      IgnorePointer( 
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 300),
                          scale: 1.6, 
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: Lottie.network(
                              'https://assets9.lottiefiles.com/packages/lf20_jbrw3hcz.json',
                              controller: _lottieController,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // PERBAIKAN 1: Pengaturan nama dibersihkan dari const parsial yang bentrok
              Text(
                "Muhamad Jaisy Hisbulloh",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              
              Text(
                "NPM: $_originalNpm",
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 4),

              // PERBAIKAN 2: Mengubah FontWeight.black menjadi FontWeight.w900 agar valid konstan
              if (_reversedNpmFromNative.isNotEmpty) ...[
                Text(
                  _reversedNpmFromNative, 
                  style: const TextStyle(
                    color: Color(0xFFC2410C), 
                    fontSize: 20, 
                    fontWeight: FontWeight.w900, 
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // TOMBOL EKSEKUSI NATIVE KOTLIN
              ElevatedButton.icon(
                onPressed: _handleReverseNpmAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                icon: const Icon(Icons.swap_horizontal_circle_outlined, size: 18),
                label: const Text("Balik NPM via Kotlin", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              
              const SizedBox(height: 12),
              Text(_email, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 32),
        
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: _buildStatItems()),
        const SizedBox(height: 60),
        
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
  
  Widget _statCard(String value, String label, {bool isSpecial = false}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), 
    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)), 
    child: Column(
      children: [
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSpecial ? const Color(0xFF1E3A8A) : Colors.black)), 
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))
      ]
    )
  );
}