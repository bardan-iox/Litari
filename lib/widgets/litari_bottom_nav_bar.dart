import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LitariBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const LitariBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItemData(icon: Icons.home_rounded,         color: Color(0xFFE05252)),
    _NavItemData(icon: Icons.emoji_events_rounded,  color: Color(0xFFD4A017)),
    _NavItemData(icon: Icons.play_circle_filled,    color: Color(0xFF8B2BE2)),
    _NavItemData(icon: Icons.calculate_rounded,     color: Color(0xFF4CAF50)),
    _NavItemData(icon: Icons.person_rounded,        color: Colors.white70),
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
              final selected = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: selected
                      ? BoxDecoration(
                          color: item.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        )
                      : null,
                  child: Icon(
                    item.icon,
                    color: selected ? item.color : Colors.white38,
                    size: 28,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final Color color;
  const _NavItemData({required this.icon, required this.color});
}