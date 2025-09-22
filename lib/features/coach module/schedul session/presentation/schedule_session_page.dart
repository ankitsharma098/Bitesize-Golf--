// create_schedule_screen.dart
import 'package:bitesize_golf/features/coach%20module/schedul%20session/presentation/select_pupil_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../Models/coaches model/coach_model.dart';
import '../../../../Models/user model/user_model.dart';
import '../../../../core/themes/theme_colors.dart';
import '../../../../core/utils/user_utils.dart';
import '../../../auth/repositories/auth_repo.dart';
import '../../../components/custom_date_time.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/utils/select_pupil_card.dart';
import '../bloc/session_scheduled_bloc.dart';
import '../bloc/session_scheduled_event.dart';
import '../bloc/session_scheduled_state.dart';
import '../../../components/utils/size_config.dart';
import '../../../components/custom_button.dart';
import '../repo/scheduled_session_repo.dart';

class CreateScheduleScreen extends StatelessWidget {
  const CreateScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CoachModel?>(
      future: UserUtil().getCurrentCoach(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("No coach profile found"));
        }

        final coach = snapshot.data!;
        final coachId = coach.id;
        final clubId = coach.assignedClubId ?? "";

        return BlocProvider(
          create: (context) =>
              CreateScheduleBloc(repository: ScheduleRepository())
                ..add(LoadExistingSchedule(coachId: coachId, levelNumber: 1)),
          child: CreateScheduleScreenView(
            coachId: coachId,
            clubId: clubId,
            levelNumber: 1,
          ),
        );
      },
    );
  }
}

class CreateScheduleScreenView extends StatelessWidget {
  final String coachId;
  final String clubId;
  final int levelNumber;

