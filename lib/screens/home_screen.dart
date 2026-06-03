import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/user_service.dart';
import 'materi_screen.dart';
import 'profil_screen.dart';
import 'video_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;

  // Progress dihitung dinamis dari Firestore — lihat _hitungProgress()
  static const List<_BahasaCard> _bahasaCardDefs = [
    _BahasaCard(
      key: 'sunda',
      nama: 'Bahasa Sunda',
      deskripsi: 'Pelajari bahasa Sunda dari dasar',
      emoji: '🌋',
      warna: Color(0xFF9B5B2E),
      warnaGradient: Color(0xFFCA8A3A),
    ),
    _BahasaCard(
      key: 'jawa',
      nama: 'Bahasa Jawa',
      deskripsi: 'Kuasai bahasa Jawa dengan mudah',
      emoji: '🏯',
      warna: Color(0xFF3A8A2E),
      warnaGradient: Color(0xFFCA9B20),
    ),
    _BahasaCard(
      key: 'melayu',
      nama: 'Bahasa Melayu',
      deskripsi: 'Jelajahi kekayaan bahasa Melayu',
      emoji: '⛵',
      warna: Color(0xFF1A6B8A),
      warnaGradient: Color(0xFF2A8AAA),
    ),
    _BahasaCard(
      key: 'bali',
      nama: 'Bahasa Bali',
      deskripsi: 'Temukan keindahan bahasa Bali',
      emoji: '🪷',
      warna: Color(0xFF8A2A2A),
      warnaGradient: Color(0xFFAA4A20),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildStreakBanner(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Lanjutkan Belajar'),
                    const SizedBox(height: 12),
                    _buildContinueLearning(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Pilih Bahasa Daerah'),
                    const SizedBox(height: 12),
                    _buildBahasaGrid(),
                    const SizedBox(height: 24),
                    _buildDailyChallenge(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedNavIndex,
        onTap: (i) {
          if (i == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const VideoScreen()),
            );
          } else if (i == 4) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfilScreen()),
            );
          } else {
            setState(() => _selectedNavIndex = i);
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.4), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CustomPaint(painter: _MiniMascotPainter()),
          ),
          const SizedBox(width: 10),
          const Text(
            'LITARI',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          const Spacer(),
          StreamBuilder<DocumentSnapshot>(
            stream: UserService.getUserStream(),
            builder: (context, snapshot) {
              final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
              final username = data['username'] as String? ?? 'User';
              final photoUrl = data['photoUrl'] as String? ?? '';

              return Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: photoUrl.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                  Icons.person,
                                  color: Colors.white54,
                                  size: 22),
                            ),
                          )
                        : const Icon(Icons.person, color: Colors.white54, size: 22),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStreakBanner() {
    return StreamBuilder<DocumentSnapshot>(
      stream: UserService.getUserStream(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
        final streak = data['streak'] as int? ?? 0;
        final lastBahasaStreak = data['lastBahasa'] as String? ?? 'sunda';

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2C1A0E), Color(0xFF3D2A10)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text('🔥', style: TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      streak > 0 ? 'Streak $streak Hari! 🎉' : 'Mulai Streak Hari Ini!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Terus semangat! Belajar hari ini',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => MateriScreen(bahasaKey: lastBahasaStreak)),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Mulai',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildContinueLearning() {
    return StreamBuilder<DocumentSnapshot>(
      stream: UserService.getUserStream(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
        final materiSelesai = Map<String, dynamic>.from(data['materiSelesai'] ?? {});

        // Ambil bahasa & materi terakhir user, fallback ke sunda jika belum pernah belajar
        final lastBahasa = data['lastBahasa'] as String? ?? 'sunda';
        final lastMateri = data['lastMateri'] as String? ?? 'Materi 1';
        final info = _bahasaInfo[lastBahasa] ?? _bahasaInfo['sunda']!;

        final progress = _hitungProgress(materiSelesai, lastBahasa);
        final persen = (progress * 100).round();

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => MateriScreen(bahasaKey: lastBahasa)),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [info['warna1'] as Color, info['warna2'] as Color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(info['emoji'] as String, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            info['nama'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            progress == 0
                                ? 'Mulai belajar'
                                : '$lastMateri • $persen% selesai',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static const Map<String, Map<String, dynamic>> _bahasaInfo = {
    'sunda':  {'nama': 'Bahasa Sunda', 'emoji': '🌋', 'warna1': Color(0xFF9B5B2E), 'warna2': Color(0xFFCA8A3A)},
    'jawa':   {'nama': 'Bahasa Jawa',  'emoji': '🏯', 'warna1': Color(0xFF3A8A2E), 'warna2': Color(0xFFCA9B20)},
    'melayu': {'nama': 'Bahasa Melayu','emoji': '⛵', 'warna1': Color(0xFF1A6B8A), 'warna2': Color(0xFF2A8AAA)},
    'bali':   {'nama': 'Bahasa Bali',  'emoji': '🪷', 'warna1': Color(0xFF8A2A2A), 'warna2': Color(0xFFAA4A20)},
  };

  /// Jumlah total sub-materi per bahasa (harus sinkron dengan user_service.dart)
  static const Map<String, int> _totalMateriPerBahasa = {
    'sunda': 27,
    'jawa': 9,
    'melayu': 6,
    'bali': 6,
  };

  /// Hitung progress (0.0–1.0) per bahasa dari field materiSelesai Firestore.
  double _hitungProgress(Map<String, dynamic> materiSelesai, String bahasaKey) {
    final total = _totalMateriPerBahasa[bahasaKey] ?? 1;
    final selesai = materiSelesai.keys
        .where((k) => k.startsWith('$bahasaKey.') && materiSelesai[k] == true)
        .length;
    return (selesai / total).clamp(0.0, 1.0);
  }

  Widget _buildBahasaGrid() {
    return StreamBuilder<DocumentSnapshot>(
      stream: UserService.getUserStream(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
        final materiSelesai = Map<String, dynamic>.from(data['materiSelesai'] ?? {});

        final cards = _bahasaCardDefs.map((b) =>
          b.withProgress(_hitungProgress(materiSelesai, b.key))
        ).toList();

        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: cards.map((b) => _BahasaCardWidget(
            card: b,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => MateriScreen(bahasaKey: b.key)),
              );
            },
          )).toList(),
        );
      },
    );
  }

  Widget _buildDailyChallenge() {
    return StreamBuilder<DocumentSnapshot>(
      stream: UserService.getUserStream(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
        final totalMateri = data['totalMateriSelesai'] as int? ?? 0;
        final xp = data['xp'] as int? ?? 0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.inputBorder, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('⚡', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  const Text(
                    'Statistik Belajar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A8AAA).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$xp XP',
                      style: const TextStyle(
                        color: Color(0xFF2A8AAA),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Total materi selesai: $totalMateri',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Data model kartu bahasa ───────────────────────────────────

class _BahasaCard {
  final String key;
  final String nama;
  final String deskripsi;
  final String emoji;
  final Color warna;
  final Color warnaGradient;
  final double progress;

  const _BahasaCard({
    required this.key,
    required this.nama,
    required this.deskripsi,
    required this.emoji,
    required this.warna,
    required this.warnaGradient,
    this.progress = 0.0,
  });

  _BahasaCard withProgress(double p) => _BahasaCard(
    key: key, nama: nama, deskripsi: deskripsi,
    emoji: emoji, warna: warna, warnaGradient: warnaGradient,
    progress: p,
  );
}

class _BahasaCardWidget extends StatelessWidget {
  final _BahasaCard card;
  final VoidCallback onTap;

  const _BahasaCardWidget({required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [card.warna, card.warnaGradient],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(card.emoji, style: const TextStyle(fontSize: 30)),
            const Spacer(),
            Text(
              card.nama,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            if (card.progress > 0) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: card.progress,
                  minHeight: 5,
                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ] else ...[
              Text(
                'Mulai belajar →',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Mini mascot untuk header ──────────────────────────────────

class _MiniMascotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final p = Paint()..color = const Color(0xFFE07B3A);
    canvas.drawCircle(Offset(cx, cy - 4), 14, p);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 8), width: 24, height: 18), p);
    final belly = Paint()..color = const Color(0xFFF5DEB3);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 2), width: 16, height: 13), belly);
    final eye = Paint()..color = const Color(0xFF3D1A00);
    canvas.drawCircle(Offset(cx - 4, cy - 6), 2, eye);
    canvas.drawCircle(Offset(cx + 4, cy - 6), 2, eye);
    final cape = Paint()..color = const Color(0xFFC0392B);
    final capePath = Path()
      ..moveTo(cx - 12, cy + 2)
      ..quadraticBezierTo(cx, cy + 22, cx + 12, cy + 2)
      ..quadraticBezierTo(cx + 8, cy + 18, cx, cy + 24)
      ..quadraticBezierTo(cx - 8, cy + 18, cx - 12, cy + 2)
      ..close();
    canvas.drawPath(capePath, cape);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─── Bottom Navigation Bar ─────────────────────────────────────

class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  const _BottomNavBar({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded, index: 0, selected: selectedIndex == 0, onTap: onTap, color: const Color(0xFFE05252)),
              _NavItem(icon: Icons.emoji_events_rounded, index: 1, selected: selectedIndex == 1, onTap: onTap, color: const Color(0xFFD4A017)),
              _NavItem(icon: Icons.play_circle_filled, index: 2, selected: selectedIndex == 2, onTap: onTap, color: const Color(0xFF8B2BE2)),
              _NavItem(icon: Icons.calculate_rounded, index: 3, selected: selectedIndex == 3, onTap: onTap, color: const Color(0xFF4CAF50)),
              _NavItem(icon: Icons.person_rounded, index: 4, selected: selectedIndex == 4, onTap: onTap, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final bool selected;
  final void Function(int) onTap;
  final Color color;

  const _NavItem({
    required this.icon,
    required this.index,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: selected
            ? BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Icon(
          icon,
          color: selected ? color : Colors.white38,
          size: 28,
        ),
      ),
    );
  }
}