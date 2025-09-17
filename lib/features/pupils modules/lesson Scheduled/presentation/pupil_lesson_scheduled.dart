import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/theme_colors.dart';
import '../../../coach module/schedul session/data/model/session_schedule_model.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/utils/pupil_scheduled_lesson_header.dart';
import '../../../components/utils/pupil_scheduled_lesson_sesson_card.dart';
import '../../../components/utils/pupil_scheduled_next_card.dart';
import '../../../components/utils/size_config.dart';
import '../bloc/pupil_lesson_scheduled_bloc.dart';
import '../bloc/pupil_lesson_scheduled_event.dart';
import '../bloc/pupil_lesson_scheduled_state.dart';
import '../data/pupil_lesson_scheduled_repo.dart';

class LessonScheduleScreen extends StatelessWidget {
  final String pupilId;

  const LessonScheduleScreen({Key? key, required this.pupilId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LessonScheduleBloc(repository: PupilLessonScheduledRepo())
            ..add(LoadLessonSchedule(pupilId)),
      child: LessonScheduleView(pupilId: pupilId),
    );
  }
}

class LessonScheduleView extends StatelessWidget {
  final String pupilId;

  const LessonScheduleView({Key? key, required this.pupilId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withCustomAppBar(
      appBar: AppBar(
        title: Text(
          'Lesson Schedule',
          style: TextStyle(
            color: AppColors.white,
            fontSize: SizeConfig.scaleWidth(18),
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.white.withOpacity(0.5),
              ),
              child: Icon(Icons.close, color: AppColors.white),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        elevation: 0,
      ),
      body: BlocConsumer<LessonScheduleBloc, LessonScheduleState>(
        listener: (context, state) {
          if (state is LessonScheduleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LessonScheduleLoading ||
              state is LessonScheduleInitial) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.error),
            );
          }

          if (state is LessonScheduleError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading schedule',
                    style: TextStyle(color: AppColors.error),
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(16)),
                  ElevatedButton(
                    onPressed: () {
                      context.read<LessonScheduleBloc>().add(
                        LoadLessonSchedule(pupilId),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is LessonScheduleLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.scaleHeight(16)),

                  if (state.allSessions.isNotEmpty)
                    _buildSessionTable(state.allSessions, false),

                  SizedBox(height: SizeConfig.scaleHeight(16)),
                  if (state.nextLevelSession != null)
                    _buildSessionTable([state.nextLevelSession!], true),

                  const ScheduleNotice(),

                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.scaleHeight(24)),
                    width: SizeConfig.scaleWidth(134),
                    height: SizeConfig.scaleHeight(5),
                    decoration: BoxDecoration(
                      color: AppColors.grey900,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSessionTable(List<SessionModel> sessions, bool isNextLevel) {
    if (isNextLevel) {
      return Column(
        children: [
          // Custom header for next level
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(12)),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.scaleWidth(8)),
                topRight: Radius.circular(SizeConfig.scaleWidth(8)),
              ),
            ),
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
          // Table for data rows only
          Table(
            border: TableBorder(
              horizontalInside: BorderSide(color: AppColors.grey200, width: 1),
              verticalInside: BorderSide(color: AppColors.grey200, width: 1),
              bottom: BorderSide(color: AppColors.grey200, width: 1),
              left: BorderSide(color: AppColors.grey200, width: 1),
              right: BorderSide(color: AppColors.grey200, width: 1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(SizeConfig.scaleWidth(8)),
                bottomRight: Radius.circular(SizeConfig.scaleWidth(8)),
              ),
            ),
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1),
            },
            children: sessions.asMap().entries.map((entry) {
              final index = entry.key;
              final session = entry.value;
              return TableRow(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: index == sessions.length - 1
                      ? BorderRadius.only(
                          bottomLeft: Radius.circular(SizeConfig.scaleWidth(8)),
                          bottomRight: Radius.circular(
                            SizeConfig.scaleWidth(8),
                          ),
                        )
                      : null,
                ),
                children: [
                  _buildTableCell((index + 1).toString()),
                  _buildTableCell(
                    DateFormat('dd/MM/yyyy').format(session.date),
                    isDate: true,
                  ),
                  _buildTableCell(session.time),
                ],
              );
            }).toList(),
          ),
        ],
      );
    }

    // Regular table for normal sessions
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
      ),
      child: Table(
        border: TableBorder(
          horizontalInside: BorderSide(color: AppColors.grey200, width: 1),
          verticalInside: BorderSide(color: AppColors.grey200, width: 1),
          borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
        ),
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(1),
        },
        children: [
          // Header
          TableRow(
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.scaleWidth(8)),
                topRight: Radius.circular(SizeConfig.scaleWidth(8)),
              ),
            ),
            children: [
              _buildTableCell('Session', isHeader: true),
              _buildTableCell('Date', isHeader: true),
              _buildTableCell('Time', isHeader: true),
            ],
          ),
          // Data Rows
          ...sessions.asMap().entries.map((entry) {
            final index = entry.key;
            final session = entry.value;
            return TableRow(
              decoration: BoxDecoration(
                color: AppColors.white,
                border: index == sessions.length - 1
                    ? null
                    : Border(
                        bottom: BorderSide(color: AppColors.grey200, width: 1),
                      ),
              ),
              children: [
                _buildTableCell(session.sessionNumber.toString()),
                _buildTableCell(
                  DateFormat('dd/MM/yyyy').format(session.date),
                  isDate: true,
                ),
                _buildTableCell(session.time),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    bool isDate = false,
    int colspan = 1,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.scaleHeight(12),
        horizontal: SizeConfig.scaleWidth(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: SizeConfig.scaleWidth(16),
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.w500,
          color: isHeader
              ? AppColors.white
              : isDate
              ? AppColors.redDark
              : AppColors.grey900,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ScheduleNotice extends StatelessWidget {
  const ScheduleNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.scaleHeight(24)),
      padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.grey400,
      ),
      child: Text(
        'These session dates may be subject to change.\n'
        'All payments are due on or before\n'
        'session 1 of each course.\n\n'
        'As levels progress interim sessions may be\n'
        'needed to reach the required standards. This\n'
        'means it should not be assumed that pupils\n'
        'progress automatically to the next level every\n'
        'six weeks. It is purely at the discretion of the\n'
        'Bitesize Golf coach.',
        style: TextStyle(
          fontSize: SizeConfig.scaleWidth(12),
          color: AppColors.grey900,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
