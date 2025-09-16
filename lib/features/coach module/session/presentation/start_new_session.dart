import 'package:bitesize_golf/features/auth/data/repositories/auth_repo.dart';
import 'package:bitesize_golf/features/coach%20module/home/data/home_level_repo.dart';
import 'package:bitesize_golf/features/coach%20module/home/home%20bloc/home_event.dart';
import 'package:bitesize_golf/features/coach%20module/home/home%20bloc/home_state.dart';
import 'package:bitesize_golf/features/coach%20module/profile/data/pupil_profile_repo.dart';
import 'package:bitesize_golf/features/coaches/data/repositories/coach_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/level_utils.dart';
import '../../../../core/themes/theme_colors.dart';
import '../../../../injection.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/custom_session_card.dart';
import '../../../components/utils/size_config.dart';
import '../../home/home bloc/home_bloc.dart';

class CreateSessionScreen extends StatelessWidget {
  const CreateSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoachHomeBloc(
        getIt<CoachProfilePageRepo>(),
        getIt<LevelRepository>(),
        getIt<AuthRepository>(),
      )..add(LoadHomeData()),
      child: const CreateSessionScreenView(),
    );
  }
}

class CreateSessionScreenView extends StatefulWidget {
  const CreateSessionScreenView({super.key});

  @override
  State<CreateSessionScreenView> createState() =>
      _CreateSessionScreenViewState();
}

class _CreateSessionScreenViewState extends State<CreateSessionScreenView> {
  @override
  void initState() {
    super.initState();
    // Add null check and context availability check
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (mounted && context.mounted) {
    //     context.read<CoachHomeBloc>().add(LoadHomeData());
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withCustomAppBar(
      customPadding: EdgeInsets.all(0),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          100,
        ), // Custom height for red header
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(SizeConfig.scaleWidth(0)),
              bottomRight: Radius.circular(SizeConfig.scaleWidth(0)),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.scaleWidth(16),
                vertical: SizeConfig.scaleHeight(8),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: SizeConfig.scaleWidth(24),
                    ),
                  ),
                  SizedBox(width: SizeConfig.scaleWidth(16)),
                  Text(
                    'Select Level',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.scaleText(20),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description text
          Padding(
            padding: EdgeInsets.all(SizeConfig.scaleWidth(8)),
            child: Text(
              'Choose the level for this session. Pupils can only be selected for one level at a time.',
              style: TextStyle(
                color: AppColors.grey700,
                fontSize: SizeConfig.scaleText(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          // Level cards
          BlocBuilder<CoachHomeBloc, CoachHomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return _buildLoadingState();
              }
              if (state is HomeError) {
                return _buildErrorState(state.message);
              }
              if (state is HomeLoaded) {
                return _buildLevelGrid(state);
              }
              return _buildInitialState();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenDark),
          ),
          SizedBox(height: SizeConfig.scaleHeight(16)),
          Text('Loading levels...', style: TextStyle(color: AppColors.grey600)),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: SizeConfig.scaleWidth(64),
            color: AppColors.error,
          ),
          SizedBox(height: SizeConfig.scaleHeight(16)),
          Text(
            'Unable to load levels',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.grey900,
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(8)),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey600),
          ),
          SizedBox(height: SizeConfig.scaleHeight(24)),
          ElevatedButton(
            onPressed: () => context.read<CoachHomeBloc>().add(RefreshHome()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greenDark,
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.scaleWidth(24),
                vertical: SizeConfig.scaleHeight(12),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
              ),
            ),
            child: Text('Try Again', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Text(
        'Loading levels...',
        style: TextStyle(color: AppColors.grey600),
      ),
    );
  }

  Widget _buildLevelGrid(HomeLoaded state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(8)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: SizeConfig.scaleWidth(12),
          mainAxisSpacing: SizeConfig.scaleHeight(12),
          childAspectRatio: 1.1, // Adjusted to match UI proportions better
        ),
        itemCount: state.levels.length,
        itemBuilder: (context, index) {
          final level = state.levels[index];
          final levelType = LevelUtils.getLevelTypeFromNumber(
            level.levelNumber,
          );

          return SessionLevelCard(
            levelName: level.name,
            levelNumber: level.levelNumber,
            levelType: levelType,
            onTap: () => _navigateToSessionCreation(level.levelNumber),
          );
        },
      ),
    );
  }

  void _navigateToSessionCreation(int levelNumber) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Creating session for Level $levelNumber'),
        backgroundColor: AppColors.greenDark,
      ),
    );
    // Navigate to session creation screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => SessionCreationScreen(levelNumber: levelNumber)));
  }
}
