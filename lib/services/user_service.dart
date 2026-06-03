import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static String? get currentUid => _auth.currentUser?.uid;

  // ════════════════════════════════════════════════════
  //  INISIALISASI USER BARU
  // ════════════════════════════════════════════════════

  static Future<void> initUser(User user) async {
    final doc = _db.collection('users').doc(user.uid);
    final snap = await doc.get();

    if (!snap.exists) {
      await doc.set({
        'uid': user.uid,
        'username': user.displayName ?? 'User',
        'email': user.email ?? '',
        'photoUrl': user.photoURL ?? '',
        'xp': 0,
        'streak': 0,
        'lastActive': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'friends': [],
        'friendRequests': [],
        'lencana': [],
        'materiSelesai': {},
        'totalMateriSelesai': 0,
      });
    } else {
      // Update streak
      await _updateStreak(user.uid);
    }
  }

  // ════════════════════════════════════════════════════
  //  STREAK
  // ════════════════════════════════════════════════════

  static Future<void> _updateStreak(String uid) async {
    final doc = _db.collection('users').doc(uid);
    final snap = await doc.get();
    final data = snap.data()!;

    final lastActive = (data['lastActive'] as Timestamp?)?.toDate();
    final now = DateTime.now();

    if (lastActive != null) {
      final diff = now.difference(lastActive).inDays;
      if (diff == 1) {
        await doc.update({
          'streak': (data['streak'] ?? 0) + 1,
          'lastActive': FieldValue.serverTimestamp(),
        });
      } else if (diff > 1) {
        await doc.update({
          'streak': 1,
          'lastActive': FieldValue.serverTimestamp(),
        });
      }
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

  static Future<void> selesaikanMateri(
      String bahasaKey, String materiKey) async {
    if (currentUid == null) return;
    final doc = _db.collection('users').doc(currentUid);
    final snap = await doc.get();
    final data = snap.data()!;

    final materiSelesai =
        Map<String, dynamic>.from(data['materiSelesai'] ?? {});
    final key = '$bahasaKey.$materiKey';

    if (materiSelesai[key] != true) {
      materiSelesai[key] = true;
      final total = (data['totalMateriSelesai'] ?? 0) + 1;
      final xpBaru = (data['xp'] ?? 0) + 50;

      await doc.update({
        'materiSelesai': materiSelesai,
        'totalMateriSelesai': total,
        'xp': xpBaru,
      });

      await _cekMisi(total);
      await _cekLencana(total, bahasaKey, materiSelesai);
    }
  }

  static Future<bool> isMateriSelesai(
      String bahasaKey, String materiKey) async {
    if (currentUid == null) return false;
    final snap = await _db.collection('users').doc(currentUid).get();
    final data = snap.data()!;
    final materiSelesai =
        Map<String, dynamic>.from(data['materiSelesai'] ?? {});
    return materiSelesai['$bahasaKey.$materiKey'] == true;
  }

  // ════════════════════════════════════════════════════
  //  MISI
  // ════════════════════════════════════════════════════

  static Future<void> _cekMisi(int totalMateri) async {
    if (currentUid == null) return;
    final doc = _db.collection('users').doc(currentUid);
    final snap = await doc.get();
    final data = snap.data()!;
    final lencana = List<String>.from(data['lencana'] ?? []);

    final misiList = {
      'misi_1': 1,
      'misi_3': 3,
      'misi_5': 5,
      'misi_10': 10,
    };

    bool ada = false;
    misiList.forEach((misiKey, target) {
      if (totalMateri >= target && !lencana.contains(misiKey)) {
        lencana.add(misiKey);
        ada = true;
      }
    });

    if (ada) {
      await doc.update({'lencana': lencana});
    }
  }

  // ════════════════════════════════════════════════════
  //  LENCANA
  // ════════════════════════════════════════════════════

  static Future<void> _cekLencana(int total, String bahasaKey,
      Map<String, dynamic> materiSelesai) async {
    if (currentUid == null) return;
    final doc = _db.collection('users').doc(currentUid);
    final snap = await doc.get();
    final data = snap.data()!;
    final lencana = List<String>.from(data['lencana'] ?? []);

    // Lencana selesaikan semua materi per bahasa
    final subMateriPerBahasa = {
      'sunda': 9 * 3, // 9 materi × 3 sub
      'jawa': 3 * 3,
      'melayu': 2 * 3,
      'bali': 2 * 3,
    };

    final target = subMateriPerBahasa[bahasaKey] ?? 0;
    final selesaiDiBahasa = materiSelesai.keys
        .where((k) => k.startsWith('$bahasaKey.'))
        .length;

    final lencanaKey = 'lencana_$bahasaKey';
    if (selesaiDiBahasa >= target && !lencana.contains(lencanaKey)) {
      lencana.add(lencanaKey);
      await doc.update({'lencana': lencana, 'xp': (data['xp'] ?? 0) + 200});
    }
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
      'friends': FieldValue.arrayUnion([fromUid]),
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
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    await _auth.signOut();
  }
}