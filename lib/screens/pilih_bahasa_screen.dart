import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'materi_screen.dart';

class PilihBahasaScreen extends StatelessWidget {
  const PilihBahasaScreen({super.key});

  static const List<_BahasaItem> _bahasa = [
    _BahasaItem(nama: 'Bahasa Sunda', key: 'sunda'),
    _BahasaItem(nama: 'Bahasa Jawa', key: 'jawa'),
    _BahasaItem(nama: 'Bahasa Melayu', key: 'melayu'),
    _BahasaItem(nama: 'Bahasa Bali', key: 'bali'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              const Text(
                'Bahasa daerah mana yang\ningin kamu pelajari?',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 48),
              ..._bahasa.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: _BahasaButton(
                  nama: item.nama,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MateriScreen(bahasaKey: item.key),
                      ),
                    );
                  },
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _BahasaItem {
  final String nama;
  final String key;
  const _BahasaItem({required this.nama, required this.key});
}

class _BahasaButton extends StatelessWidget {
  final String nama;
  final VoidCallback onTap;

  const _BahasaButton({required this.nama, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceVariant,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.inputBorder, width: 1),
          ),
          elevation: 0,
        ),
        child: Text(
          nama,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
