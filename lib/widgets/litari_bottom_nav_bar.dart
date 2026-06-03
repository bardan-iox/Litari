import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────
//  LitariBottomNavBar — shared bottom navigation widget
//
//  Usage:
//    bottomNavigationBar: LitariBottomNavBar(
//      currentIndex: _selectedNavIndex,
//      onTap: (i) {
//        // handle navigation
//      },
//    )
//
//  Tab indices:
//    0 = Home
//    1 = Leaderboard
//    2 = Video
//    3 = Latihan (ABC)
//    4 = Profile
// ─────────────────────────────────────────────────────────────

class LitariBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const LitariBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_NavItemData> _items = [
    _NavItemData(icon: Icons.home_rounded,        color: Color(0xFFE05252), label: 'Beranda'),
    _NavItemData(icon: Icons.emoji_events_rounded, color: Color(0xFFD4A017), label: 'Peringkat'),
    _NavItemData(icon: Icons.play_circle_filled,   color: Color(0xFF8B2BE2), label: 'Video'),
    _NavItemData(icon: Icons.abc_outlined,         color: Color(0xFF4CAF50), label: 'Latihan'),
    _NavItemData(icon: Icons.person_rounded,       color: Colors.white70,   label: 'Profil'),
  ];

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
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final selected = currentIndex == i;
              return _NavItem(
                icon: item.icon,
                color: item.color,
                label: item.label,
                index: i,
                selected: selected,
                onTap: onTap,
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Internal data model
// ─────────────────────────────────────────────────────────────

class _NavItemData {
  final IconData icon;
  final Color color;
  final String label;

  const _NavItemData({
    required this.icon,
    required this.color,
    required this.label,
  });
}

// ─────────────────────────────────────────────────────────────
//  Individual nav item with animated highlight
// ─────────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int index;
  final bool selected;
  final void Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.index,
    required this.selected,
    required this.onTap,
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