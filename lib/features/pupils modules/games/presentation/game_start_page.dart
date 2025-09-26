import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:bitesize_golf/core/themes/theme_colors.dart';
import 'package:bitesize_golf/features/components/custom_scaffold.dart';
import '../../../../Models/game models/game_model.dart';
import '../../../../core/themes/level_utils.dart';
import '../data/games_bloc.dart';

class GameVideoScreen extends StatefulWidget {
  String? gameId;

  GameVideoScreen({super.key, this.gameId}) {
    gameId ??= "06Xz0RrPiXQZstcWV6X0";
  }

  @override
  State<GameVideoScreen> createState() => _GameVideoScreenState();
}

class _GameVideoScreenState extends State<GameVideoScreen> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;
  LevelType levelType = LevelType.redLevel;
  String levelName = 'Red';
  int levelNumber = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && context.mounted) {
        final gameId = widget.gameId ?? "06Xz0RrPiXQZstcWV6X0";
        context.read<GamesBloc>().add(LoadGameByIdEvent(gameId));
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      final newLevelName = arguments['levelName'] ?? 'Red';
      final newLevelNumber = arguments['levelNumber'] ?? 1;

      if (newLevelName != levelName || newLevelNumber != levelNumber) {
        setState(() {
          levelName = newLevelName;
          levelNumber = newLevelNumber;
          levelType = LevelUtils.getLevelTypeFromNumber(levelNumber);
        });
      }
    }
  }

  // Future<void> _initializeVideo(String? videoUrl) async {
  //   try {
  //     final fallbackUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  //     _videoController = VideoPlayerController.network(
  //       (videoUrl != null && videoUrl.isNotEmpty) ? videoUrl : fallbackUrl,
  //     );
  //     await _videoController!.initialize();
  //     if (mounted) {
  //       setState(() {
  //         _isVideoInitialized = true;
  //       });
  //       _videoController!.addListener(() {
  //         if (mounted) {
  //           setState(() {
  //             _isPlaying = _videoController!.value.isPlaying;
  //           });
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print('Error initializing video: $e');
  //   }
  // }
  Future<void> _initializeVideo() async {
    try {
      const staticUrl =
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

      _videoController = VideoPlayerController.network(staticUrl);

      await _videoController!.initialize();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });

        _videoController!.addListener(() {
          if (mounted) {
            setState(() {
              _isPlaying = _videoController!.value.isPlaying;
            });
          }
        });
      }
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  void _togglePlayPause() {
    if (_videoController != null) {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GamesBloc>(
      create: (context) =>
          GamesBloc()
            ..add(LoadGameByIdEvent(widget.gameId ?? "06Xz0RrPiXQZstcWV6X0")),
      child: AppScaffold.withCustomAppBar(
        customPadding: EdgeInsets.zero,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(
            backgroundColor: levelType.color,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              '${levelName.toUpperCase()} Game',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              IconButton(
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 20),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        scrollable: false,
        body: BlocBuilder<GamesBloc, GamesState>(
          builder: (context, state) {
            if (state is GamesLoading) {
              return _buildLoadingState();
            }
            if (state is GamesError) {
              return _buildErrorState(state.message);
            }
            if (state is GameDetailsLoaded) {
              if (!_isVideoInitialized && _videoController == null) {
                _initializeVideo();
              }
              return _buildGameVideoContent(state.game);
            }
            return _buildInitialState();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(levelType.color),
          ),
          SizedBox(height: 16),
          Text('Loading game...', style: TextStyle(color: AppColors.grey600)),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          SizedBox(height: 16),
          Text(
            'Unable to load game',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.grey900,
            ),
          ),
          SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey600),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<GamesBloc>().add(
              LoadGameByIdEvent(widget.gameId ?? "06Xz0RrPiXQZstcWV6X0"),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: levelType.color,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
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
        'Loading game...',
        style: TextStyle(color: AppColors.grey600),
      ),
    );
  }

  Widget _buildGameVideoContent(GameModel game) {
    return Column(
      children: [
        // Profile Section
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: levelType.gradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'AJ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alex Johnson',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '28 Mar 2025 at 14:00',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${levelName} Level',
                    style: TextStyle(
                      fontSize: 12,
                      color: levelType.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle edit action
                    },
                    child: Text(
                      'Edit',
                      style: TextStyle(fontSize: 12, color: levelType.color),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Container(
          height: 250,
          width: double.infinity,
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_isVideoInitialized && _videoController != null)
                AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                )
              else if (game.thumbnailUrl != null)
                Image.network(
                  game.thumbnailUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),

              // Play/Pause Button
              GestureDetector(
                onTap: () {
                  if (!_isVideoInitialized) {
                    _initializeVideo();
                  } else {
                    _togglePlayPause();
                  }
                },
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 32,
                    color: levelType.color,
                  ),
                ),
              ),

              // Video Controls (when playing)
              if (_isVideoInitialized &&
                  _showControls &&
                  _videoController != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Text(
                        _formatDuration(_videoController!.value.position),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: VideoProgressIndicator(
                          _videoController!,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: levelType.color,
                            bufferedColor: Colors.grey,
                            backgroundColor: Colors.white24,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        _formatDuration(_videoController!.value.duration),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // Content Section
        Expanded(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),

                Spacer(),

                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor: levelType.color.withOpacity(0.1),
                          side: BorderSide(
                            color: levelType.color.withOpacity(0.3),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Mark as Done',
                          style: TextStyle(
                            fontSize: 14,
                            color: levelType.color,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navigateToNext(game),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: levelType.color,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Next',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToNext(GameModel game) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Moving to next activity'),
        backgroundColor: levelType.color,
      ),
    );
  }
}
