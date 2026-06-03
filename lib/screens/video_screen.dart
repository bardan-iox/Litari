import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../theme/app_theme.dart';
import '../widgets/litari_bottom_nav_bar.dart';
import 'home_screen.dart';
import 'profil_screen.dart';

// ════════════════════════════════════════════════════════════════
//  DATA VIDEO
// ════════════════════════════════════════════════════════════════

class VideoItem {
  final String judul;
  final String kreator;
  final String youtubeId;
  final String kategori;

  const VideoItem({
    required this.judul,
    required this.kreator,
    required this.youtubeId,
    required this.kategori,
  });

  String get thumbnailUrl =>
      'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg';
}

const List<VideoItem> _semuaVideo = [
  // ── Pelajaran Bahasa Pemula ──────────────────────────────
  VideoItem(
    judul: 'BELAJAR BAHASA JAWA PEMULA #11 BASA JAWA KRAMA BERTAMU',
    kreator: 'Arofa Defaki',
    youtubeId: 'u1j9uwNLJ7c',
    kategori: 'Pelajaran Bahasa Pemula',
  ),
  VideoItem(
    judul: 'Ngamumulé Basa Sunda (Melestarikan Bahasa Sunda) [Belajar Bahasa Sunda Episode 1]',
    kreator: 'TheBudakBageur',
    youtubeId: 'HkR0vVEQ-MY',
    kategori: 'Pelajaran Bahasa Pemula',
  ),

  // ── Sejarah Bahasa ───────────────────────────────────────
  VideoItem(
    judul: 'Mengupas Tuntas Asal Usul, Legenda dan Penyebaran Suku Jawa, Suku Terbesar Di Indonesia',
    kreator: 'Daftar Populer',
    youtubeId: '6Rk2IfGlHMs',
    kategori: 'Sejarah Bahasa',
  ),
  VideoItem(
    judul: 'Siapa Manusia Pertama yang Berbahasa Sunda? Fakta Sejarah yang Jarang Dibahas',
    kreator: 'Arcanadjawa',
    youtubeId: 'JeCK5yHTIMU',
    kategori: 'Sejarah Bahasa',
  ),

  // ── Adat Budaya ──────────────────────────────────────────
  VideoItem(
    judul: 'PESONA ALAM BUDAYA JATENG! Mengenal Suku, Keliling Kabupaten & Kota yang Ada di Jawa Tengah',
    kreator: 'Daftar Populer',
    youtubeId: '6T_cnhn82Ac',
    kategori: 'Adat Budaya',
  ),
  VideoItem(
    judul: 'Kagum dengan Kebudayaan Suku Sunda? Ini Dia Fakta Menarik yang Wajib Anda Ketahui',
    kreator: 'Three Tan Java',
    youtubeId: 'jJB53_29v5Y',
    kategori: 'Adat Budaya',
  ),
];

const List<String> _kategoriList = [
  'Pelajaran Bahasa Pemula',
  'Sejarah Bahasa',
  'Adat Budaya',
];

// ════════════════════════════════════════════════════════════════
//  VIDEO LIST SCREEN
// ════════════════════════════════════════════════════════════════

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  int _selectedNavIndex = 2;

  List<VideoItem> get _filtered => _query.isEmpty
      ? _semuaVideo
      : _semuaVideo
          .where((v) =>
              v.judul.toLowerCase().contains(_query.toLowerCase()) ||
              v.kreator.toLowerCase().contains(_query.toLowerCase()) ||
              v.kategori.toLowerCase().contains(_query.toLowerCase()))
          .toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: _filtered.isEmpty
                  ? _buildEmpty()
                  : ListView(
                      physics: const BouncingScrollPhysics(),
                      children: _kategoriList.map((kat) {
                        final videos =
                            _filtered.where((v) => v.kategori == kat).toList();
                        if (videos.isEmpty) return const SizedBox.shrink();
                        return _KategoriSection(
                          kategori: kat,
                          videos: videos,
                          onTap: (video) => _bukaVideo(context, video, videos),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: LitariBottomNavBar(
        currentIndex: _selectedNavIndex,
        onTap: (i) {
          if (i == 0) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          } else if (i == 4) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ProfilScreen(),
              ),
            );
          } else {
            setState(() => _selectedNavIndex = i);
          }
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: 'Cari video...',
            hintStyle: const TextStyle(color: AppColors.textHint),
            prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textHint),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded, color: Colors.white30, size: 56),
          const SizedBox(height: 12),
          Text(
            'Video "$_query" tidak ditemukan',
            style: const TextStyle(color: Colors.white38, fontSize: 15),
          ),
        ],
      ),
    );
  }

  void _bukaVideo(
      BuildContext context, VideoItem video, List<VideoItem> playlist) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VideoDetailScreen(video: video, playlist: playlist),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  SECTION KATEGORI
