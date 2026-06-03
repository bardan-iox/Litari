import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ════════════════════════════════════════════════════
//  ACHIEVEMENT DEFINITION
// ════════════════════════════════════════════════════

/// Satu definisi achievement dengan syarat dan reward XP-nya.
class AchievementDef {
  final String id;
  final String nama;
  final String deskripsi;
  final int xpBonus;

  const AchievementDef({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.xpBonus,
  });
}

/// Daftar semua achievement yang ada di aplikasi.
/// Tambah/ubah di sini untuk memperluas sistem.
const List<AchievementDef> semuaAchievement = [
  // ── Progres materi ───────────────────────────────
  AchievementDef(
    id: 'materi_1',
    nama: 'Langkah Pertama',
    deskripsi: 'Selesaikan 1 materi',
    xpBonus: 50,
  ),
  AchievementDef(
    id: 'materi_5',
    nama: 'Semangat Belajar',
    deskripsi: 'Selesaikan 5 materi',
    xpBonus: 100,
  ),
  AchievementDef(
    id: 'materi_10',
    nama: 'Penjelajah Bahasa',
    deskripsi: 'Selesaikan 10 materi',
    xpBonus: 200,
  ),
  AchievementDef(
    id: 'materi_25',
    nama: 'Ahli Bahasa',
    deskripsi: 'Selesaikan 25 materi',
    xpBonus: 500,
  ),

  // ── Latihan & skor ───────────────────────────────
  AchievementDef(
    id: 'latihan_1',
    nama: 'Mulai Berlatih',
    deskripsi: 'Selesaikan 1 sesi latihan',
    xpBonus: 30,
  ),
  AchievementDef(
    id: 'latihan_10',
    nama: 'Rajin Berlatih',
    deskripsi: 'Selesaikan 10 sesi latihan',
    xpBonus: 150,
  ),
  AchievementDef(
    id: 'latihan_50',
    nama: 'Latihan Tanpa Henti',
    deskripsi: 'Selesaikan 50 sesi latihan',
    xpBonus: 500,
  ),
  AchievementDef(
    id: 'sempurna_1',
    nama: 'Jawaban Sempurna',
    deskripsi: 'Raih skor 100% dalam 1 sesi latihan',
    xpBonus: 100,
  ),
  AchievementDef(
    id: 'sempurna_5',
    nama: 'Konsisten Sempurna',
    deskripsi: 'Raih skor 100% sebanyak 5 kali',
    xpBonus: 300,
  ),

  // ── Streak ───────────────────────────────────────
  AchievementDef(
    id: 'streak_3',
    nama: 'Tiga Hari Berturut',
    deskripsi: 'Belajar 3 hari berturut-turut',
    xpBonus: 75,
  ),
  AchievementDef(
    id: 'streak_7',
    nama: 'Satu Minggu Penuh',
    deskripsi: 'Belajar 7 hari berturut-turut',
    xpBonus: 200,
  ),
  AchievementDef(
    id: 'streak_30',
    nama: 'Dedikasi Sebulan',
    deskripsi: 'Belajar 30 hari berturut-turut',
    xpBonus: 1000,
  ),

  // ── XP milestone ─────────────────────────────────
  AchievementDef(
    id: 'xp_500',
    nama: 'Kolektor XP',
    deskripsi: 'Kumpulkan 500 XP',
    xpBonus: 50,
  ),
  AchievementDef(
    id: 'xp_2000',
    nama: 'Master XP',
    deskripsi: 'Kumpulkan 2.000 XP',
    xpBonus: 200,
  ),
  AchievementDef(
    id: 'xp_5000',
    nama: 'Legenda XP',
    deskripsi: 'Kumpulkan 5.000 XP',
    xpBonus: 500,
  ),

  // ── Per bahasa (selesaikan semua materi satu bahasa) ──
  AchievementDef(
    id: 'lencana_sunda',
    nama: 'Mahir Sunda',
    deskripsi: 'Selesaikan semua materi Bahasa Sunda',
    xpBonus: 300,
  ),
  AchievementDef(
    id: 'lencana_jawa',
    nama: 'Mahir Jawa',
    deskripsi: 'Selesaikan semua materi Bahasa Jawa',
    xpBonus: 300,
  ),
  AchievementDef(
    id: 'lencana_melayu',
    nama: 'Mahir Melayu',
    deskripsi: 'Selesaikan semua materi Bahasa Melayu',
    xpBonus: 300,
  ),
  AchievementDef(
    id: 'lencana_bali',
    nama: 'Mahir Bali',
    deskripsi: 'Selesaikan semua materi Bahasa Bali',
    xpBonus: 300,
  ),

  // ── Sosial ───────────────────────────────────────
  AchievementDef(
    id: 'teman_1',
    nama: 'Punya Teman',
    deskripsi: 'Tambahkan 1 teman',
    xpBonus: 50,
  ),
  AchievementDef(
    id: 'teman_5',
    nama: 'Banyak Teman',
    deskripsi: 'Tambahkan 5 teman',
    xpBonus: 150,
  ),
];

