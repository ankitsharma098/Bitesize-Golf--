import 'package:bitesize_golf/features/auth/data/repositories/auth_repo.dart';
import 'package:bitesize_golf/features/coach%20module/home/data/home_level_repo.dart';
import 'package:bitesize_golf/features/coach%20module/home/home%20bloc/home_event.dart';
import 'package:bitesize_golf/features/coach%20module/home/home%20bloc/home_state.dart';
import 'package:bitesize_golf/features/coach%20module/profile/data/pupil_profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/level_utils.dart';
import '../../../../core/themes/theme_colors.dart';
import '../../../../injection.dart';
import '../../../../route/navigator_service.dart';
import '../../../../route/routes_names.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/custom_session_card.dart';
import '../../../components/text_field_component.dart';
import '../../../components/utils/size_config.dart';
import '../../home/home bloc/home_bloc.dart';

class PupilStatsScreen extends StatelessWidget {
  const PupilStatsScreen({super.key});

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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withCustomAppBar(
      customPadding: EdgeInsets.all(0),
      appBar: AppBar(
        title: Text(
          'Statistics',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
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
          SizedBox(height: SizeConfig.scaleHeight(8)),
          GestureDetector(
            onTap: () {
              NavigationService.push(RouteNames.searchStats);
            },
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.scaleWidth(8)),
              child: CustomTextFieldFactory.search(
                label: 'Search Pupil',
                placeholder: 'Search by Name...',
                controller: _searchController,
                levelType: LevelType.redLevel,
                onChanged: (value) {},
                onClear: () {
                  _searchController.clear();
                },
                showClearButton: true,
              ),
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(16)),
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
          childAspectRatio: 1.1,
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
  }
}
