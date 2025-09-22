import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Models/scheduled model/scheduled_model.dart';
import '../../../core/themes/theme_colors.dart';

class SessionsTable extends StatelessWidget {
  final List<SessionModel> sessions;

  const SessionsTable({Key? key, required this.sessions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.scaleWidth(8)),
                topRight: Radius.circular(SizeConfig.scaleWidth(8)),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
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
            ),
          ),
          // Table Body
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(SizeConfig.scaleWidth(8)),
                bottomRight: Radius.circular(SizeConfig.scaleWidth(8)),
              ),
            ),
            child: Column(
              children: sessions.asMap().entries.map((entry) {
                final index = entry.key;
                final session = entry.value;
                final isLast = index == sessions.length - 1;

                return Container(
                  decoration: BoxDecoration(
                    border: !isLast
                        ? Border(
                            bottom: BorderSide(
                              color: AppColors.grey200,
                              width: 1,
                            ),
                          )
                        : null,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.scaleHeight(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            session.sessionNumber.toString(),
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
                            DateFormat('dd/MM/yyyy').format(session.date),
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
                            session.time,
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
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
