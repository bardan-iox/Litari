// Model data untuk bahasa daerah dan materi

enum BahasaDaerah { sunda, jawa, melayu, bali }

class BahasaConfig {
  final BahasaDaerah bahasa;
  final String nama;
  final Color colorOdd;   // warna baris ganjil header
  final Color colorEven;  // warna baris genap header
  final Color colorLocked; // warna locked (gelap)

  const BahasaConfig({
    required this.bahasa,
    required this.nama,
    required this.colorOdd,
    required this.colorEven,
    required this.colorLocked,
  });
}

// Dipanggil dari Dart, jadi Color diimpor di file yang memanggil
// Definisi konstanta ada di bahasa_data.dart
