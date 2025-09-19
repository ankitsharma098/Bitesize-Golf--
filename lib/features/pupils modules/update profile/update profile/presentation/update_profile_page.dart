import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../core/themes/theme_colors.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_scaffold.dart';
import '../../../../components/text_field_component.dart';
import '../../../../components/utils/size_config.dart';
import '../data/update_profile_bloc.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final handicapCtrl = TextEditingController();
  final coachNameCtrl = TextEditingController();
  final golfClubCtrl = TextEditingController();
  DateTime? _selectedDateOfBirth;
  File? _profileImage;
  String? _selectedCoachId;
  String? _selectedCoachName;
  String? _selectedClubId;
  String? _selectedClubName;
  List<Map<String, String>> _availableClubs = [];
  List<Map<String, String>> _availableCoaches = [];
  bool _isLoadingClubs = false;
  bool _isLoadingCoaches = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
      _loadClubs();
    });
  }

  void _loadProfileData() {
    context.read<UpdateProfileBloc>().add(const LoadUpdateProfile());
  }

  void _populateFields(Map<String, dynamic> profile) {
    firstNameCtrl.text = profile['firstName'] ?? '';
    lastNameCtrl.text = profile['lastName'] ?? '';
    dobCtrl.text = profile['dateOfBirth'] ?? '';
    handicapCtrl.text = profile['handicap']?.toString() ?? '';
    _selectedCoachName = profile['coachName'];
    _selectedClubName = profile['golfClub'];
    coachNameCtrl.text = _selectedCoachName ?? '';
    golfClubCtrl.text = _selectedClubName ?? '';

    if (profile['dateOfBirth'] != null) {
      try {
        _selectedDateOfBirth = DateFormat(
          'dd/MM/yyyy',
        ).parse(profile['dateOfBirth']);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }
  }

  Future<void> _loadClubs() async {
    setState(() => _isLoadingClubs = true);
    try {
      _availableClubs = [
        {'id': '1', 'name': 'Royal Golf Club', 'location': 'New Delhi'},
      ];
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load clubs: $e')));
    } finally {
      setState(() => _isLoadingClubs = false);
    }
  }

  Future<void> _loadCoachesForClub(String clubId) async {
    setState(() => _isLoadingCoaches = true);
    try {
      switch (clubId) {
        case '1':
          _availableCoaches = [
            {'id': '1', 'name': 'Michael Smith', 'experience': '10'},
            {'id': '2', 'name': 'David Johnson', 'experience': '8'},
          ];
          break;
        default:
          _availableCoaches = [];
      }
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load coaches: $e')));
    } finally {
      setState(() => _isLoadingCoaches = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate:
          _selectedDateOfBirth ??
          DateTime.now().subtract(const Duration(days: 365 * 8)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      setState(() {
        _selectedDateOfBirth = date;
        dobCtrl.text = DateFormat('dd/MM/yyyy').format(date);
      });
    }
  }

  void _showClubSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.scaleHeight(16)),
            Text(
              'Select Golf Club',
              style: GoogleFonts.inter(
                fontSize: SizeConfig.scaleWidth(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: SizeConfig.scaleHeight(16)),
            if (_isLoadingClubs)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _availableClubs.length,
                  itemBuilder: (context, index) {
                    final club = _availableClubs[index];
                    return ListTile(
                      title: Text(
                        club['name']!,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        club['location']!,
                        style: GoogleFonts.inter(color: Colors.grey[600]),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                      onTap: () {
                        setState(() {
                          _selectedClubId = club['id'];
                          _selectedClubName = club['name'];
                          golfClubCtrl.text = club['name']!;
                          _selectedCoachId = null;
                          _selectedCoachName = null;
                          coachNameCtrl.text = '';
                          _availableCoaches = [];
                        });
                        Navigator.pop(context);
                        _loadCoachesForClub(club['id']!);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showCoachSelection() {
    if (_selectedClubId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a golf club first')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.scaleHeight(16)),
            Text(
              'Select Coach',
              style: GoogleFonts.inter(
                fontSize: SizeConfig.scaleWidth(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: SizeConfig.scaleHeight(16)),
            ListTile(
              title: Text(
                'No Coach (Self-learning)',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                'Learn at your own pace',
                style: GoogleFonts.inter(color: Colors.grey[600]),
              ),
              onTap: () {
                setState(() {
                  _selectedCoachId = null;
                  _selectedCoachName = null;
                  coachNameCtrl.text = '';
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            if (_isLoadingCoaches)
              const Center(child: CircularProgressIndicator())
            else if (_availableCoaches.isEmpty)
              Center(
                child: Text(
                  'No coaches available for this club',
                  style: GoogleFonts.inter(color: Colors.grey[600]),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _availableCoaches.length,
                  itemBuilder: (context, index) {
                    final coach = _availableCoaches[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.redDark,
                        child: Text(
                          coach['name']!.substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        coach['name']!,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        '${coach['experience']} years experience',
                        style: GoogleFonts.inter(color: Colors.grey[600]),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCoachId = coach['id'];
                          _selectedCoachName = coach['name'];
                          coachNameCtrl.text = coach['name']!;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile updated successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    dobCtrl.dispose();
    handicapCtrl.dispose();
    coachNameCtrl.dispose();
    golfClubCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
      listener: (context, state) {
        if (state is UpdateProfileLoaded) {
          _populateFields(state.profile);
        } else if (state is UpdateProfileError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is UpdateProfileLoading;

        return AppScaffold.form(
          title: 'Edit Profile',
          showBackButton: true,
          scrollable: true,
          levelType: LevelType.redLevel,
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: SizeConfig.scaleWidth(45),
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : const NetworkImage(
                                    "https://via.placeholder.com/150",
                                  )
                                  as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.redDark,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.scaleHeight(24)),

                CustomTextFieldFactory.name(
                  controller: firstNameCtrl,
                  levelType: LevelType.redLevel,
                  label: 'First Name',
                  placeholder: 'Enter First Name',
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? 'Required' : null,
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),

                CustomTextFieldFactory.name(
                  controller: lastNameCtrl,
                  levelType: LevelType.redLevel,
                  label: 'Last Name',
                  placeholder: 'Enter Last Name',
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? 'Required' : null,
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),

                CustomTextFieldFactory.date(
                  controller: dobCtrl,
                  label: 'Date of Birth',
                  placeholder: 'DD/MM/YYYY',
                  levelType: LevelType.redLevel,
                  onTap: _selectDate,
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? 'Required' : null,
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),

                CustomTextFieldFactory.number(
                  controller: handicapCtrl,
                  levelType: LevelType.redLevel,
                  label: 'Handicap',
                  placeholder: 'Enter Handicap (e.g. 14)',
                  validator: (v) {
                    if ((v ?? '').trim().isEmpty) return null;
                    final val = int.tryParse((v ?? '').trim());
                    return val == null || val < 0 || val > 36
                        ? '0-36 only'
                        : null;
                  },
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),

                CustomTextFieldFactory.dropdown(
                  controller: golfClubCtrl,
                  levelType: LevelType.redLevel,
                  label: 'Golf Club or Facility',
                  placeholder: 'Select Golf Club or Facility',
                  onTap: _showClubSelection,
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? 'Required' : null,
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),

                CustomTextFieldFactory.dropdown(
                  controller: coachNameCtrl,
                  levelType: LevelType.redLevel,
                  label: 'Coach Name',
                  placeholder: _selectedClubId == null
                      ? 'Select a club first'
                      : 'Select Coach',
                  onTap: _selectedClubId == null ? null : _showCoachSelection,
                ),
                SizedBox(height: SizeConfig.scaleHeight(40)),

                CustomButtonFactory.primary(
                  text: "Save Changes",
                  onPressed: isLoading ? null : _handleSave,
                  levelType: LevelType.redLevel,
                  size: ButtonSize.medium,
                  isLoading: isLoading,
                ),
                SizedBox(height: SizeConfig.scaleHeight(8)),

                CustomButtonFactory.text(
                  text: "Cancel",
                  onPressed: () => Navigator.pop(context),
                  levelType: LevelType.redLevel,
                  size: ButtonSize.medium,
                ),
                SizedBox(height: SizeConfig.scaleHeight(24)),
              ],
            ),
          ),
        );
      },
    );
  }
}
