import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:litari/widgets/litari_bottom_nav_bar.dart';
import '../services/user_service.dart';
import '../theme/app_theme.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
import 'video_screen.dart';
import 'aksara_sunda_screen.dart';
import 'cari_teman_screen.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  Future<void> _logout(BuildContext context) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Keluar Akun',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      ),
      content: const Text(
        'Kamu yakin ingin keluar?',
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text('Batal', style: TextStyle(color: AppColors.primary)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Keluar', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );

  if (confirm == true) {
    await UserService.logout();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SplashScreen()),
        (route) => false,
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: UserService.getUserStream(),
      builder: (context, snapshot) {
        final data =
            snapshot.data?.data() as Map<String, dynamic>? ?? {};

        return Scaffold(
          backgroundColor: AppColors.background,
          bottomNavigationBar: const LitariBottomNavBar(selectedIndex: 4),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(context, data),
                  const SizedBox(height: 20),
                  _buildDaftarTeman(context,data),
                  const SizedBox(height: 20),
                  _buildRingkasan(data),
                  const SizedBox(height: 20),
                  _buildLencana(data),
                  const SizedBox(height: 20),
                  _buildPencapaian(data),
                  const SizedBox(height: 24),
                  _buildLogoutButton(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Profile Header ────────────────────────────────
Widget _buildProfileHeader(
      BuildContext context, Map<String, dynamic> data) {
    final username = data['username'] as String? ?? '—';
    final photoUrl = data['photoUrl'] as String? ?? '';
    final xp = data['xp'] as int? ?? 0;
    final streak = data['streak'] as int? ?? 0;
    
    final followingCount = (data['friends'] as List?)?.length ?? 0;
    final String currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.inputBorder, width: 2),
            ),
            child: photoUrl.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.person,
                          color: Colors.white54,
                          size: 52),
                    ),
                  )
                : const Icon(Icons.person, color: Colors.white54, size: 52),
          ),
          const SizedBox(height: 12),
          // Username
          Text(
            username,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          // XP chip
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.primary.withOpacity(0.4)),
            ),
            child: Text(
              '$xp XP',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // kotak mengikuti
              _StatBox(
                label: 'Mengikuti', 
                value: '$followingCount',
              ),
              const SizedBox(width: 12), 
              
              // kotak pengikut
              StreamBuilder<int>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('friends', arrayContains: currentUid)
                    .snapshots()
                    .map((snapshot) => snapshot.docs.length),
                builder: (context, snapshot) {
                  final int followersCount = snapshot.data ?? 0;
                  return _StatBox(
                    label: 'Pengikut', 
                    value: '$followersCount',
                  );
                },
              ),
              const SizedBox(width: 12), 
              
              // kotak streak
              _StatBox(
                label: 'Streak',
                value: '🔥 $streak',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Daftar Teman ──────────────────────────────────

 Widget _buildDaftarTeman(BuildContext context, Map<String, dynamic> data) {
  final friendIds = List<String>.from(data['friends'] ?? []);

  // Tombol +
  final tombolTambahOranye = GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CariTemanScreen(), 
        ),
      );
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 52, 
          height: 52,
          decoration: const BoxDecoration(
            color: Color(0xFFE07A5F), 
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white, 
            size: 28,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tambah', 
          style: TextStyle(
            color: Colors.white54, 
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADLINE
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Daftar Teman',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Lihat Daftar',
              style: TextStyle(
                color: const Color(0xFFE07A5F), 
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // KOTAK UTAMA DAFTAR TEMAN 
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surface, 
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.inputBorder, width: 1.5), 
          ),
          child: Row(
            children: [
              // KIRI : Daftar Teman
              Expanded(
                child: friendIds.isEmpty
                    ? const SizedBox(
                        height: 95,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Belum ada teman.\nYuk, cari teman baru dan terhubung bersama!',
                            style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.3),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 95,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: friendIds.length, 
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (ctx, i) {
                            return _TemanCardRemote(uid: friendIds[i]);
                          },
                        ),
                      ),
              ),

              // KANAN: Pembatas & Tombol Tambah
              if (friendIds.isNotEmpty) ...[
                Container(
                  height: 50,
                  width: 1,
                  color: Colors.white10,
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                ),
              ] else ...[
                const SizedBox(width: 14),
              ],
              
              tombolTambahOranye,
            ],
          ),
        ),
      ],
    ),
  );
}

