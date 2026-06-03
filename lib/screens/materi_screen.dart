import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/user_service.dart';
import 'latihan_screen.dart';

// ─── Data model ──────────────────────────────────────────────

class SubMateri {
  final String nama;
  bool selesai;
  SubMateri({required this.nama, this.selesai = false});
}

class MateriItem {
  final String nama;
  final int nomor;
  bool isExpanded;
  final bool isLocked;
  final List<SubMateri> subMateri;

  MateriItem({
    required this.nama,
    required this.nomor,
    this.isExpanded = false,
    this.isLocked = false,
    required this.subMateri,
  });
}

// ─── Tema per bahasa ─────────────────────────────────────────

class _BahasaTheme {
  final String title;
  final Color colorOdd;
  final Color colorEven;
  final Color colorLockedOdd;
  final Color colorLockedEven;

  const _BahasaTheme({
    required this.title,
    required this.colorOdd,
    required this.colorEven,
    required this.colorLockedOdd,
    required this.colorLockedEven,
  });
}

const Map<String, _BahasaTheme> _bahasaThemes = {
  'sunda': _BahasaTheme(
    title: 'Bahasa Sunda',
    colorOdd: Color(0xFF9B5B2E),   // coklat tua
    colorEven: Color(0xFFCA8A3A),  // coklat oranye
    colorLockedOdd: Color(0xFF4A2A14),
    colorLockedEven: Color(0xFF5C3A18),
  ),
  'jawa': _BahasaTheme(
    title: 'Bahasa Jawa',
    colorOdd: Color(0xFF3A8A2E),   // hijau
    colorEven: Color(0xFFCA9B20),  // kuning gelap
    colorLockedOdd: Color(0xFF1A4014),
    colorLockedEven: Color(0xFF5C4A10),
  ),
  'melayu': _BahasaTheme(
    title: 'Bahasa Melayu',
    colorOdd: Color(0xFF1A6B8A),
    colorEven: Color(0xFF2A8AAA),
    colorLockedOdd: Color(0xFF0A2A38),
    colorLockedEven: Color(0xFF103848),
  ),
  'bali': _BahasaTheme(
    title: 'Bahasa Bali',
    colorOdd: Color(0xFF8A2A2A),
    colorEven: Color(0xFFAA4A20),
    colorLockedOdd: Color(0xFF3A1010),
    colorLockedEven: Color(0xFF4A1E0E),
  ),
};

// ─── Generate data materi ────────────────────────────────────

List<MateriItem> _generateMateri() {
  // Data awal sebelum Firestore load — semua kosong, hanya Materi 1 terbuka
  return List.generate(10, (i) {
    final nomor = i + 1;
    return MateriItem(
      nama: 'Materi $nomor',
      nomor: nomor,
      isLocked: nomor > 1,
      subMateri: List.generate(3, (j) {
        return SubMateri(nama: 'Materi $nomor.${j + 1}', selesai: false);
      }),
    );
  });
}

// ─── Main Screen ─────────────────────────────────────────────

class MateriScreen extends StatefulWidget {
  final String bahasaKey;

