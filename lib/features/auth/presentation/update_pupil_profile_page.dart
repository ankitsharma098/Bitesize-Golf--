import 'dart:io';
import 'package:bitesize_golf/Models/club%20model/golf_club_model.dart';
import 'package:bitesize_golf/Models/coaches%20model/coach_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/theme_colors.dart';
import '../../../core/utils/snackBarUtils.dart';
import '../../../core/utils/user_utils.dart';
import '../../../route/navigator_service.dart';
import '../../../route/routes_names.dart';
import '../../components/custom_button.dart';
import '../../components/custom_image_picker.dart';
import '../../components/custom_scaffold.dart';
import '../../components/text_field_component.dart';
import '../../components/utils/size_config.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../repositories/auth_repo.dart';

class UpdatePupilProfilePage extends StatefulWidget {
  const UpdatePupilProfilePage({super.key});

  @override
  State<UpdatePupilProfilePage> createState() => _UpdatePupilProfilePageState();
}

class _UpdatePupilProfilePageState extends State<UpdatePupilProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final dateOfBirthCtrl = TextEditingController();
  final handicapCtrl = TextEditingController();

  File? _profileImage;
  DateTime? _selectedDateOfBirth;
  String? _selectedCoachId;
  String? _selectedCoachName;
  String? _selectedClubId;
  String? _selectedClubName;

  List<ClubModel> _availableClubs = [];
  List<CoachModel> _availableCoaches = [];
  bool _isLoadingClubs = false;
  bool _isLoadingCoaches = false;

  final AuthRepository authRepo = AuthRepository();

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    _loadClubs();
  }

  void _initializeUserData() {
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthAuthenticated ||
        authState is AuthProfileCompletionRequired) {
      final user = (authState as dynamic).user;

      // ✅ Safely check for firstName / lastName in your UserModel
      if (user.firstName != null && user.firstName!.isNotEmpty) {
        firstNameCtrl.text = user.firstName!;
      }
      if (user.lastName != null && user.lastName!.isNotEmpty) {
        lastNameCtrl.text = user.lastName!;
      }
    } else {
      context.go(RouteNames.welcome);
    }
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    dateOfBirthCtrl.dispose();
    handicapCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 8)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      setState(() {
        _selectedDateOfBirth = date;
        dateOfBirthCtrl.text = DateFormat('dd/MM/yyyy').format(date);
      });
    }
  }

  Future<void> _loadClubs() async {
    setState(() => _isLoadingClubs = true);
    try {
      final clubs = await authRepo.getAllClubs();
      setState(() => _availableClubs = clubs);
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
      final coaches = await authRepo.getAllCoachesByClubId(clubId);
      setState(() => _availableCoaches = coaches);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load coaches: $e')));
    } finally {
      setState(() => _isLoadingCoaches = false);
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
                        club.name,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        club.location,
                        style: GoogleFonts.inter(color: Colors.grey[600]),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedClubId = club.id;
                          _selectedClubName = club.name;
                          _selectedCoachId = null;
                          _selectedCoachName = null;
                          _availableCoaches = [];
                        });
                        Navigator.pop(context);
                        _loadCoachesForClub(club.id);
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
                          coach.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(coach.name),
                      subtitle: Text('${coach.experience} years experience'),
                      onTap: () {
                        setState(() {
                          _selectedCoachId = coach.id;
                          _selectedCoachName = coach.name;
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

  Future<void> _handleComplete() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedClubId == null) {
      SnackBarUtils.showErrorSnackBar(
        context,
        message: 'You must select a golf club',
        levelNumber: 1,
      );

      return;
    }

    if (_selectedCoachId == null) {
      SnackBarUtils.showErrorSnackBar(
        context,
        message: 'You must select a coach',
        levelNumber: 1,
      );

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('You must select a coach')),
      // );
      return;
    }

    final user = await UserUtil().getCurrentUser();
    if (user == null) {
      SnackBarUtils.showInfoSnackBar(
        context,
        message: 'User not logged in',
        levelNumber: 1,
      );
      return;
    }

    final fullName = '${firstNameCtrl.text.trim()} ${lastNameCtrl.text.trim()}';

    context.read<AuthBloc>().add(
      AuthCompletePupilProfileRequested(
        pupilId: user.uid, // same as coach
        userId: user.uid,
        name: fullName,
        dateOfBirth: _selectedDateOfBirth,
        handicap: handicapCtrl.text.trim().isNotEmpty
            ? handicapCtrl.text.trim()
            : null,
        selectedCoachId: _selectedCoachId,
        selectedCoachName: _selectedCoachName,
        selectedClubId: _selectedClubId,
        selectedClubName: _selectedClubName,
        profilePic: _profileImage?.path,
      ),
    );
  }

  void _skip() => context.go(RouteNames.pupilHome);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          NavigationService.push(
            '${RouteNames.subscription}?pupilId=${state.user.uid}',
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return AppScaffold.form(
          title: 'Complete Your Profile',
          showBackButton: true,
          scrollable: true,
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: SizeConfig.scaleHeight(20)),
                Text(
                  'Tell us a bit more about yourself to personalize your experience.',
                  style: GoogleFonts.inter(
                    fontSize: SizeConfig.scaleWidth(16),
                    color: AppColors.grey600,
                  ),
                ),
                SizedBox(height: SizeConfig.scaleHeight(32)),

                CustomTextFieldFactory.name(
                  controller: firstNameCtrl,
                  label: 'First Name',
                  placeholder: 'Enter First Name',
                  levelType: LevelType.redLevel,
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? 'Required' : null,
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),

                CustomTextFieldFactory.name(
                  controller: lastNameCtrl,
                  label: 'Last Name',
                  placeholder: 'Enter Last Name',
                  levelType: LevelType.redLevel,
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? 'Required' : null,
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),

                CustomTextFieldFactory.date(
                  controller: dateOfBirthCtrl,
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
                  label: 'Handicap',
                  placeholder: 'Enter Handicap (0–36)',
                  levelType: LevelType.redLevel,
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
                  controller: TextEditingController(
                    text: _selectedClubName ?? '',
                  ),
                  label: 'Golf Club or Facility',
                  placeholder: 'Select Golf Club',
                  levelType: LevelType.redLevel,
                  onTap: _showClubSelection,
                  validator: (v) {
                    if (_selectedClubId == null) return 'Please select a club';
                    return null;
                  },
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),

                CustomTextFieldFactory.dropdown(
                  controller: TextEditingController(
                    text: _selectedCoachName ?? '',
                  ),
                  label: 'Coach Name',
                  placeholder: _selectedClubId == null
                      ? 'Select a club first'
                      : 'Select Coach',
                  levelType: LevelType.redLevel,
                  onTap: _selectedClubId == null ? null : _showCoachSelection,
                  validator: (v) {
                    if (_selectedCoachId == null)
                      return 'Please select a coach';
                    return null;
                  },
                ),

                SizedBox(height: SizeConfig.scaleHeight(20)),

                SizedBox(
                  width: 900,
                  height: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile Photo',
                        style: GoogleFonts.inter(
                          fontSize: SizeConfig.scaleWidth(16),
                          color: AppColors.grey700,
                        ),
                      ),
                      SizedBox(height: SizeConfig.scaleHeight(8)),
                      Expanded(
                        child: CustomImagePicker(
                          image: _profileImage,
                          size: 200,
                          onImage: (f) => setState(() => _profileImage = f),
                          levelType: LevelType.redLevel,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.scaleHeight(40)),

                CustomButtonFactory.primary(
                  text: 'Save and Continue',
                  onPressed: isLoading ? null : _handleComplete,
                  levelType: LevelType.redLevel,
                  isLoading: isLoading,
                ),
                SizedBox(height: SizeConfig.scaleHeight(8)),
                // CustomButtonFactory.text(
                //   text: 'Skip for now',
                //   onPressed: isLoading ? null : _skip,
                //   levelType: LevelType.redLevel,
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