// Fungsi Backend: Menambahkan UID teman ke dalam array 'friends' di Firestore
void _tambahTemanFirebase(String targetUid) async {
  String myUid = FirebaseAuth.instance.currentUser!.uid;

  await FirebaseFirestore.instance.collection('users').doc(myUid).update({
    'friends': FieldValue.arrayUnion([targetUid])
  });
}

  // ─── Ringkasan ─────────────────────────────────────

  Widget _buildRingkasan(Map<String, dynamic> data) {
    final materiSelesai =
        Map<String, dynamic>.from(data['materiSelesai'] ?? {});
    final totalSelesai = data['totalMateriSelesai'] as int? ?? 0;

    final selesaiKeys = materiSelesai.keys
        .where((k) => materiSelesai[k] == true)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          selesaiKeys.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: const Text(
                    'Belum ada materi yang diselesaikan.',
                    style:
                        TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                )
              : GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3,
                  children: selesaiKeys
                      .take(4)
                      .map((k) => _RingkasanItem(label: k.replaceAll('.', ' '))).toList()
                      .toList(),
                ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    color: Colors.white54, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Total Materi Selesai: $totalSelesai',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Lencana ───────────────────────────────────────

  Widget _buildLencana(Map<String, dynamic> data) {
    final lencana = List<String>.from(data['lencana'] ?? []);

    final lencanaDisplay = {
      'misi_1': {'color': const Color(0xFFCD7F32), 'label': '1 Materi'},
      'misi_3': {'color': const Color(0xFFC0C0C0), 'label': '3 Materi'},
      'misi_5': {'color': const Color(0xFFFFD700), 'label': '5 Materi'},
      'misi_10': {'color': AppColors.primary, 'label': '10 Materi'},
      'lencana_sunda': {
        'color': const Color(0xFF4CAF50),
        'label': 'Sunda'
      },
      'lencana_jawa': {
        'color': const Color(0xFFFF9800),
        'label': 'Jawa'
      },
      'lencana_melayu': {
        'color': const Color(0xFF2196F3),
        'label': 'Melayu'
      },
      'lencana_bali': {
        'color': const Color(0xFFE91E63),
        'label': 'Bali'
      },
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lencana',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${lencana.length} diraih',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: lencanaDisplay.entries.map((e) {
              final earned = lencana.contains(e.key);
              final color = e.value['color'] as Color;
              final label = e.value['label'] as String;
              return _LencanaItem(
                  color: color, label: label, earned: earned);
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Pencapaian ────────────────────────────────────

  Widget _buildPencapaian(Map<String, dynamic> data) {
    final lencana = List<String>.from(data['lencana'] ?? []);
    final totalMateri = data['totalMateriSelesai'] as int? ?? 0;
    final xp = data['xp'] as int? ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pencapaian',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _PencapaianCard(
                  icon: Icons.emoji_events_rounded,
                  color: const Color(0xFFFFD700),
                  label: 'Lencana',
                  value: '${lencana.length}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PencapaianCard(
                  icon: Icons.menu_book_rounded,
                  color: AppColors.primary,
                  label: 'Materi',
                  value: '$totalMateri',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PencapaianCard(
                  icon: Icons.star_rounded,
                  color: const Color(0xFF9C27B0),
                  label: 'Total XP',
                  value: '$xp',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Logout Button ─────────────────────────────────

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
          label: const Text(
            'Keluar Akun',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.redAccent, width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}

// ─── Widget Helpers ────────────────────────────────────────────────────────

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Kartu teman yang load data dari Firestore berdasarkan UID
class _TemanCardRemote extends StatelessWidget {
  final String uid;
  const _TemanCardRemote({required this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(uid).get(),
      builder: (ctx, snap) {
        final data =
            snap.data?.data() as Map<String, dynamic>? ?? {};
        final name = data['username'] as String? ?? '…';
        final photo = data['photoUrl'] as String? ?? '';

       return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56, 
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceVariant,
            ),
            child: photo.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      photo,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person,
                        color: Colors.white54,
                        size: 32,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.person,
                    color: Colors.white54, 
                    size: 32,
                  ),
          ),
          const SizedBox(height: 6), 
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      );
    },
  );
}
}

class _RingkasanItem extends StatelessWidget {
  final String label;
  const _RingkasanItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.inputBorder),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _LencanaItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool earned;
  const _LencanaItem(
      {required this.color, required this.label, required this.earned});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: earned
                ? color.withOpacity(0.15)
                : Colors.white10,
            border: Border.all(
              color: earned ? color : Colors.white24,
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.star_rounded,
              color: earned ? color : Colors.white24,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: earned ? Colors.white70 : Colors.white30,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _PencapaianCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  const _PencapaianCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style:
                const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}