import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class TabBarComponent extends StatelessWidget {
  final List<TabItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final LevelType? levelType;

  const TabBarComponent({
    Key? key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
    this.levelType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          int index = entry.key;
          TabItem tab = entry.value;
          bool isSelected = index == currentIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(index),
              child: Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (levelType?.color ?? AppColors.blueDark)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    tab.label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.grey600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TabItem {
  final String label;
  final IconData? icon;

  const TabItem({required this.label, this.icon});
}
