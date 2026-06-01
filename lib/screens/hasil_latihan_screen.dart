import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class HasilLatihanScreen extends StatelessWidget {
  final int jumlahBenar;
  final int jumlahSalah;
  final Duration waktu;

  const HasilLatihanScreen({
    super.key,
    required this.jumlahBenar,
    required this.jumlahSalah,
    required this.waktu,
  });

  int get _totalSoal => jumlahBenar + jumlahSalah;

  int get _bintang {
    if (_totalSoal == 0) return 0;
    final persen = jumlahBenar / _totalSoal;
    if (persen >= 0.9) return 5;
    if (persen >= 0.7) return 4;
    if (persen >= 0.5) return 3;
    if (persen >= 0.3) return 2;
    return 1;
  }

  String get _waktuFormat {
    final m = waktu.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = waktu.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              _buildMaskot(),
              const SizedBox(height: 20),
              const Text(
                'Pembelajaran selesai',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 20),
              _buildBintang(),
              const SizedBox(height: 32),
              _buildStatRow(),
              const Spacer(flex: 3),
              _buildSelesaiButton(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildMaskot() {
    return SizedBox(
      width: 120,
      height: 120,
      child: CustomPaint(painter: _MaskotPainter()),
    );
  }

  Widget _buildBintang() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final filled = i < _bintang;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            filled ? Icons.star_rounded : Icons.star_outline_rounded,
            color: const Color(0xFFFFD700),
            size: 42,
          ),
        );
      }),
    );
  }

  Widget _buildStatRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatCard(
          label: 'Benar',
          value: '$jumlahBenar',
          icon: Icons.check_circle_rounded,
          backgroundColor: const Color(0xFFD4EDDA),
          iconColor: const Color(0xFF28A745),
          textColor: Colors.black87,
        ),
        const SizedBox(width: 14),
        _StatCard(
          label: 'Salah',
          value: '$jumlahSalah',
          icon: Icons.cancel_rounded,
          backgroundColor: const Color(0xFFF8D7DA),
          iconColor: const Color(0xFFDC3545),
          textColor: Colors.black87,
        ),
        const SizedBox(width: 14),
        _StatCard(
          label: 'Waktu',
          value: _waktuFormat,
          icon: Icons.timer_rounded,
          backgroundColor: const Color(0xFFFFF3CD),
          iconColor: const Color(0xFFFFC107),
          textColor: Colors.black87,
        ),
      ],
    );
  }

  Widget _buildSelesaiButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Selesai',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavIcon(icon: Icons.home_rounded, color: const Color(0xFFE05252)),
              _NavIcon(icon: Icons.emoji_events_rounded, color: const Color(0xFFD4A017)),
              _NavIcon(icon: Icons.play_circle_filled, color: const Color(0xFF8B2BE2)),
              _NavIcon(icon: Icons.calculate_rounded, color: const Color(0xFF4CAF50)),
              _NavIcon(icon: Icons.person_rounded, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Stat Card ─────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Nav Icon ──────────────────────────────────────────────────

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _NavIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color.withOpacity(0.4), size: 28);
  }
}

// ─── Maskot Painter ────────────────────────────────────────────

class _MaskotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final bodyPaint = Paint()..color = const Color(0xFFE07B3A);
    final bellyPaint = Paint()..color = const Color(0xFFF5DEB3);
    final eyePaint = Paint()..color = const Color(0xFF3D1A00);
    final capePaint = Paint()..color = const Color(0xFFC0392B);
    final earPaint = Paint()..color = const Color(0xFFE07B3A);
    final tailPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Ekor
    final tailPath = Path()
      ..moveTo(cx + 28, cy - 10)
      ..quadraticBezierTo(cx + 50, cy - 30, cx + 40, cy - 55);
    canvas.drawPath(tailPath, tailPaint);

    // Telinga kiri
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - 22, cy - 42), width: 16, height: 18),
      earPaint,
    );
    // Telinga kanan
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 22, cy - 42), width: 16, height: 18),
      earPaint,
    );

    // Kepala
    canvas.drawCircle(Offset(cx, cy - 24), 32, bodyPaint);

    // Badan
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 18), width: 52, height: 44),
      bodyPaint,
    );

    // Perut
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 16), width: 34, height: 30),
      bellyPaint,
    );

    // Wajah putih
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy - 20), width: 38, height: 32),
      bellyPaint,
    );

    // Mata kiri
    canvas.drawCircle(Offset(cx - 9, cy - 22), 4.5, eyePaint);
    // Mata kanan
    canvas.drawCircle(Offset(cx + 9, cy - 22), 4.5, eyePaint);

    // Kilap mata
    final eyeShine = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx - 7, cy - 24), 1.5, eyeShine);
    canvas.drawCircle(Offset(cx + 11, cy - 24), 1.5, eyeShine);

    // Cape
    final capeShape = Path()
      ..moveTo(cx - 24, cy + 4)
      ..quadraticBezierTo(cx, cy + 48, cx + 24, cy + 4)
      ..quadraticBezierTo(cx + 18, cy + 44, cx, cy + 52)
      ..quadraticBezierTo(cx - 18, cy + 44, cx - 24, cy + 4)
      ..close();
    canvas.drawPath(capeShape, capePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}