// ════════════════════════════════════════════════════
//  HASIL CEK ACHIEVEMENT
// ════════════════════════════════════════════════════

/// Dikembalikan oleh [UserService.selesaikanLatihan] agar UI bisa
/// menampilkan notifikasi achievement yang baru didapat.
class HasilLatihan {
  final int xpDidapat;
  final List<AchievementDef> achievementBaru;

  const HasilLatihan({
    required this.xpDidapat,
    required this.achievementBaru,
  });
}

// ════════════════════════════════════════════════════
//  USER SERVICE
// ════════════════════════════════════════════════════

class UserService {
  static final _db   = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static String? get currentUid => _auth.currentUser?.uid;

  // ════════════════════════════════════════════════════
  //  INISIALISASI USER BARU
  // ════════════════════════════════════════════════════

  static Future<void> initUser(User user) async {
    final doc  = _db.collection('users').doc(user.uid);
    final snap = await doc.get();

    if (!snap.exists) {
      await doc.set({
        'uid':               user.uid,
        'username':          user.displayName ?? 'User',
        'email':             user.email ?? '',
        'photoUrl':          user.photoURL ?? '',
        'xp':                0,
        'streak':            0,
        'lastActive':        FieldValue.serverTimestamp(),
        'createdAt':         FieldValue.serverTimestamp(),
        'friends':           [],
        'friendRequests':    [],
        'achievements':      [],          // ganti dari 'lencana'
        'materiSelesai':     {},
        'totalMateriSelesai': 0,
        'totalLatihan':      0,           // jumlah sesi latihan selesai
        'totalSempurna':     0,           // jumlah sesi latihan skor 100%
      });
    } else {
      await _updateStreak(user.uid);
    }
  }

  // ════════════════════════════════════════════════════
  //  STREAK HARIAN
  // ════════════════════════════════════════════════════

  /// Dipanggil saat login. Update streak berdasarkan lastActive.
  static Future<void> _updateStreak(String uid) async {
    final doc  = _db.collection('users').doc(uid);
    final snap = await doc.get();
    final data = snap.data()!;

    final lastActive = (data['lastActive'] as Timestamp?)?.toDate();
    final now        = DateTime.now();

    if (lastActive == null) {
      await doc.update({
        'streak':     1,
        'lastActive': FieldValue.serverTimestamp(),
      });
      return;
    }

    // Bandingkan hanya tanggal (abaikan jam)
    final lastDay = DateTime(lastActive.year, lastActive.month, lastActive.day);
    final today   = DateTime(now.year, now.month, now.day);
    final diff    = today.difference(lastDay).inDays;

    if (diff == 0) {
      // Sudah login hari ini, tidak perlu update
      return;
    } else if (diff == 1) {
      // Hari berikutnya → streak naik
      final newStreak = (data['streak'] ?? 0) + 1;
      await doc.update({
        'streak':     newStreak,
        'lastActive': FieldValue.serverTimestamp(),
      });
    } else {
      // Lewat lebih dari 1 hari → streak reset
      await doc.update({
        'streak':     1,
        'lastActive': FieldValue.serverTimestamp(),
      });
    }
  }

  // ════════════════════════════════════════════════════
  //  GET USER DATA
  // ════════════════════════════════════════════════════

  static Stream<DocumentSnapshot> getUserStream() {
    return _db.collection('users').doc(currentUid).snapshots();
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    if (currentUid == null) return null;
    final snap = await _db.collection('users').doc(currentUid).get();
    return snap.data();
  }

  // ════════════════════════════════════════════════════
  //  PROGRES MATERI
  // ════════════════════════════════════════════════════