  const MateriScreen({super.key, required this.bahasaKey});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  late List<MateriItem> _materi;
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _materi = _generateMateri();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final data = await UserService.getUserData();
    if (data == null || !mounted) return;
    final materiSelesai = Map<String, dynamic>.from(data['materiSelesai'] ?? {});
    setState(() {
      _materi = _buildMateriWithProgress(materiSelesai);
    });
  }

  List<MateriItem> _buildMateriWithProgress(Map<String, dynamic> materiSelesai) {
    return List.generate(10, (i) {
      final nomor = i + 1;
      // Materi terbuka jika materi sebelumnya sudah ada minimal 1 sub-materi selesai,
      // atau materi pertama selalu terbuka
      final prevSelesai = nomor == 1
          ? true
          : List.generate(3, (j) => 'Materi ${nomor - 1}.${j + 1}')
              .any((k) => materiSelesai['${widget.bahasaKey}.$k'] == true);
      final isLocked = !prevSelesai;
      return MateriItem(
        nama: 'Materi $nomor',
        nomor: nomor,
        isLocked: isLocked,
        subMateri: List.generate(3, (j) {
          final subKey = '${widget.bahasaKey}.Materi $nomor.${j + 1}';
          return SubMateri(
            nama: 'Materi $nomor.${j + 1}',
            selesai: materiSelesai[subKey] == true,
          );
        }),
      );
    });
  }

  _BahasaTheme get _theme =>
      _bahasaThemes[widget.bahasaKey] ?? _bahasaThemes['sunda']!;

  void _toggleExpand(int index) {
    if (_materi[index].isLocked) return;
    setState(() {
      _materi[index].isExpanded = !_materi[index].isExpanded;
    });
  }

  void _toggleSubMateri(int materiIndex, int subIndex) {
    final namaMateri = _materi[materiIndex].nama;
    final namaSubMateri = _materi[materiIndex].subMateri[subIndex].nama;
    // Simpan bahasa & materi terakhir ke Firestore
    UserService.simpanLastBahasa(
      bahasaKey: widget.bahasaKey,
      namaMateri: namaMateri,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LatihanScreen(
          bahasaKey: widget.bahasaKey,
          materiKey: namaSubMateri, // contoh: 'Materi 1.1'
        ),
      ),
    ).then((_) {
      // Reload progress setelah kembali dari latihan
      _loadProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // App bar area
          Container(
            color: AppColors.background,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    _theme.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Divider
          Container(height: 1, color: AppColors.divider),

          // Materi list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _materi.length,
              itemBuilder: (context, index) {
                return _MateriAccordionItem(
                  item: _materi[index],
                  index: index,
                  theme: _theme,
                  onToggle: () => _toggleExpand(index),
                  onToggleSub: (subIdx) => _toggleSubMateri(index, subIdx),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedNavIndex,
        onTap: (i) => setState(() => _selectedNavIndex = i),
      ),
    );
  }
}

// ─── Accordion item ──────────────────────────────────────────

class _MateriAccordionItem extends StatelessWidget {
  final MateriItem item;
  final int index;
  final _BahasaTheme theme;
  final VoidCallback onToggle;
  final void Function(int) onToggleSub;

  const _MateriAccordionItem({
    required this.item,
    required this.index,
    required this.theme,
    required this.onToggle,
    required this.onToggleSub,
  });

  Color get _headerColor {
    final isOdd = index % 2 == 0;
    if (item.isLocked) {
      return isOdd ? theme.colorLockedOdd : theme.colorLockedEven;
    }
    return isOdd ? theme.colorOdd : theme.colorEven;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header row
        GestureDetector(
          onTap: onToggle,
          child: Container(
            color: _headerColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.nama,
                    style: TextStyle(
                      color: item.isLocked
                          ? Colors.white54
                          : AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Icon(
                  item.isLocked
                      ? Icons.chevron_right
                      : item.isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.chevron_right,
                  color: item.isLocked ? Colors.white30 : Colors.white,
                  size: 28,
                ),
              ],
            ),
          ),
        ),

        // Sub-materi (expanded)
        if (item.isExpanded && !item.isLocked)
          Container(
            color: AppColors.surface,
            child: Column(
              children: List.generate(item.subMateri.length, (subIdx) {
                final sub = item.subMateri[subIdx];
                return GestureDetector(
                  onTap: () => onToggleSub(subIdx),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: subIdx < item.subMateri.length - 1
                              ? AppColors.divider.withValues(alpha: 0.4)
                              : Colors.transparent,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            sub.nama,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _CheckboxIcon(checked: sub.selesai),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

        // Bottom border
        Container(height: 1, color: Colors.black26),
      ],
    );
  }
}

// ─── Checkbox custom ─────────────────────────────────────────

class _CheckboxIcon extends StatelessWidget {
  final bool checked;
  const _CheckboxIcon({required this.checked});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: checked
          ? const Icon(Icons.check, color: Colors.white, size: 18)
          : null,
    );
  }
}

// ─── Bottom Navigation Bar ───────────────────────────────────

class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  const _BottomNavBar({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        top: false,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border(
              top: BorderSide(color: AppColors.divider, width: 0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: _HomeIcon(),
                index: 0,
                selected: selectedIndex == 0,
                onTap: onTap,
              ),
              _NavItem(
                icon: _TrophyIcon(),
                index: 1,
                selected: selectedIndex == 1,
                onTap: onTap,
              ),
              _NavItem(
                icon: _VideoIcon(),
                index: 2,
                selected: selectedIndex == 2,
                onTap: onTap,
              ),
              _NavItem(
                icon: _NotesIcon(),
                index: 3,
                selected: selectedIndex == 3,
                onTap: onTap,
              ),
              _NavItem(
                icon: _ProfileIcon(),
                index: 4,
                selected: selectedIndex == 4,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final Widget icon;
  final int index;
  final bool selected;
  final void Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Opacity(opacity: selected ? 1.0 : 0.7, child: icon),
      ),
    );
  }
}

// Custom nav icons
class _HomeIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(34, 34), painter: _HomePainter());
  }
}

