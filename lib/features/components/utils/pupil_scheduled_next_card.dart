import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Models/scheduled model/scheduled_model.dart';
import '../../../core/themes/theme_colors.dart';

class NextLevelTable extends StatelessWidget {
  final SessionModel nextLevelSession;

  const NextLevelTable({Key? key, required this.nextLevelSession})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Next Level Button
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(16)),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(25)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(12)),
            child: Text(
              'Next Level Starts',
              style: TextStyle(
                fontSize: SizeConfig.scaleWidth(16),
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Next Level Table
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(12)),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '1',
                    style: TextStyle(
                      fontSize: SizeConfig.scaleWidth(16),
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(nextLevelSession.date),
                    style: TextStyle(
                      fontSize: SizeConfig.scaleWidth(16),
                      fontWeight: FontWeight.w500,
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    nextLevelSession.time,
                    style: TextStyle(
                      fontSize: SizeConfig.scaleWidth(16),
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
