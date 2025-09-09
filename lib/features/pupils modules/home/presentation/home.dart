import 'package:bitesize_golf/features/components/home_levels_card.dart';
import 'package:bitesize_golf/features/pupils%20modules/home/presentation/pupil%20bloc/pupil_bloc.dart';
import 'package:bitesize_golf/features/pupils%20modules/home/presentation/pupil%20bloc/pupil_event.dart';
import 'package:bitesize_golf/features/pupils%20modules/home/presentation/pupil%20bloc/pupil_state.dart';
import 'package:bitesize_golf/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/entities/user_enums.dart';
import '../../../components/home_error_widget.dart';
import '../../../components/home_loading_widget.dart';
import '../../level/data/model/level_progress.dart';
import '../../level/domain/entities/level_entity.dart';
import '../../pupil/data/models/pupil_model.dart';
import 'level bloc/level_dashboard_bloc.dart';
import 'level bloc/level_dashboard_event.dart';
import 'level bloc/level_dashboard_state.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LevelBloc>()..add(LoadLevels())),
        BlocProvider(create: (_) => getIt<PupilBloc>()..add(LoadPupil())),
      ],
      child: const HomeDashboardView(),
    );
  }
}

class HomeDashboardView extends StatelessWidget {
  const HomeDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              context.read<LevelBloc>().add(RefreshLevels());
              context.read<PupilBloc>().add(RefreshPupil());
            },
          ),
        ],
      ),
      body: BlocBuilder<PupilBloc, PupilState>(
        builder: (context, pupilState) {
          if (pupilState is PupilLoading) return const HomeLoadingWidget();
          if (pupilState is PupilError) {
            return HomeErrorWidget(
              message: pupilState.message,
              onRetry: () => context.read<PupilBloc>().add(LoadPupil()),
            );
          }
          if (pupilState is PupilLoaded) {
            final pupil = pupilState.pupil;
            return BlocBuilder<LevelBloc, LevelState>(
              builder: (context, levelState) {
                if (levelState is LevelLoading)
                  return const HomeLoadingWidget();
                if (levelState is LevelError) {
                  return HomeErrorWidget(
                    message: levelState.message,
                    onRetry: () => context.read<LevelBloc>().add(LoadLevels()),
                  );
                }
                if (levelState is LevelLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<LevelBloc>().add(RefreshLevels());
                      context.read<PupilBloc>().add(RefreshPupil());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        itemCount: levelState.levels.length,
                        itemBuilder: (context, index) {
                          final level = levelState.levels[index];
                          final isUnlocked = _isLevelUnlocked(
                            level.levelNumber,
                            pupil,
                          );
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: HomeLevelCard(
                              level: level,
                              onTap: isUnlocked
                                  ? () =>
                                        _navigateToLevel(context, level, pupil)
                                  : null, // Disable tap if locked
                              isUnlocked: isUnlocked,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  bool _isLevelUnlocked(int levelNumber, PupilModel pupil) {
    final maxUnlockedLevels =
        pupil.subscription?.tier == SubscriptionTier.premium
        ? 100 // Example: Premium allows all levels
        : 3; // Example: Free tier allows up to level 3
    return pupil.unlockedLevels.contains(levelNumber) &&
        levelNumber <= maxUnlockedLevels;
  }

  void _navigateToLevel(BuildContext context, Level level, PupilModel pupil) {
    // Simulate completing an activity (e.g., quiz) for demo purposes
    // In a real app, this would be triggered by completing an activity
    final updatedProgress = LevelProgress(
      booksCompleted: 0, // Example: Update based on activity
      quizzesCompleted: 1,
      challengesDone: 0,
      gamesDone: 0,
      averageScore: 85.0, // Example score
      isCompleted: false,
      lastActivity: DateTime.now(),
    );

    context.read<PupilBloc>().add(
      UpdateLevelProgress(
        pupilId: pupil.userId,
        levelNumber: level.levelNumber,
        progress: updatedProgress,
        levelRequirements: level.requirements,
        nextLevelNumber: level.levelNumber + 1,
        subscriptionCap: pupil.subscription?.tier == SubscriptionTier.premium
            ? 100
            : 3,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${level.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
