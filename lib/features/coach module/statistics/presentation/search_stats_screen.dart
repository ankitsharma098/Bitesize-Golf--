import 'package:bitesize_golf/Models/level%20model/level_model.dart';
import 'package:flutter/material.dart';

import '../../../../Models/pupil model/pupil_model.dart';
import '../../../../core/themes/theme_colors.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/level_dropdown.dart';
import '../../../components/text_field_component.dart';
import '../../../components/utils/size_config.dart';

class SearchStatsScreen extends StatefulWidget {
  final List<PupilModel>? allPupils;
  final List<String>? selectedPupilIds;
  final int? levelNumber;

  const SearchStatsScreen({
    super.key,
    this.allPupils,
    this.selectedPupilIds,
    this.levelNumber,
  });

  @override
  State<SearchStatsScreen> createState() => _SearchStatsScreenState();
}

class _SearchStatsScreenState extends State<SearchStatsScreen> {
  late TextEditingController _searchController;
  late List<String> _selectedIds;
  List<PupilModel> _filteredPupils = [];
  LevelModel? _selectedLevel;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedIds = List.from(widget.selectedPupilIds ?? []);
    _filteredPupils = widget.allPupils ?? [];

    _searchController.addListener(_filterPupils);
    _filterPupils();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPupils() {
    setState(() {
      _filteredPupils = (widget.allPupils ?? []).where((pupil) {
        final matchesSearch = pupil.name.toLowerCase().contains(
          _searchController.text.toLowerCase(),
        );
        final matchesLevel =
            _selectedLevel == null ||
            pupil.currentLevel == _selectedLevel!.levelNumber;
        return matchesSearch && matchesLevel;
      }).toList();
    });
  }

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
        return 'Indigo Level';
      case 7:
        return 'Violet Level';
      case 8:
        return 'Coral Level';
      case 9:
        return 'Silver Level';
      case 10:
        return 'Gold Level';
      default:
        return 'Red Level';
    }
  }

  LevelType _getLevelType(String levelName) {
    switch (levelName) {
      case 'Red Level':
        return LevelType.redLevel;
      case 'Orange Level':
        return LevelType.orangeLevel;
      case 'Yellow Level':
        return LevelType.yellowLevel;
      case 'Green Level':
        return LevelType.greenLevel;
      case 'Blue Level':
        return LevelType.blueLevel;
      case 'Indigo Level':
        return LevelType.indigoLevel;
      case 'Violet Level':
        return LevelType.violetLevel;
      case 'Coral Level':
        return LevelType.coralLevel;
      case 'Silver Level':
        return LevelType.silverLevel;
      case 'Gold Level':
        return LevelType.goldLevel;
      default:
        return LevelType.redLevel;
    }
  }

  void _togglePupilSelection(String pupilId) {
    setState(() {
      if (_selectedIds.contains(pupilId)) {
        _selectedIds.remove(pupilId);
      } else {
        _selectedIds.add(pupilId);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (_isAllSelected) {
        _selectedIds.clear();
      } else {
        _selectedIds.clear();
        _selectedIds.addAll(_filteredPupils.map((p) => p.id));
      }
    });
  }

  void _resetSelections() {
    setState(() {
      _selectedIds.clear();
    });
  }

  bool get _isAllSelected {
    return _filteredPupils.isNotEmpty &&
        _filteredPupils.every((pupil) => _selectedIds.contains(pupil.id));
  }

  void _onLevelSelected(LevelModel level) {
    setState(() {
      _selectedLevel = level;
      _filterPupils();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold.form(
      title: 'Select Pupils',
      showBackButton: true,
      levelType: LevelType.redLevel,
      scrollable: false,
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
      onBackPressed: () => Navigator.of(context).pop(_selectedIds),
      body: Column(
        children: [
          CustomTextFieldFactory.search(
            label: 'Search Pupil',
            placeholder: 'Search by Name...',
            controller: _searchController,
            levelType: LevelType.redLevel,
            onChanged: (value) {
              // The _filterPupils() is already called by the listener
            },
            onClear: () {
              _searchController.clear();
            },
            showClearButton: true,
          ),
          SizedBox(height: SizeConfig.scaleHeight(12)),

          // Updated to use the new LevelDropdown
          LevelDropdown(
            selectedLevel: _selectedLevel,
            onLevelSelected: _onLevelSelected,
            label: 'Level',
            hint: 'Select Level',
          ),

          SizedBox(height: SizeConfig.scaleHeight(12)),

          _buildPupilsHeader(),
          SizedBox(height: SizeConfig.scaleHeight(12)),

          Expanded(child: _buildPupilsList()),
        ],
      ),
    );
  }

  Widget _buildPupilsHeader() {
    return Row(
      children: [
        Text(
          'Pupils',
          style: TextStyle(
            fontSize: SizeConfig.scaleWidth(16),
            fontWeight: FontWeight.w600,
            color: AppColors.grey800,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: _resetSelections,
          child: Text(
            'Reset Selections',
            style: TextStyle(
              fontSize: SizeConfig.scaleWidth(14),
              color: LevelType.redLevel.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPupilsList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.white,
      ),
      child: Column(
        children: [
          _buildSelectAllTile(),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredPupils.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: AppColors.grey300),
              itemBuilder: (context, index) {
                final pupil = _filteredPupils[index];
                return _buildPupilTile(pupil);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectAllTile() {
    return ListTile(
      title: Text(
        'All Pupils',
        style: TextStyle(
          fontSize: SizeConfig.scaleWidth(16),
          fontWeight: FontWeight.w500,
          color: AppColors.grey900,
        ),
      ),
      trailing: Checkbox(
        value: _isAllSelected,
        onChanged: (_) => _toggleSelectAll(),
        activeColor: LevelType.redLevel.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(4)),
        ),
      ),
      onTap: _toggleSelectAll,
    );
  }

  Widget _buildPupilTile(PupilModel pupil) {
    final isSelected = _selectedIds.contains(pupil.id);
    final currentLevelType = _getLevelType(_getLevelName(pupil.currentLevel));

    return ListTile(
      leading: CircleAvatar(
        radius: SizeConfig.scaleWidth(20),
        backgroundColor: AppColors.grey400,
        backgroundImage:
            pupil.profilePic != null && pupil.profilePic!.isNotEmpty
            ? NetworkImage(pupil.profilePic!)
            : null,
        child: pupil.profilePic == null || pupil.profilePic!.isEmpty
            ? Text(
                pupil.name.isNotEmpty ? pupil.name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  fontSize: SizeConfig.scaleWidth(14),
                ),
              )
            : null,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              pupil.name,
              style: TextStyle(
                fontSize: SizeConfig.scaleWidth(16),
                fontWeight: FontWeight.w500,
                color: AppColors.grey900,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.scaleWidth(8),
              vertical: SizeConfig.scaleHeight(4),
            ),
            decoration: BoxDecoration(
              color: currentLevelType.lightColor,
              borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(12)),
            ),
            child: Text(
              _getLevelName(pupil.currentLevel),
              style: TextStyle(
                fontSize: SizeConfig.scaleWidth(12),
                color: currentLevelType.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      trailing: Checkbox(
        value: isSelected,
        onChanged: (_) => _togglePupilSelection(pupil.id),
        activeColor: LevelType.redLevel.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(4)),
        ),
      ),
      onTap: () => _togglePupilSelection(pupil.id),
    );
  }
}