  static Future<bool> isMateriSelesai(
      String bahasaKey, String materiKey) async {
    if (currentUid == null) return false;
    final snap = await _db.collection('users').doc(currentUid).get();
    final data = snap.data()!;
    final materiSelesai =
        Map<String, dynamic>.from(data['materiSelesai'] ?? {});
    return materiSelesai['$bahasaKey.$materiKey'] == true;
  }

  static Future<void> selesaikanMateri(
      String bahasaKey, String materiKey) async {
    if (currentUid == null) return;
    final doc  = _db.collection('users').doc(currentUid);
    final snap = await doc.get();
    final data = snap.data()!;

    final materiSelesai =
        Map<String, dynamic>.from(data['materiSelesai'] ?? {});
    final key = '$bahasaKey.$materiKey';

    if (materiSelesai[key] != true) {
      materiSelesai[key] = true;
      final total = (data['totalMateriSelesai'] ?? 0) + 1;

      await doc.update({
        'materiSelesai':      materiSelesai,
        'totalMateriSelesai': total,
      });
    }
  }

  // ════════════════════════════════════════════════════
  //  SELESAIKAN LATIHAN (XP + ACHIEVEMENT)
  // ════════════════════════════════════════════════════

  /// Dipanggil dari HasilScreen setelah latihan selesai.
  ///
  /// [benar]      = jumlah jawaban benar
  /// [total]      = total soal dalam sesi
  /// [bahasaKey]  = 'sunda' / 'jawa' / 'melayu' / 'bali'
  /// [materiKey]  = key materi yang dilatih (untuk update progres materi)
  ///
  /// Mengembalikan [HasilLatihan] berisi XP yang didapat dan
  /// daftar achievement baru yang baru saja terbuka.
  static Future<HasilLatihan> selesaikanLatihan({
    required int benar,
    required int total,
    required String bahasaKey,
    required String materiKey,
  }) async {
    if (currentUid == null) {
      return const HasilLatihan(xpDidapat: 0, achievementBaru: []);
    }

    final doc  = _db.collection('users').doc(currentUid);
    final snap = await doc.get();
    final data = snap.data()!;

    // ── Hitung XP dari sesi ini ──────────────────────
    final persen       = total > 0 ? benar / total : 0.0;
    final sempurna     = persen >= 1.0;
    final xpDariSoal   = (benar * 10).toInt();      // 10 XP per jawaban benar
    final bonusSempurna = sempurna ? 50 : 0;         // bonus skor 100%
    final xpSesi       = xpDariSoal + bonusSempurna;

    // ── Update counter ───────────────────────────────
    final xpSekarang      = (data['xp']             ?? 0) + xpSesi;
    final totalLatihan    = (data['totalLatihan']    ?? 0) + 1;
    final totalSempurna   = (data['totalSempurna']   ?? 0) + (sempurna ? 1 : 0);
    final streakSekarang  = (data['streak']          ?? 0);

    // Update materi selesai jika skor ≥ 70%
    final materiSelesai =
        Map<String, dynamic>.from(data['materiSelesai'] ?? {});
    final materiKey_ = '$bahasaKey.$materiKey';
    if (persen >= 0.7 && materiSelesai[materiKey_] != true) {
      materiSelesai[materiKey_] = true;
    }
    final totalMateriSelesai = materiSelesai.values
        .where((v) => v == true)
        .length;

    // ── Cek achievement ──────────────────────────────
    final achievementLama = List<String>.from(data['achievements'] ?? []);
    final achievementBaru = <AchievementDef>[];
    int   xpBonus         = 0;

    void cekAchievement(String id, bool syarat) {
      if (syarat && !achievementLama.contains(id)) {
        final def = semuaAchievement.firstWhere(
          (a) => a.id == id,
          orElse: () => AchievementDef(
              id: id, nama: id, deskripsi: '', xpBonus: 0),
        );
        achievementLama.add(id);
        achievementBaru.add(def);
        xpBonus += def.xpBonus;
      }
    }

    // Progres materi
    cekAchievement('materi_1',  totalMateriSelesai >= 1);
    cekAchievement('materi_5',  totalMateriSelesai >= 5);
    cekAchievement('materi_10', totalMateriSelesai >= 10);
    cekAchievement('materi_25', totalMateriSelesai >= 25);

    // Jumlah sesi latihan
    cekAchievement('latihan_1',  totalLatihan >= 1);
    cekAchievement('latihan_10', totalLatihan >= 10);
    cekAchievement('latihan_50', totalLatihan >= 50);

    // Skor sempurna
    cekAchievement('sempurna_1', totalSempurna >= 1);
    cekAchievement('sempurna_5', totalSempurna >= 5);

    // Streak
    cekAchievement('streak_3',  streakSekarang >= 3);
    cekAchievement('streak_7',  streakSekarang >= 7);
    cekAchievement('streak_30', streakSekarang >= 30);

    // XP milestone (pakai XP SEBELUM bonus achievement supaya tidak rekursif)
    cekAchievement('xp_500',  xpSekarang >= 500);
    cekAchievement('xp_2000', xpSekarang >= 2000);
    cekAchievement('xp_5000', xpSekarang >= 5000);

    // Selesaikan semua materi per bahasa
    final subMateriPerBahasa = {
      'sunda':  9 * 3,
      'jawa':   3 * 3,
      'melayu': 2 * 3,
      'bali':   2 * 3,
    };
    for (final bahasa in subMateriPerBahasa.keys) {
      final target  = subMateriPerBahasa[bahasa]!;
      final selesai = materiSelesai.keys
          .where((k) => k.startsWith('$bahasa.') && materiSelesai[k] == true)
          .length;
      cekAchievement('lencana_$bahasa', selesai >= target);
    }

    // Teman (dibaca dari data yang sudah ada)
    final jumlahTeman = (data['friends'] as List?)?.length ?? 0;
    cekAchievement('teman_1', jumlahTeman >= 1);
    cekAchievement('teman_5', jumlahTeman >= 5);

    // ── Simpan ke Firestore (single write) ───────────
    final xpFinal = xpSekarang + xpBonus;
    await doc.update({
      'xp':                xpFinal,
      'totalLatihan':      totalLatihan,
      'totalSempurna':     totalSempurna,
      'materiSelesai':     materiSelesai,
      'totalMateriSelesai': totalMateriSelesai,
      'achievements':      achievementLama,
      'lastActive':        FieldValue.serverTimestamp(),
    });

    return HasilLatihan(
      xpDidapat:       xpSesi + xpBonus,
      achievementBaru: achievementBaru,
    );
  }

