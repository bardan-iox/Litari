import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/litari_logo.dart';

// ─── Model Soal ──────────────────────────────────────────────

enum TipeSoal { pilihPasangan, pilihGambar }

class Soal {
  final TipeSoal tipe;
  final String pertanyaan;         // label soal (kata Sunda yg harus dipasangkan/gambar)
  final List<String> opsiKiri;     // kolom kiri (untuk pilihPasangan)
  final List<String> opsiKanan;    // kolom kanan (untuk pilihPasangan)
  final Map<String, String> jawaban; // key=kiri, value=kanan yang benar
  // Untuk pilihGambar
  final String? kataKunci;
  final List<String> gambarEmoji;
  final int? indexBenar;

  const Soal({
    required this.tipe,
    required this.pertanyaan,
    this.opsiKiri = const [],
    this.opsiKanan = const [],
    this.jawaban = const {},
    this.kataKunci,
    this.gambarEmoji = const [],
    this.indexBenar,
  });
}

// ─── Data Soal Bahasa Sunda ───────────────────────────────────

final List<Soal> _soalSunda = [
  Soal(
    tipe: TipeSoal.pilihPasangan,
    pertanyaan: 'Pilih pasangan yang cocok',
    opsiKiri:  ['Dari mana', 'Kapan',    'Permisi',  'Kemana',  'Silahkan'],
    opsiKanan: ['Punten',    'Mangga',   'Iraha',    'Timana',  'Kamana'],
    jawaban: {
      'Dari mana': 'Timana',
      'Kapan':     'Iraha',
      'Permisi':   'Punten',
      'Kemana':    'Kamana',
      'Silahkan':  'Mangga',
    },
  ),
  Soal(
    tipe: TipeSoal.pilihGambar,
    pertanyaan: 'Pilih gambar yang benar',
    kataKunci: 'Imah',
    gambarEmoji: ['🍳', '🏠', '🔪', '🐟'],
    indexBenar: 1,
  ),
  Soal(
    tipe: TipeSoal.pilihPasangan,
    pertanyaan: 'Pilih pasangan yang cocok',
    opsiKiri:  ['Makan',     'Minum',   'Tidur',    'Berjalan', 'Duduk'],
    opsiKanan: ['Dahar',     'Nginum',  'Sare',     'Leumpang', 'Diuk'],
    jawaban: {
      'Makan':    'Dahar',
      'Minum':    'Nginum',
      'Tidur':    'Sare',
      'Berjalan': 'Leumpang',
      'Duduk':    'Diuk',
    },
  ),
  Soal(
    tipe: TipeSoal.pilihGambar,
    pertanyaan: 'Pilih gambar yang benar',
    kataKunci: 'Ucing',
    gambarEmoji: ['🐶', '🐱', '🐸', '🐦'],
    indexBenar: 1,
  ),
];

// ─── Main Screen ─────────────────────────────────────────────

class LatihanScreen extends StatefulWidget {
  final String bahasaKey;
  const LatihanScreen({super.key, required this.bahasaKey});

  @override
  State<LatihanScreen> createState() => _LatihanScreenState();
}

class _LatihanScreenState extends State<LatihanScreen> {
  int _soalIndex = 0;
  int _benar = 0;
  int _salah = 0;
  bool _selesai = false;

