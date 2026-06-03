import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/home_screen.dart';
import '../screens/video_screen.dart';
import '../screens/aksara_sunda_screen.dart';
import '../screens/profil_screen.dart';

/// Index mapping:
///  0 = Home
///  1 = Leaderboard (placeholder)
///  2 = Video
///  3 = Aksara Sunda
///  4 = Profil

class LitariBottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const LitariBottomNavBar({super.key, required this.selectedIndex});

  void _onTap(BuildContext context, int i) {
    if (i == selectedIndex) return;

    switch (i) {
      case 0:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
        break;
      case 2:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const VideoScreen()),
          (route) => false,
        );
        break;
      case 3:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AksaraSundaScreen()),
          (route) => false,
        );
        break;
      case 4:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const ProfilScreen()),
          (route) => false,
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                index: 0,
                selected: selectedIndex == 0,
                onTap: (i) => _onTap(context, i),
                color: const Color(0xFFE05252),
              ),
              _NavItem(
                icon: Icons.emoji_events_rounded,
                index: 1,
                selected: selectedIndex == 1,
                onTap: (i) => _onTap(context, i),
                color: const Color(0xFFD4A017),
              ),
              _NavItem(
                icon: Icons.play_circle_filled,
                index: 2,
                selected: selectedIndex == 2,
                onTap: (i) => _onTap(context, i),
                color: const Color(0xFF8B2BE2),
              ),
              _NavItem(
                icon: Icons.abc_rounded,
                index: 3,
                selected: selectedIndex == 3,
                onTap: (i) => _onTap(context, i),
                color: const Color(0xFF4CAF50),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                index: 4,
                selected: selectedIndex == 4,
                onTap: (i) => _onTap(context, i),
                color: Colors.white70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final bool selected;
  final void Function(int) onTap;
  final Color color;

  const _NavItem({
    required this.icon,
    required this.index,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: selected
            ? BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Icon(
          icon,
          color: selected ? color : Colors.white38,
          size: 28,
        ),
      ),
    );
  }
}