  // ════════════════════════════════════════════════════
  //  PERTEMANAN
  // ════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> cariTeman(String query) async {
    if (currentUid == null) return [];
    final snap = await _db
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(10)
        .get();

    return snap.docs
        .where((d) => d.id != currentUid)
        .map((d) => {...d.data(), 'uid': d.id})
        .toList();
  }

  static Future<void> kirimPermintaanTeman(String targetUid) async {
    if (currentUid == null) return;
    await _db.collection('users').doc(targetUid).update({
      'friendRequests': FieldValue.arrayUnion([currentUid]),
    });
  }

  static Future<void> terimaPermintaanTeman(String fromUid) async {
    if (currentUid == null) return;
    final batch = _db.batch();

    batch.update(_db.collection('users').doc(currentUid), {
      'friends':        FieldValue.arrayUnion([fromUid]),
      'friendRequests': FieldValue.arrayRemove([fromUid]),
    });

    batch.update(_db.collection('users').doc(fromUid), {
      'friends': FieldValue.arrayUnion([currentUid]),
    });

    await batch.commit();
  }

  static Future<void> tolakPermintaanTeman(String fromUid) async {
    if (currentUid == null) return;
    await _db.collection('users').doc(currentUid).update({
      'friendRequests': FieldValue.arrayRemove([fromUid]),
    });
  }

  static Future<List<Map<String, dynamic>>> getDaftarTeman() async {
    if (currentUid == null) return [];
    final snap = await _db.collection('users').doc(currentUid).get();
    final data = snap.data()!;
    final friends = List<String>.from(data['friends'] ?? []);

    if (friends.isEmpty) return [];

    final temanSnap = await _db
        .collection('users')
        .where(FieldPath.documentId, whereIn: friends)
        .get();

    return temanSnap.docs
        .map((d) => {...d.data(), 'uid': d.id})
        .toList();
  }

  // ════════════════════════════════════════════════════
  //  LOGOUT
  // ════════════════════════════════════════════════════

  static Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }
}