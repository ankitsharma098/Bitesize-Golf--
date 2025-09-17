import 'package:flutter/material.dart';
import '../../pupils%20modules/pupil/data/models/pupil_model.dart';
import '../../../core/themes/theme_colors.dart';
import '../../components/utils/size_config.dart';

class PupilCard extends StatelessWidget {
  final PupilModel pupil;
  final VoidCallback? onRemove;
  final LevelType levelType;

  const PupilCard({
    super.key,
    required this.pupil,
    this.onRemove,
    this.levelType = LevelType.redLevel,
  });

  String _getLevelName(int levelNumber) {
    switch (levelNumber) {
      case 1:
        return 'Red Level';
      case 2:
        return 'Orange Level';
      case 3:
        return 'Yellow Level';
      case 4:
        return 'Green Level';
      case 5:
        return 'Blue Level';
      case 6:
        return 'Purple Level';
      default:
        return 'Red Level';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.scaleHeight(8)),
      padding: EdgeInsets.all(SizeConfig.scaleWidth(12)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: SizeConfig.scaleWidth(20),
            backgroundColor: AppColors.grey400,
            backgroundImage: pupil.avatar != null && pupil.avatar!.isNotEmpty
                ? NetworkImage(pupil.avatar!)
                : null,
            child: pupil.avatar == null || pupil.avatar!.isEmpty
                ? Text(
                    pupil.name.isNotEmpty ? pupil.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontSize: SizeConfig.scaleWidth(14),
                    ),
                  )
                : null,
          ),
          SizedBox(width: SizeConfig.scaleWidth(12)),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pupil.name,
                  style: TextStyle(
                    fontSize: SizeConfig.scaleWidth(16),
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey900,
                  ),
                ),
                SizedBox(width: SizeConfig.scaleWidth(8)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.scaleWidth(8),
                    vertical: SizeConfig.scaleHeight(4),
                  ),
                  decoration: BoxDecoration(
                    color: levelType.lightColor,
                    borderRadius: BorderRadius.circular(
                      SizeConfig.scaleWidth(12),
                    ),
                  ),
                  child: Text(
                    _getLevelName(pupil.currentLevel),
                    style: TextStyle(
                      fontSize: SizeConfig.scaleWidth(12),
                      color: levelType.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onRemove != null)
            InkWell(
              onTap: onRemove,
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
                child: Icon(
                  Icons.close,
                  size: SizeConfig.scaleWidth(20),
                  color: AppColors.grey600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