  // Timer
  late Stopwatch _stopwatch;
  late Timer _timer;
  String _waktu = '0:00';

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          final m = _stopwatch.elapsed.inMinutes;
          final s = _stopwatch.elapsed.inSeconds % 60;
          _waktu = '$m:${s.toString().padLeft(2, '0')}';
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  void _onJawaban(bool benar) {
    setState(() {
      if (benar) _benar++; else _salah++;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        if (_soalIndex < _soalSunda.length - 1) {
          _soalIndex++;
        } else {
          _selesai = true;
          _stopwatch.stop();
          _timer.cancel();
        }
      });
    });
  }

  double get _progress => (_soalIndex + 1) / _soalSunda.length;

  @override
  Widget build(BuildContext context) {
    if (_selesai) {
      return HasilScreen(
        benar: _benar,
        salah: _salah,
        waktu: _waktu,
      );
    }

    final soal = _soalSunda[_soalIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header: X + progress bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, color: Colors.white54, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 10,
                        backgroundColor: const Color(0xFF3D4560),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Soal
            Expanded(
              child: soal.tipe == TipeSoal.pilihPasangan
                  ? _PilihPasanganWidget(soal: soal, onJawaban: _onJawaban)
                  : _PilihGambarWidget(soal: soal, onJawaban: _onJawaban),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widget: Pilih Pasangan ───────────────────────────────────

class _PilihPasanganWidget extends StatefulWidget {
  final Soal soal;
  final void Function(bool) onJawaban;
  const _PilihPasanganWidget({required this.soal, required this.onJawaban});

  @override
  State<_PilihPasanganWidget> createState() => _PilihPasanganWidgetState();
}

class _PilihPasanganWidgetState extends State<_PilihPasanganWidget> {
  String? _pilihanKiri;
  String? _pilihanKanan;
  // item yg sudah cocok/salah
  final Map<String, _ItemState> _stateKiri = {};
  final Map<String, _ItemState> _stateKanan = {};
  bool _periksaDone = false;

  void _pilihKiri(String val) {
    if (_stateKiri[val] == _ItemState.benar) return;
    setState(() => _pilihanKiri = val);
    _cekPasangan();
  }

  void _pilihKanan(String val) {
    if (_stateKanan[val] == _ItemState.benar) return;
    setState(() => _pilihanKanan = val);
    _cekPasangan();
  }

  void _cekPasangan() {
    if (_pilihanKiri == null || _pilihanKanan == null) return;
    final benar = widget.soal.jawaban[_pilihanKiri] == _pilihanKanan;
    setState(() {
      if (benar) {
        _stateKiri[_pilihanKiri!] = _ItemState.benar;
        _stateKanan[_pilihanKanan!] = _ItemState.benar;
      } else {
        _stateKiri[_pilihanKiri!] = _ItemState.salah;
        _stateKanan[_pilihanKanan!] = _ItemState.salah;
        Future.delayed(const Duration(milliseconds: 700), () {
          if (!mounted) return;
          setState(() {
            _stateKiri.remove(_pilihanKiri);
            _stateKanan.remove(_pilihanKanan);
          });
        });
      }
      _pilihanKiri = null;
      _pilihanKanan = null;
    });
  }

  void _periksa() {
    if (_periksaDone) return;
    final semua = widget.soal.opsiKiri.length;
    final cocok = _stateKiri.values.where((s) => s == _ItemState.benar).length;
    setState(() => _periksaDone = true);
    widget.onJawaban(cocok == semua);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Pilih pasangan yang cocok',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Row(
              children: [
                // Kolom kiri
                Expanded(
                  child: Column(
                    children: widget.soal.opsiKiri.map((kata) {
                      final state = _pilihanKiri == kata
                          ? _ItemState.dipilih
                          : (_stateKiri[kata] ?? _ItemState.normal);
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: _WordButton(
                            text: kata,
                            state: state,
                            onTap: () => _pilihKiri(kata),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 14),
                // Kolom kanan
                Expanded(
                  child: Column(
                    children: widget.soal.opsiKanan.map((kata) {
                      final state = _pilihanKanan == kata
                          ? _ItemState.dipilih
                          : (_stateKanan[kata] ?? _ItemState.normal);
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: _WordButton(
                            text: kata,
                            state: state,
                            onTap: () => _pilihKanan(kata),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _periksa,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('Periksa',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

enum _ItemState { normal, dipilih, benar, salah }

class _WordButton extends StatelessWidget {
  final String text;
  final _ItemState state;
  final VoidCallback onTap;
  const _WordButton({required this.text, required this.state, required this.onTap});

  Color get _borderColor {
    switch (state) {
      case _ItemState.dipilih: return const Color(0xFF4CAF50);
      case _ItemState.benar:   return const Color(0xFF4CAF50);
      case _ItemState.salah:   return const Color(0xFFE53935);
      default:                 return AppColors.inputBorder;
    }
  }

  Color get _textColor {
    switch (state) {
      case _ItemState.benar: return Colors.white54;
      default:               return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: state == _ItemState.benar ? null : onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor, width: 2),
        ),
        child: Center(
          child: Text(text,
            style: TextStyle(color: _textColor, fontSize: 15, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// ─── Widget: Pilih Gambar ─────────────────────────────────────

class _PilihGambarWidget extends StatefulWidget {
  final Soal soal;
  final void Function(bool) onJawaban;
  const _PilihGambarWidget({required this.soal, required this.onJawaban});

  @override
  State<_PilihGambarWidget> createState() => _PilihGambarWidgetState();
}

class _PilihGambarWidgetState extends State<_PilihGambarWidget> {
  int? _dipilih;
  bool _sudahJawab = false;

  void _pilih(int index) {
    if (_sudahJawab) return;
    setState(() {
      _dipilih = index;
      _sudahJawab = true;
    });
    final benar = index == widget.soal.indexBenar;
    Future.delayed(const Duration(milliseconds: 800), () {
      widget.onJawaban(benar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Pilih gambar yang benar',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          // Kata kunci chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Text(
              widget.soal.kataKunci ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 20),
          // Grid 2x2
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(widget.soal.gambarEmoji.length, (i) {
                final isBenar = i == widget.soal.indexBenar;
                final isDipilih = _dipilih == i;
                Color borderColor = AppColors.inputBorder;
                if (_sudahJawab && isDipilih) {
                  borderColor = isBenar ? const Color(0xFF4CAF50) : const Color(0xFFE53935);
                }
                return GestureDetector(
                  onTap: () => _pilih(i),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(widget.soal.gambarEmoji[i],
                            style: const TextStyle(fontSize: 64)),
                        if (_sudahJawab && isDipilih)
                          Positioned(
                            bottom: 10,
                            child: Container(
                              width: 28, height: 28,
                              decoration: BoxDecoration(
                                color: isBenar ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isBenar ? Icons.check : Icons.close,
                                color: Colors.white, size: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _sudahJawab ? null : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('Lanjut',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─── Hasil Screen ─────────────────────────────────────────────

class HasilScreen extends StatelessWidget {
  final int benar;
  final int salah;
  final String waktu;
  const HasilScreen({super.key, required this.benar, required this.salah, required this.waktu});

  int get _bintang {
    final total = benar + salah;
    if (total == 0) return 3;
    final persen = benar / total;
    if (persen >= 0.8) return 5;
    if (persen >= 0.6) return 4;
    if (persen >= 0.4) return 3;
    if (persen >= 0.2) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Mascot
            SizedBox(
              width: 120, height: 120,
              child: CustomPaint(painter: _SimpleMascotPainter()),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pembelajaran selesai',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            // Bintang
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  i < _bintang ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFD700),
                  size: 36,
                ),
              )),
            ),
            const SizedBox(height: 28),
            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(child: _StatCard(
                    label: 'Benar',
                    value: '$benar',
                    icon: Icons.check_circle,
                    iconColor: const Color(0xFF4CAF50),
                    bgColor: const Color(0xFFCDFF90),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _StatCard(
                    label: 'Salah',
                    value: '$salah',
                    icon: Icons.cancel,
                    iconColor: const Color(0xFFE53935),
                    bgColor: const Color(0xFFFF8A65),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _StatCard(
                    label: 'Waktu',
                    value: waktu,
                    icon: Icons.timer,
                    iconColor: const Color(0xFF2196F3),
                    bgColor: const Color(0xFFFFE082),
                  )),
                ],
              ),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Selesai',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Bottom nav placeholder
            _BottomNavSimple(),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  const _StatCard({
    required this.label, required this.value,
    required this.icon, required this.iconColor, required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 4),
                Text(value,
                    style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavSimple extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.home, color: Color(0xFFE05252), size: 28),
          Icon(Icons.emoji_events, color: Color(0xFFD4A017), size: 28),
          Icon(Icons.play_circle_fill, color: Color(0xFF8B2BE2), size: 28),
          Icon(Icons.calculate, color: Color(0xFF4CAF50), size: 28),
          Icon(Icons.person, color: Colors.white54, size: 28),
        ],
      ),
    );
  }
}

// Simple mascot painter (tanpa cape, lebih simpel)
class _SimpleMascotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final body = Paint()..color = const Color(0xFFE07B3A);
    canvas.drawCircle(Offset(cx, cy - 10), 38, body);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 25), width: 65, height: 55), body);
    final belly = Paint()..color = const Color(0xFFF5DEB3);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 8), width: 42, height: 34), belly);
    final eye = Paint()..color = const Color(0xFF3D1A00);
    canvas.drawCircle(Offset(cx - 10, cy - 16), 5, eye);
    canvas.drawCircle(Offset(cx + 10, cy - 16), 5, eye);
    final shine = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx - 7.5, cy - 18.5), 1.8, shine);
    canvas.drawCircle(Offset(cx + 12.5, cy - 18.5), 1.8, shine);
    final nose = Paint()..color = const Color(0xFF5C2A00);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 7), width: 9, height: 6), nose);
    final cape = Paint()..color = const Color(0xFFC0392B);
    final capePath = Path()
      ..moveTo(cx - 32, cy + 8)
      ..quadraticBezierTo(cx, cy + 60, cx + 32, cy + 8)
      ..quadraticBezierTo(cx + 20, cy + 55, cx, cy + 65)
      ..quadraticBezierTo(cx - 20, cy + 55, cx - 32, cy + 8)
      ..close();
    canvas.drawPath(capePath, cape);
    // Tail
    final tailPath = Path()
      ..moveTo(cx + 30, cy + 20)
      ..cubicTo(cx + 60, cy + 8, cx + 68, cy - 14, cx + 52, cy - 28);
    canvas.drawPath(tailPath, body
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round);
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
