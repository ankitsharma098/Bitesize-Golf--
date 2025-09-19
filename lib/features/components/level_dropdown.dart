import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:bitesize_golf/core/themes/theme_colors.dart';
import 'package:bitesize_golf/features/level/entity/level_entity.dart';
import '../../core/themes/level_utils.dart';
import '../coach module/home/data/home_level_repo.dart';

class LevelDropdown extends StatefulWidget {
  final Level? selectedLevel;
  final Function(Level) onLevelSelected;
  final String? label;
  final String? hint;

  const LevelDropdown({
    super.key,
    this.selectedLevel,
    required this.onLevelSelected,
    this.label,
    this.hint,
  });

  @override
  State<LevelDropdown> createState() => _LevelDropdownState();
}

class _LevelDropdownState extends State<LevelDropdown> {
  final LevelRepository _levelRepository = LevelRepository();
  List<Level> _levels = [];
  bool _isLoading = true;
  String? _error;
  final GlobalKey _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _loadLevels();
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  Future<void> _loadLevels() async {
    try {
      final levels = await _levelRepository.getAllLevels();
      setState(() {
        _levels = levels;
        _isLoading = false;

        // Set default to Red Level (level 1) if no level is selected
        if (widget.selectedLevel == null && _levels.isNotEmpty) {
          final redLevel = _levels.firstWhere(
            (level) => level.levelNumber == 1,
            orElse: () => _levels.first,
          );
          // Call the callback to set the default selection
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onLevelSelected(redLevel);
          });
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String _getLevelCategoryName(int levelNumber) {
    if (levelNumber >= 1 && levelNumber <= 2) return 'Beginner';
    if (levelNumber >= 3 && levelNumber <= 4) return 'Learner';
    if (levelNumber >= 5 && levelNumber <= 6) return 'Improver';
    if (levelNumber >= 7 && levelNumber <= 8) return 'Committed';
    if (levelNumber >= 9 && levelNumber <= 10) return 'Expert';
    return 'Beginner';
  }

  void _toggleDropdown() {
    if (_isLoading || _levels.isEmpty) return;

    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_isDropdownOpen) {
      setState(() {
        _isDropdownOpen = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset position = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy + size.height + 4,
        width: size.width,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.grey300),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _levels.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: AppColors.grey200),
              itemBuilder: (context, index) {
                final level = _levels[index];
                final levelType = LevelUtils.getLevelTypeFromNumber(
                  level.levelNumber,
                );
                final categoryName = _getLevelCategoryName(level.levelNumber);
                final isSelected =
                    widget.selectedLevel?.levelNumber == level.levelNumber;

                return InkWell(
                  onTap: () {
                    widget.onLevelSelected(level);
                    _removeOverlay();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.scaleWidth(16),
                      vertical: SizeConfig.scaleHeight(12),
                    ),
                    color: isSelected ? levelType.lightColor : null,
                    child: Row(
                      children: [
                        Text(
                          categoryName,
                          style: TextStyle(
                            fontSize: SizeConfig.scaleWidth(15),
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey900,
                          ),
                        ),
                        SizedBox(width: SizeConfig.scaleWidth(12)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.scaleWidth(8),
                            vertical: SizeConfig.scaleHeight(3),
                          ),
                          decoration: BoxDecoration(
                            color: levelType.lightColor,
                            borderRadius: BorderRadius.circular(
                              SizeConfig.scaleWidth(10),
                            ),
                          ),
                          child: Text(
                            levelType.name,
                            style: TextStyle(
                              fontSize: SizeConfig.scaleWidth(11),
                              color: levelType.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isSelected) ...[
                          const Spacer(),
                          Icon(
                            Icons.check,
                            color: levelType.color,
                            size: SizeConfig.scaleWidth(18),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: SizeConfig.scaleWidth(16),
              fontWeight: FontWeight.w500,
              color: AppColors.grey900,
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(8)),
        ],

        GestureDetector(
          key: _dropdownKey,
          onTap: _toggleDropdown,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.scaleWidth(16),
              vertical: SizeConfig.scaleHeight(12),
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: _isDropdownOpen ? AppColors.grey600 : AppColors.grey400,
                width: _isDropdownOpen ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
              color: _isLoading ? AppColors.grey100 : AppColors.white,
            ),
            child: _buildDropdownContent(),
          ),
        ),

        if (_error != null)
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.scaleHeight(4)),
            child: Text(
              'Error loading levels',
              style: TextStyle(
                fontSize: SizeConfig.scaleWidth(12),
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDropdownContent() {
    if (_isLoading) {
      return Row(
        children: [
          SizedBox(
            width: SizeConfig.scaleWidth(16),
            height: SizeConfig.scaleWidth(16),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.grey600),
            ),
          ),
          SizedBox(width: SizeConfig.scaleWidth(12)),
          Text(
            'Loading levels...',
            style: TextStyle(
              fontSize: SizeConfig.scaleWidth(16),
              color: AppColors.grey600,
            ),
          ),
        ],
      );
    }

    if (_error != null || _levels.isEmpty) {
      return Row(
        children: [
          Text(
            widget.hint ?? 'No levels available',
            style: TextStyle(
              fontSize: SizeConfig.scaleWidth(16),
              color: AppColors.grey600,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_drop_down_outlined,
            color: AppColors.grey400,
            size: SizeConfig.scaleWidth(30),
          ),
        ],
      );
    }

    if (widget.selectedLevel != null) {
      final levelType = LevelUtils.getLevelTypeFromNumber(
        widget.selectedLevel!.levelNumber,
      );
      final categoryName = _getLevelCategoryName(
        widget.selectedLevel!.levelNumber,
      );

      return Row(
        children: [
          Text(
            categoryName,
            style: TextStyle(
              fontSize: SizeConfig.scaleWidth(16),
              color: AppColors.grey900,
            ),
          ),
          SizedBox(width: SizeConfig.scaleWidth(8)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.scaleWidth(8),
              vertical: SizeConfig.scaleHeight(4),
            ),
            decoration: BoxDecoration(
              color: levelType.lightColor,
              borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(12)),
            ),
            child: Text(
              levelType.name,
              style: TextStyle(
                fontSize: SizeConfig.scaleWidth(12),
                color: levelType.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          AnimatedRotation(
            turns: _isDropdownOpen ? 0.5 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.arrow_drop_down_outlined,
              color: AppColors.grey600,
              size: SizeConfig.scaleWidth(30),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Text(
          widget.hint ?? 'Select Level',
          style: TextStyle(
            fontSize: SizeConfig.scaleWidth(16),
            color: AppColors.grey600,
          ),
        ),
        const Spacer(),
        AnimatedRotation(
          turns: _isDropdownOpen ? 0.5 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.arrow_drop_down_outlined,
            color: AppColors.grey600,
            size: SizeConfig.scaleWidth(30),
          ),
        ),
      ],
    );
  }
}