  const CreateScheduleScreenView({
    super.key,
    required this.coachId,
    required this.clubId,
    required this.levelNumber,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withCustomAppBar(
      appBar: AppBar(
        title: BlocBuilder<CreateScheduleBloc, CreateScheduleState>(
          builder: (context, state) {
            String title = 'Create Schedule Form';
            if (state is CreateScheduleLoaded && state.isUpdate) {
              title = 'Update Schedule Form';
            }
            return Text(
              title,
              style: TextStyle(
                color: AppColors.white,
                fontSize: SizeConfig.scaleWidth(18),
                fontWeight: FontWeight.w600,
              ),
            );
          },
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
                color: AppColors.redLight.withOpacity(0.5),
              ),
              child: Icon(Icons.close, color: AppColors.grey900),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        elevation: 0,
      ),
      body: BlocConsumer<CreateScheduleBloc, CreateScheduleState>(
        listener: (context, state) {
          if (state is CreateScheduleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is CreateScheduleSuccess) {
            final message =
                context.read<CreateScheduleBloc>().state
                        is CreateScheduleLoaded &&
                    (context.read<CreateScheduleBloc>().state
                            as CreateScheduleLoaded)
                        .isUpdate
                ? 'Schedule updated successfully!'
                : 'Schedule created successfully!';

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is CreateScheduleInitial ||
              state is CreateScheduleLoading) {
            return Center(
              child: CircularProgressIndicator(color: LevelType.redLevel.color),
            );
          }

          if (state is CreateScheduleError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(color: AppColors.error),
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(16)),
                  CustomButtonFactory.primary(
                    text: 'Retry',
                    onPressed: () {
                      context.read<CreateScheduleBloc>().add(
                        LoadExistingSchedule(
                          coachId: coachId,
                          levelNumber: levelNumber,
                        ),
                      );
                    },
                    levelType: LevelType.redLevel,
                  ),
                ],
              ),
            );
          }

          if (state is CreateScheduleLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show status indicator
                  if (state.isUpdate) _buildUpdateIndicator(),
                  _buildPupilsSection(context, state),
                  SizedBox(height: SizeConfig.scaleHeight(24)),
                  _buildSessionsSection(context, state),
                  SizedBox(height: SizeConfig.scaleHeight(24)),
                  _buildSelectedPupilsSection(context, state),
                  SizedBox(height: SizeConfig.scaleHeight(16)),
                  _buildNoticeSection(),
                  SizedBox(height: SizeConfig.scaleHeight(16)),
                  _buildSendButton(context, state),
                  SizedBox(height: SizeConfig.scaleHeight(32)),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildUpdateIndicator() {
    return Container(
      margin: EdgeInsets.all(SizeConfig.scaleWidth(16)),
      padding: EdgeInsets.all(SizeConfig.scaleWidth(12)),
      decoration: BoxDecoration(
        color: AppColors.orangeLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
        border: Border.all(color: AppColors.orangeLight),
      ),
      child: Row(
        children: [
          Icon(Icons.edit, size: SizeConfig.scaleWidth(20)),
          SizedBox(width: SizeConfig.scaleWidth(8)),
          Expanded(
            child: Text(
              'Updating existing schedule. Your previous selections are loaded.',
              style: TextStyle(
                fontSize: SizeConfig.scaleWidth(14),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPupilsSection(BuildContext context, CreateScheduleLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(16)),
          child: Text(
            'Pupils',
            style: TextStyle(
              fontSize: SizeConfig.scaleWidth(16),
              fontWeight: FontWeight.w600,
              color: AppColors.grey900,
            ),
          ),
        ),
        SizedBox(height: SizeConfig.scaleHeight(12)),
        Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(16)),
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
          ),
          child: ListTile(
            title: Text(
              'Select pupils',
              style: TextStyle(
                fontSize: SizeConfig.scaleWidth(16),
                color: AppColors.grey900,
              ),
            ),
            subtitle: state.selectedPupilIds.isNotEmpty
                ? Text(
                    '${state.selectedPupilIds.length} pupils selected',
                    style: TextStyle(
                      fontSize: SizeConfig.scaleWidth(14),
                      color: AppColors.grey600,
                    ),
                  )
                : null,
            trailing: SvgPicture.asset(
              'assets/images/navigation.svg',
              width: 20,
              height: 20,
            ),
            onTap: () async {
              final result = await Navigator.of(context).push<List<String>>(
                MaterialPageRoute(
                  builder: (context) => SelectPupilsScreen(
                    allPupils: state.allPupils,
                    selectedPupilIds: state.selectedPupilIds,
                    levelNumber: levelNumber,
                  ),
                ),
              );

              if (result != null && context.mounted) {
                final bloc = context.read<CreateScheduleBloc>();
                // Clear current selections and set new ones
                for (String pupilId in state.selectedPupilIds.toList()) {
                  bloc.add(DeselectPupil(pupilId));
                }
                for (String pupilId in result) {
                  bloc.add(SelectPupil(pupilId));
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSessionsSection(
    BuildContext context,
    CreateScheduleLoaded state,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(16)),
      child: Column(
        children: [
          ...state.sessions.asMap().entries.map((entry) {
            final index = entry.key;
            final session = entry.value;

            return DateTimePickerField(
              label: session.isLevelTransition
                  ? 'Next Level Starts'
                  : 'Session ${session.sessionNumber}',
              date: session.date,
              time: session.time,
              dateHint: 'MM/DD/YYYY', // Add this
              timeHint: 'HH:MM', // Add this
              showActualDateTime: false, // Add this flag
              levelType: session.isLevelTransition
                  ? LevelType.orangeLevel
                  : LevelType.redLevel,
              onDateTap: () => _selectDate(context, index, session.date),
              onTimeTap: () => _selectTime(context, index, session.time),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSelectedPupilsSection(
    BuildContext context,
    CreateScheduleLoaded state,
  ) {
    if (state.selectedPupils.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Pupils (${state.selectedPupils.length})',
            style: TextStyle(
              fontSize: SizeConfig.scaleWidth(16),
              fontWeight: FontWeight.w600,
              color: AppColors.grey900,
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(12)),
          ...state.selectedPupils
              .map(
                (pupil) => PupilCard(
                  pupil: pupil,
                  levelType: LevelType.redLevel,
                  onRemove: () {
                    context.read<CreateScheduleBloc>().add(
                      DeselectPupil(pupil.id),
                    );
                  },
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildNoticeSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(16)),
      padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Text(
        'These session dates may be subject to change. '
        'All payments are due on or before session 1 of each course.\n\n'
        'As levels progress interim sessions may be needed to reach '
        'the required standard, which means it should not be assumed '
        'that pupils progress automatically to the next level every '
        'six weeks. It is purely at the discretion of the Bitesize Golf coach.',
        style: TextStyle(
          fontSize: SizeConfig.scaleWidth(12),
          color: AppColors.grey700,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildSendButton(BuildContext context, CreateScheduleLoaded state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(16)),
      child: CustomButtonFactory.primary(
        text: state.isUpdate ? 'Update Schedule' : 'Send Schedule',
        onPressed: state.canSubmit
            ? () {
                context.read<CreateScheduleBloc>().add(
                  CreateOrUpdateScheduleSubmit(
                    coachId: coachId,
                    clubId: clubId,
                    levelNumber: levelNumber,
                    notes: '',
                    existingScheduleId: state.existingScheduleId,
                  ),
                );
              }
            : null,
        levelType: LevelType.redLevel,
        size: ButtonSize.large,
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    int index,
    DateTime currentDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: LevelType.redLevel.color),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != currentDate) {
      context.read<CreateScheduleBloc>().add(
        UpdateSessionDate(sessionIndex: index, date: picked),
      );
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    int index,
    String currentTime,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _parseTimeOfDay(currentTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: LevelType.redLevel.color),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final timeString =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      context.read<CreateScheduleBloc>().add(
        UpdateSessionTime(sessionIndex: index, time: timeString),
      );
    }
  }

  TimeOfDay _parseTimeOfDay(String timeString) {
    if (timeString.isEmpty) return const TimeOfDay(hour: 10, minute: 0);

    final parts = timeString.split(':');
    if (parts.length != 2) return const TimeOfDay(hour: 10, minute: 0);

    try {
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return const TimeOfDay(hour: 10, minute: 0);
    }
  }
}
