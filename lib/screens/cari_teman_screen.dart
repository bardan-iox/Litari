import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CariTemanScreen extends StatefulWidget {
  const CariTemanScreen({super.key});

  @override
  State<CariTemanScreen> createState() => _CariTemanScreenState();
}

class _CariTemanScreenState extends State<CariTemanScreen> {
  String queryPencarian = '';
  final String currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF11141A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161A22),
        elevation: 0,
        title: const Text(
          'Cari Teman Baru',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Bar pencarian
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  queryPencarian = val.trim().toLowerCase();
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Masukkan username teman...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1E232E),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Daftar user
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(currentUid).snapshots(),
              builder: (context, userSnapshot) {
                // Ambil daftar UID yang KITA ikuti
                List<String> listKitaIkuti = [];
                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                  final myData = userSnapshot.data!.data() as Map<String, dynamic>? ?? {};
                  listKitaIkuti = List<String>.from(myData['friends'] ?? []);
                }

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF3B5998)));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('Tidak ada user terdaftar', style: TextStyle(color: Colors.white54)),
                      );
                    }

                    final semuaUserLain = snapshot.data!.docs.where((doc) => doc.id != currentUid).toList();

                    final userTerfilter = semuaUserLain.where((doc) {
                      final username = (doc.data() as Map<String, dynamic>)['username']?.toString().toLowerCase() ?? '';
                      return username.contains(queryPencarian);
                    }).toList();

                    userTerfilter.sort((a, b) {
                      final dataA = a.data() as Map<String, dynamic>;
                      final dataB = b.data() as Map<String, dynamic>;

                      final listTemanA = List<String>.from(dataA['friends'] ?? []);
                      final listTemanB = List<String>.from(dataB['friends'] ?? []);

                      final bool diaFollowKitaA = listTemanA.contains(currentUid);
                      final bool diaFollowKitaB = listTemanB.contains(currentUid);

                      if (diaFollowKitaA && !diaFollowKitaB) {
                        return -1; 
                      } else if (!diaFollowKitaA && diaFollowKitaB) {
                        return 1; 
                      }
                      return 0;   
                    });

                    if (userTerfilter.isEmpty) {
                      return const Center(
                        child: Text('User tidak ditemukan', style: TextStyle(color: Colors.white54)),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: userTerfilter.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final targetUserDoc = userTerfilter[index];
                        final targetUid = targetUserDoc.id;
                        final userData = targetUserDoc.data() as Map<String, dynamic>;
                        
                        final String name = userData['username'] ?? 'Tanpa Nama';
                        final String photo = userData['photoUrl'] ?? '';

                        final List<String> listTemanTarget = List<String>.from(userData['friends'] ?? []);
                        
                        final bool kitaFollowDia = listKitaIkuti.contains(targetUid);
                        final bool diaFollowKita = listTemanTarget.contains(currentUid);

                        // Tentukan teks tombol dan warna berdasarkan status
                        String teksTombol = 'Ikuti';
                        Color warnaTombol = const Color(0xFF3B5998);
                        bool isDisable = false;

                        if (kitaFollowDia) {
                          teksTombol = 'Sudah Diikuti';
                          warnaTombol = const Color(0xFF2C323F);
                          isDisable = true;
                        } else if (diaFollowKita) {
                          teksTombol = 'Ikuti Balik';
                          warnaTombol = const Color(0xFF4C75A3);
                        }

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E232E),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              // Foto Profil
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white10,
                                ),
                                child: photo.isNotEmpty
                                    ? ClipOval(
                                        child: Image.network(photo, fit: BoxFit.cover),
                                      )
                                    : const Icon(Icons.person, color: Colors.white54, size: 24),
                              ),
                              const SizedBox(width: 14),
                              
                              // Nama User dan status
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (diaFollowKita) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        kitaFollowDia ? '👥 Saling Mengikuti' : '👤 Mengikuti Anda',
                                        style: const TextStyle(
                                          color: Color(0xFF8BB2F9),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              // Tombol Ikuti / Ikuti Balik / Sudah Diikuti
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: warnaTombol,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  elevation: isDisable ? 0 : 2,
                                ),
                                onPressed: isDisable 
                                    ? null 
                                    : () => aksiIkutiTeman(targetUid, name),
                                child: Text(
                                  teksTombol,
                                  style: TextStyle(
                                    color: isDisable ? Colors.white38 : Colors.white, 
                                    fontSize: 12, 
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void aksiIkutiTeman(String targetUid, String targetName) async {
    if (currentUid.isEmpty) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(currentUid);

    try {
      await userRef.update({
        'friends': FieldValue.arrayUnion([targetUid])
      });

            if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
           
            behavior: SnackBarBehavior.floating, 
            margin: const EdgeInsets.only(bottom: 32, left: 50, right: 50), 
            
            shape: const StadiumBorder(
              side: BorderSide(
                color: Color(0xFF2E6943), 
                width: 1.5,
              ),
            ),
            
            backgroundColor: const Color(0xFF141923), 
            
            duration: const Duration(seconds: 2),
           
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                
                const Icon(
                  Icons.check_circle_rounded, 
                  color: Color(0xFF4BB543), 
                  size: 18,
                ),
                const SizedBox(width: 10),
                
                Expanded(
                  child: Text(
                    'Berhasil mengikuti $targetName',
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengikuti: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}