class _HomePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    // House body
    final bodyPaint = Paint()..color = const Color(0xFFE05252);
    final path = Path()
      ..moveTo(cx, 4)
      ..lineTo(size.width - 4, 16)
      ..lineTo(size.width - 8, 16)
      ..lineTo(size.width - 8, size.height - 4)
      ..lineTo(8, size.height - 4)
      ..lineTo(8, 16)
      ..lineTo(4, 16)
      ..close();
    canvas.drawPath(path, bodyPaint);
    // Roof peak
    final roofPaint = Paint()..color = const Color(0xFFFF6B6B);
    final roofPath = Path()
      ..moveTo(cx, 2)
      ..lineTo(size.width - 2, 17)
      ..lineTo(2, 17)
      ..close();
    canvas.drawPath(roofPath, roofPaint);
    // Door
    final doorPaint = Paint()..color = Colors.black38;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 5, size.height - 16, 10, 12),
        const Radius.circular(2),
      ),
      doorPaint,
    );
    // Window
    final winPaint = Paint()..color = const Color(0xFFFFD700);
    canvas.drawCircle(Offset(cx, 22), 3.5, winPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _TrophyIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(34, 34), painter: _TrophyPainter());
  }
}

class _TrophyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final p = Paint()..color = const Color(0xFFD4A017);
    // Cup
    final cup = Path()
      ..moveTo(cx - 10, 4)
      ..lineTo(cx + 10, 4)
      ..lineTo(cx + 8, 20)
      ..quadraticBezierTo(cx + 8, 26, cx, 26)
      ..quadraticBezierTo(cx - 8, 26, cx - 8, 20)
      ..close();
    canvas.drawPath(cup, p);
    // Handles
    canvas.drawArc(
      Rect.fromLTWH(cx - 18, 6, 10, 12),
      0.5, 2.2, false,
      p..style = PaintingStyle.stroke..strokeWidth = 3,
    );
    canvas.drawArc(
      Rect.fromLTWH(cx + 8, 6, 10, 12),
      0.9, -2.2, false,
      p,
    );
    p.style = PaintingStyle.fill;
    // Stem & base
    canvas.drawRect(Rect.fromLTWH(cx - 3, 26, 6, 4), p);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 9, 30, 18, 3),
        const Radius.circular(2),
      ),
      p,
    );
    // Star
    canvas.drawCircle(Offset(cx, 14), 4, Paint()..color = Colors.white38);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _VideoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFF8B2BE2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(Icons.play_arrow, color: Colors.white, size: 22),
    );
  }
}

class _NotesIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Center(
        child: Text(
          'Σ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class _ProfileIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 16,
      backgroundColor: Color(0xFF4A5568),
      child: Icon(Icons.person, color: Colors.white70, size: 20),
    );
  }
}