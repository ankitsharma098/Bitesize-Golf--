import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/themes/theme_colors.dart';

class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.scaleWidth(16),
        vertical: SizeConfig.scaleHeight(12),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Session',
              style: TextStyle(
                fontSize: SizeConfig.scaleWidth(16),
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Date',
              style: TextStyle(
                fontSize: SizeConfig.scaleWidth(16),
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Time',
              style: TextStyle(
                fontSize: SizeConfig.scaleWidth(16),
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
