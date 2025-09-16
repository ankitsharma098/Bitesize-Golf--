import 'package:bitesize_golf/features/pupils%20modules/pupil/data/models/pupil_model.dart';
import 'package:flutter/material.dart';

class SelectPupilsScreen extends StatefulWidget {
  final List<PupilModel> allPupils;
  final List<String> selectedPupilIds;
  final int levelNumber;

  const SelectPupilsScreen({
    Key? key,
    required this.allPupils,
    required this.selectedPupilIds,
    required this.levelNumber,
  }) : super(key: key);

  @override
  State<SelectPupilsScreen> createState() => _SelectPupilsScreenState();
}

class _SelectPupilsScreenState extends State<SelectPupilsScreen> {
  late TextEditingController _searchController;
  late List<String> _selectedIds;
  List<PupilModel> _filteredPupils = [];
  String _selectedLevel = 'Red Level';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedIds = List.from(widget.selectedPupilIds);
    _filteredPupils = widget.allPupils;
    _searchController.addListener(_filterPupils);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPupils() {
    setState(() {
      _filteredPupils = widget.allPupils.where((pupil) {
        final matchesSearch = pupil.name.toLowerCase().contains(
          _searchController.text.toLowerCase(),
        );
        // Updated to use currentLevel instead of level property
        final matchesLevel =
            _getLevelName(pupil.currentLevel) == _selectedLevel;
        return matchesSearch && matchesLevel;
      }).toList();
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Select Pupils',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(_selectedIds),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          _buildLevelSection(),
          _buildPupilsHeader(),
          Expanded(child: _buildPupilsList()),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search Pupil',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by Name...',
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Level',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _showLevelPicker,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[50],
              ),
              child: Row(
                children: [
                  const Text(
                    'Beginner',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(width: 8),
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
                      _selectedLevel,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLevelPicker() {
    final levels = [
      'Red Level',
      'Orange Level',
      'Yellow Level',
      'Green Level',
      'Blue Level',
      'Purple Level',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Level'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: levels.map((level) {
            return ListTile(
              title: Text(level),
              leading: Radio<String>(
                value: level,
                groupValue: _selectedLevel,
                onChanged: (value) {
                  setState(() {
                    _selectedLevel = value!;
                    _filterPupils();
                  });
                  Navigator.pop(context);
                },
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildPupilsHeader() {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            'Pupils',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _resetSelections,
            child: const Text(
              'Reset Selections',
              style: TextStyle(
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPupilsList() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildSelectAllTile(),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredPupils.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
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
      leading: Checkbox(
        value: _isAllSelected,
        onChanged: (_) => _toggleSelectAll(),
        activeColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      title: const Text(
        'All Pupils',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: _toggleSelectAll,
    );
  }

  Widget _buildPupilTile(PupilModel pupil) {
    final isSelected = _selectedIds.contains(pupil.id);

    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (_) => _togglePupilSelection(pupil.id),
            activeColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            // Updated to use avatar property instead of avatarUrl
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
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              pupil.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
      trailing: isSelected
          ? const Icon(Icons.check, color: Colors.red, size: 20)
          : null,
      onTap: () => _togglePupilSelection(pupil.id),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
