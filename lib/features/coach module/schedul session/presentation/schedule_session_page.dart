import 'package:bitesize_golf/features/coach%20module/schedul%20session/presentation/select_pupil_ui.dart';
import 'package:bitesize_golf/features/pupils%20modules/pupil/data/models/pupil_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/session_scheduled_bloc.dart';
import '../bloc/session_scheduled_event.dart';
import '../bloc/session_scheduled_state.dart';
import '../data/entity/session_schedule_entity.dart';
import '../data/repo/scheduled_session_repo.dart';

class CreateScheduleScreen extends StatelessWidget {
  const CreateScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateScheduleBloc(repository: ScheduleRepository())
        ..add(
          LoadPupils(coachId: '7ZvhugMejXO6p3Dg5I9Qe1IpTeo2', levelNumber: 1),
        ),
      child: const CreateScheduleScreenView(
        coachId: '7ZvhugMejXO6p3Dg5I9Qe1IpTeo2',
        clubId: '3MYfcrS3a4pztGAZoMmA',
        levelNumber: 1,
      ),
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Create Schedule Form',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
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
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is CreateScheduleSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Schedule created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is CreateScheduleInitial ||
              state is CreateScheduleLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CreateScheduleError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CreateScheduleBloc>().add(
                        LoadPupils(coachId: coachId, levelNumber: levelNumber),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is CreateScheduleLoaded) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPupilsSection(context, state),
                        const SizedBox(height: 24),
                        _buildSessionsSection(context, state),
                        const SizedBox(height: 24),
                        _buildSelectedPupilsSection(context, state),
                        const SizedBox(height: 16),
                        _buildNoticeSection(),
                        const SizedBox(height: 100), // Space for button
                      ],
                    ),
                  ),
                ),
                _buildSendButton(context, state),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPupilsSection(BuildContext context, CreateScheduleLoaded state) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pupils',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ListTile(
              title: const Text('Select pupils'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
                  // Update selected pupils using updated BLoC events
                  final bloc = context.read<CreateScheduleBloc>();
                  for (String pupilId in result) {
                    if (!state.selectedPupilIds.contains(pupilId)) {
                      bloc.add(SelectPupil(pupilId));
                    }
                  }
                  // Remove unselected pupils
                  for (String pupilId in state.selectedPupilIds) {
                    if (!result.contains(pupilId)) {
                      bloc.add(DeselectPupil(pupilId));
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsSection(
    BuildContext context,
    CreateScheduleLoaded state,
  ) {
    return Column(
      children: [
        ...state.sessions.asMap().entries.map((entry) {
          final index = entry.key;
          final session = entry.value;

          return _buildSessionCard(
            context,
            session,
            index,
            session.isLevelTransition
                ? 'Next Level Starts'
                : 'Session ${session.sessionNumber}',
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSessionCard(
    BuildContext context,
    Session session,
    int index,
    String title,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: session.isLevelTransition
                    ? Colors.orange[600]
                    : Colors.red,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date*',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _selectDate(context, index, session.date),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                DateFormat('MM/dd/yyyy').format(session.date),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.calendar_today,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Time*',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _selectTime(context, index, session.time),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                session.time.isEmpty ? 'HH:MM' : session.time,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: session.time.isEmpty
                                      ? Colors.grey[500]
                                      : Colors.black,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.access_time,
                                color: Colors.grey[600],
                                size: 20,
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
          ),
          const SizedBox(height: 16),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selected Pupils',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...state.selectedPupils
            .map((pupil) => _buildSelectedPupilCard(pupil, context))
            .toList(),
      ],
    );
  }

  Widget _buildSelectedPupilCard(PupilModel pupil, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            // Updated to use avatar property instead of avatarUrl/hasAvatar
            backgroundImage: pupil.avatar != null && pupil.avatar!.isNotEmpty
                ? NetworkImage(pupil.avatar!)
                : null,
            child: pupil.avatar == null || pupil.avatar!.isEmpty
                ? Text(
                    pupil.name.isNotEmpty ? pupil.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pupil.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    // Updated to use currentLevel instead of level
                    _getLevelName(pupil.currentLevel),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () {
              context.read<CreateScheduleBloc>().add(DeselectPupil(pupil.id));
            },
          ),
        ],
      ),
    );
  }

  // Helper method to convert level number to level name
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

  Widget _buildNoticeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: const Text(
        'These session dates may be subject to change. '
        'All payments are due on or before session 1 of each course.\n\n'
        'As levels progress interim sessions may be needed to reach '
        'the required standard, which means it should not be assumed '
        'that pupils progress automatically to the next level every '
        'six weeks. It is purely at the discretion of the Bitesize Golf coach.',
        style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
      ),
    );
  }

  Widget _buildSendButton(BuildContext context, CreateScheduleLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.canSubmit
                ? () {
                    context.read<CreateScheduleBloc>().add(
                      CreateScheduleSubmit(
                        coachId: coachId,
                        clubId: clubId,
                        levelNumber: levelNumber,
                        notes: '',
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              disabledBackgroundColor: Colors.grey[300],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Send Schedule',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
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
            ).colorScheme.copyWith(primary: Colors.red),
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
            ).colorScheme.copyWith(primary: Colors.red),
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
