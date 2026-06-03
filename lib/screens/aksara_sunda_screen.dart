import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════
//  DATA AKSARA SUNDA
// ════════════════════════════════════════════════════════════════

class _AksaraItem {
  final String aksara;
  final String latin;
  const _AksaraItem(this.aksara, this.latin);
}

const List<_AksaraItem> _konsonan = [
  _AksaraItem('ᮊ', 'ka'),
  _AksaraItem('ᮌ', 'ga'),
  _AksaraItem('ᮍ', 'nga'),
  _AksaraItem('ᮎ', 'ca'),
  _AksaraItem('ᮏ', 'ja'),
  _AksaraItem('ᮑ', 'nya'),
  _AksaraItem('ᮒ', 'ta'),
  _AksaraItem('ᮓ', 'da'),
  _AksaraItem('ᮔ', 'na'),
  _AksaraItem('ᮕ', 'pa'),
  _AksaraItem('ᮘ', 'ba'),
  _AksaraItem('ᮙ', 'ma'),
  _AksaraItem('ᮚ', 'ya'),
  _AksaraItem('ᮛ', 'ra'),
  _AksaraItem('ᮜ', 'la'),
  _AksaraItem('ᮝ', 'wa'),
  _AksaraItem('ᮞ', 'sa'),
  _AksaraItem('ᮠ', 'ha'),
  _AksaraItem('ᮖ', 'fa'),
  _AksaraItem('ᮋ', 'qa'),
  _AksaraItem('ᮗ', 'va'),
  _AksaraItem('ᮟ', 'xa'),
  _AksaraItem('ᮐ', 'za'),
  _AksaraItem('ᮮ', 'kha'),
  _AksaraItem('ᮯ', 'sya'),
];

const List<_AksaraItem> _vokal = [
  _AksaraItem('ᮄ', 'a'),
  _AksaraItem('ᮄᮤ', 'i'),
  _AksaraItem('ᮄᮥ', 'u'),
  _AksaraItem('ᮆ', 'e'),
  _AksaraItem('ᮇ', 'o'),
  _AksaraItem('ᮈ', 'eu'),
];

// ════════════════════════════════════════════════════════════════
//  SCREEN
// ════════════════════════════════════════════════════════════════

class AksaraSundaScreen extends StatefulWidget {
  const AksaraSundaScreen({super.key});

  @override
  State<AksaraSundaScreen> createState() => _AksaraSundaScreenState();
}

class _AksaraSundaScreenState extends State<AksaraSundaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGrid(_konsonan, 'konsonan'),
                  _buildGrid(_vokal, 'vokal'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Text(
            'Aksara Sunda',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          tabs: const [
            Tab(text: 'Konsonan'),
            Tab(text: 'Vokal'),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List<_AksaraItem> items, String jenis) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Text(
              'Aksara sunda $jenis',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.72,
              ),
              itemCount: items.length,
              itemBuilder: (context, i) => _AksaraCard(item: items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  CARD AKSARA
// ════════════════════════════════════════════════════════════════

class _AksaraCard extends StatelessWidget {
  final _AksaraItem item;
  const _AksaraCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.inputBorder, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 4),
          Text(
            item.aksara,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            color: AppColors.inputBorder,
          ),
          const SizedBox(height: 3),
          Text(
            item.latin,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  CUSTOM ICON AKSARA SUNDA untuk BottomNav
// ════════════════════════════════════════════════════════════════

class AksaraNavIcon extends StatelessWidget {
  final Color color;
  const AksaraNavIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(28, 28),
      painter: _AksaraPainter(color: color),
    );
  }
}

class _AksaraPainter extends CustomPainter {
  final Color color;
  const _AksaraPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Aksara "ka" ᮊ — disederhanakan jadi bentuk ikonik
    // Garis atas horizontal
    canvas.drawLine(Offset(w * 0.15, h * 0.22), Offset(w * 0.85, h * 0.22), paint);

    // Garis kiri turun
    canvas.drawLine(Offset(w * 0.25, h * 0.22), Offset(w * 0.25, h * 0.62), paint);

    // Garis kanan turun
    canvas.drawLine(Offset(w * 0.75, h * 0.22), Offset(w * 0.75, h * 0.62), paint);

    // Garis tengah horizontal (ciri khas aksara sunda)
    canvas.drawLine(Offset(w * 0.25, h * 0.50), Offset(w * 0.75, h * 0.50), paint);

    // Ekor bawah kiri melengkung ke kanan
    final path = Path()
      ..moveTo(w * 0.25, h * 0.62)
      ..quadraticBezierTo(w * 0.25, h * 0.82, w * 0.50, h * 0.82)
      ..quadraticBezierTo(w * 0.75, h * 0.82, w * 0.75, h * 0.62);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _AksaraPainter old) => old.color != color;
}
