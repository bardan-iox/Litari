import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/litari_logo.dart';
import '../widgets/litari_bottom_nav_bar.dart';
import 'pilih_bahasa_screen.dart';
import 'materi_screen.dart';
import 'profil_screen.dart';
import 'video_screen.dart';
import 'aksara_sunda_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  static const List<_BahasaCard> _bahasaList = [
    _BahasaCard(
      key: 'sunda',
      nama: 'Bahasa Sunda',
      deskripsi: 'Pelajari bahasa Sunda dari dasar',
      emoji: '🌋',
      warna: Color(0xFF9B5B2E),
      warnaGradient: Color(0xFFCA8A3A),
      progress: 0.35,
    ),
    _BahasaCard(
      key: 'jawa',
      nama: 'Bahasa Jawa',
      deskripsi: 'Kuasai bahasa Jawa dengan mudah',
      emoji: '🏯',
      warna: Color(0xFF3A8A2E),
      warnaGradient: Color(0xFFCA9B20),
      progress: 0.0,
    ),
    _BahasaCard(
      key: 'melayu',
      nama: 'Bahasa Melayu',
      deskripsi: 'Jelajahi kekayaan bahasa Melayu',
      emoji: '⛵',
      warna: Color(0xFF1A6B8A),
      warnaGradient: Color(0xFF2A8AAA),
      progress: 0.0,
    ),
    _BahasaCard(
      key: 'bali',
      nama: 'Bahasa Bali',
      deskripsi: 'Temukan keindahan bahasa Bali',
      emoji: '🪷',
      warna: Color(0xFF8A2A2A),
      warnaGradient: Color(0xFFAA4A20),
      progress: 0.0,
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
      bottomNavigationBar: const LitariBottomNavBar(selectedIndex: 0),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.divider.withOpacity(0.4), width: 0.5),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2C3347),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.4), width: 1),
            ),
            child: Row(
              children: const [
                Text('⚡', style: TextStyle(fontSize: 14)),
                SizedBox(width: 4),
                Text(
                  '240 XP',
                  style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.notifications_outlined, color: Colors.white70, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C1A0E), Color(0xFF3D2A10)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
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
                const Text(
                  'Streak 7 Hari! 🎉',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Terus semangat! Belajar hari ini',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
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
        ],
      ),
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MateriScreen(bahasaKey: 'sunda')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9B5B2E), Color(0xFFCA8A3A)],
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
                const Text('🌋', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bahasa Sunda',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Materi 1 • 35% selesai',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
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
                value: 0.35,
                minHeight: 8,
                backgroundColor: Colors.white.withOpacity(0.25),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBahasaGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: _bahasaList.map((b) => _BahasaCardWidget(
        card: b,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => MateriScreen(bahasaKey: b.key)),
          );
        },
      )).toList(),
    );
  }

  Widget _buildDailyChallenge() {
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
                'Tantangan Harian',
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
                  color: const Color(0xFF2A8AAA).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '50 XP',
                  style: TextStyle(
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
            'Selesaikan 5 latihan hari ini untuk menjaga streakmu!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (i) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: i < 2 ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: i < 2 ? AppColors.primary : AppColors.inputBorder,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  i < 2 ? Icons.check : Icons.bolt_outlined,
                  color: i < 2 ? Colors.white : Colors.white30,
                  size: 18,
                ),
              ),
            )),
          ),
        ],
      ),
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
    required this.progress,
  });
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
                  backgroundColor: Colors.white.withOpacity(0.25),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ] else ...[
              Text(
                'Mulai belajar →',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
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