// ════════════════════════════════════════════════════════════════

class _KategoriSection extends StatelessWidget {
  final String kategori;
  final List<VideoItem> videos;
  final void Function(VideoItem) onTap;

  const _KategoriSection({
    required this.kategori,
    required this.videos,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            kategori,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
            children:
                videos.map((v) => _VideoCard(video: v, onTap: onTap)).toList(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  VIDEO CARD
// ════════════════════════════════════════════════════════════════

class _VideoCard extends StatelessWidget {
  final VideoItem video;
  final void Function(VideoItem) onTap;

  const _VideoCard({required this.video, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(video),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                video.thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.surfaceVariant,
                  child: const Icon(
                    Icons.play_circle_outline,
                    color: Colors.white30,
                    size: 40,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              const Center(
                child: Icon(
                  Icons.play_circle_filled,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  VIDEO DETAIL SCREEN (player)
// ════════════════════════════════════════════════════════════════

class VideoDetailScreen extends StatefulWidget {
  final VideoItem video;
  final List<VideoItem> playlist;

  const VideoDetailScreen({
    super.key,
    required this.video,
    required this.playlist,
  });

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  late YoutubePlayerController _controller;
  late VideoItem _currentVideo;

  @override
  void initState() {
    super.initState();
    _currentVideo = widget.video;
    _controller = YoutubePlayerController.fromVideoId(
      videoId: _currentVideo.youtubeId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
      ),
    );
  }

  void _gantiVideo(VideoItem video) {
    setState(() {
      _currentVideo = video;
      _controller.loadVideoById(videoId: video.youtubeId);
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
  child: ListView(
    physics: const BouncingScrollPhysics(),
    children: [
      // ── Tombol back ───────────────────────────────
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Text(
                _currentVideo.judul,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),

      // ── Player ────────────────────────────────────
      SizedBox(
        height: 220,
        child: YoutubePlayer(
          controller: _controller,
          aspectRatio: 16 / 9,
        ),
      ),
            const SizedBox(height: 16),

            // ── Info video ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentVideo.judul,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currentVideo.kreator,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Video terkait ──────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Video Lainnya',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),

            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: widget.playlist.length,
                itemBuilder: (context, i) {
                  final v = widget.playlist[i];
                  final isPlaying = v.youtubeId == _currentVideo.youtubeId;
                  return GestureDetector(
                    onTap: () => _gantiVideo(v),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isPlaying
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isPlaying
                              ? AppColors.primary
                              : AppColors.inputBorder,
                          width: isPlaying ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 80,
                              height: 52,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    v.thumbnailUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: AppColors.surfaceVariant,
                                    ),
                                  ),
                                  if (!isPlaying)
                                    const Center(
                                      child: Icon(
                                        Icons.play_circle_filled,
                                        color: Colors.white70,
                                        size: 24,
                                      ),
                                    ),
                                  if (isPlaying)
                                    Container(
                                      color: Colors.black45,
                                      child: const Center(
                                        child: Icon(
                                          Icons.equalizer_rounded,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  v.judul,
                                  style: TextStyle(
                                    color: isPlaying
                                        ? AppColors.primary
                                        : Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  v.kreator,
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            
          ],
        ),
      ),
    );
  }
}