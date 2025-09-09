import 'package:flutter/material.dart';

import '../pupils modules/level/domain/entities/level_entity.dart';

class HomeLevelCard extends StatelessWidget {
  final Level level;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const HomeLevelCard({
    Key? key,
    required this.level,
    required this.isUnlocked,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = _colorForLevel(level.levelNumber);

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // ---- CONTENT ---- //
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                Row(
                  children: [
                    _checkIcon(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        level.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Go to Level button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(.9),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: isUnlocked ? onTap : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.sports_golf,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Go to Level',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isUnlocked
                                ? Colors.black87
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ---- LOCK OVERLAY ---- //
          if (!isUnlocked)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.lock, color: Colors.grey, size: 20),
              ),
            ),
        ],
      ),
    );
  }

  Widget _checkIcon() => Container(
    width: 24,
    height: 24,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.8),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Icon(Icons.check, color: Colors.grey, size: 16),
  );

  Color _colorForLevel(int lvl) {
    switch (lvl) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
