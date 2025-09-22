import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/theme_colors.dart';

class DateTimePickerField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final String? time;
  final String? dateHint;
  final String? timeHint;
  final bool showActualDateTime;
  final VoidCallback? onDateTap;
  final VoidCallback? onTimeTap;
  final LevelType levelType;

  const DateTimePickerField({
    super.key,
    required this.label,
    this.date,
    this.time,
    this.onDateTap,
    this.onTimeTap,
    this.levelType = LevelType.redLevel,
    this.dateHint,
    this.timeHint,
    this.showActualDateTime = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.scaleHeight(16)),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: SizeConfig.scaleWidth(16),
              fontWeight: FontWeight.w600,
              color: levelType.color,
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(8)),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date*',
                      style: TextStyle(
                        fontSize: SizeConfig.scaleWidth(14),
                        color: AppColors.grey900,
                      ),
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(8)),
                    GestureDetector(
                      onTap: onDateTap,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.scaleWidth(12),
                          vertical: SizeConfig.scaleHeight(16),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.grey400),
                          borderRadius: BorderRadius.circular(
                            SizeConfig.scaleWidth(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              showActualDateTime
                                  ? DateFormat('MM/dd/yyyy').format(date!)
                                  : dateHint ?? 'MM/DD/YYYY',
                              style: TextStyle(
                                fontSize: SizeConfig.scaleWidth(14),
                                color: showActualDateTime
                                    ? AppColors.grey900
                                    : AppColors.grey500,
                                fontWeight: showActualDateTime
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                            SvgPicture.asset(
                              'assets/date time/calendar.svg',
                              width: 25,
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: SizeConfig.scaleWidth(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time*',
                      style: TextStyle(
                        fontSize: SizeConfig.scaleWidth(14),
                        color: AppColors.grey900,
                      ),
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(8)),
                    GestureDetector(
                      onTap: onTimeTap,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.scaleWidth(12),
                          vertical: SizeConfig.scaleHeight(16),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey400),
                          color: AppColors.white,

                          borderRadius: BorderRadius.circular(
                            SizeConfig.scaleWidth(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              showActualDateTime
                                  ? time.toString()
                                  : timeHint ?? 'HH:MM',
                              style: TextStyle(
                                fontSize: SizeConfig.scaleWidth(14),
                                color: showActualDateTime
                                    ? AppColors.grey900
                                    : AppColors.grey500,
                                fontWeight: showActualDateTime
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                            SvgPicture.asset(
                              'assets/date time/time.svg',
                              width: 25,
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.scaleHeight(16)),
        ],
      ),
    );
  }
}
