import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/themes/theme_colors.dart';
import '../../../../route/navigator_service.dart';
import '../../../../route/routes_names.dart';
import '../../../club/data/repositories/club_repository.dart';
import '../../../coaches/data/entities/coach_entity.dart';
import '../../../coaches/data/repositories/coach_repo.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_image_picker.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/text_field_component.dart';
import '../../../components/utils/size_config.dart';
import '../../../club/data/entities/golf_club_entity.dart';
import '../../../../injection.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

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

  List<Club> _availableClubs = [];
  List<Coach> _availableCoaches = [];
  bool _isLoadingClubs = false;
  bool _isLoadingCoaches = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUserData();
      _loadClubs();
    });
  }

  void _initializeUserData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated ||
        authState is AuthProfileCompletionRequired) {
      final user = (authState as dynamic).user;
      if (user.displayName != null && user.displayName!.contains(' ')) {
        final nameParts = user.displayName!.split(' ');
        firstNameCtrl.text = nameParts.first;
        lastNameCtrl.text = nameParts.sublist(1).join(' ');
      } else if (user.firstName != null && user.lastName != null) {
        firstNameCtrl.text = user.firstName!;
        lastNameCtrl.text = user.lastName!;
      }
    } else {
      context.go(RouteNames.welcome);
    }
  }

  Future<void> _loadClubs() async {
    setState(() => _isLoadingClubs = true);
    try {
      final clubs = await getIt<ClubRepository>().getAllClubs();
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
      final coaches = await getIt<CoachRepository>().getCoachesByClub(clubId);
      setState(() => _availableCoaches = coaches);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load coaches: $e')));
    } finally {
      setState(() => _isLoadingCoaches = false);
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
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                      onTap: () {
                        setState(() {
                          _selectedClubId = club.id;
                          _selectedClubName = club.name;
                          _selectedCoachId = null;
                          _selectedCoachName =
                              null; // ← ADD THIS LINE if it's missing
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
                          coach.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        coach.name,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        '${coach.experience} years experience',
                        style: GoogleFonts.inter(color: Colors.grey[600]),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                      // In your coach selection ListTile onTap
                      onTap: () {
                        print('🎯 Selected coach: ${coach.name}');
                        print('🆔 Coach ID: ${coach.id}');
                        print('👤 Coach userId: ${coach.userId}');

                        setState(() {
                          // Use coach.userId if coach.id is empty
                          _selectedCoachId = coach.id.isNotEmpty
                              ? coach.id
                              : coach.userId;
                          _selectedCoachName = coach.name;
                        });

                        print(
                          '✅ Setting _selectedCoachId to: $_selectedCoachId',
                        );
                        print(
                          '✅ Setting _selectedCoachName to: $_selectedCoachName',
                        );

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

  void _handleComplete() {
    if (!_formKey.currentState!.validate()) return;
    final currentUser = context.read<AuthBloc>().state;
    if (currentUser is! AuthAuthenticated &&
        currentUser is! AuthProfileCompletionRequired)
      return;
    final user = currentUser is AuthAuthenticated
        ? currentUser.user
        : (currentUser as AuthProfileCompletionRequired).user;
    final pupilId = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}';
    context.read<AuthBloc>().add(
      AuthCompletePupilProfileRequested(
        pupilId: pupilId,
        userId: user.uid,
        name: '${firstNameCtrl.text.trim()} ${lastNameCtrl.text.trim()}',
        dateOfBirth: _selectedDateOfBirth,
        handicap: handicapCtrl.text.trim().isNotEmpty
            ? handicapCtrl.text.trim()
            : null,
        selectedCoachId: _selectedCoachId,
        selectedCoachName: _selectedCoachName,
        selectedClubId: _selectedClubId,
        selectedClubName: _selectedClubName,
        avatar: _profileImage?.path,
      ),
    );
  }

  void _skip() {
    context.go(RouteNames.pupilHome);
  }

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
                  placeholder: 'Enter Handicap(e.g. 14)',
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
                  placeholder: 'Select Golf Club or Facility',
                  levelType: LevelType.redLevel,
                  onTap: _showClubSelection,
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? 'Required' : null,
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
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),
                SizedBox(
                  width: 900, // Increased width for a wider cuboid shape
                  height: 120, // Keeping the height as is
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align to start (left)
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
                        // Use Expanded to fill remaining height
                        child: CustomImagePicker(
                          image: _profileImage,
                          size: 200, // Adjust size to fit within height
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
                CustomButtonFactory.text(
                  text: 'Skip for now',
                  onPressed: isLoading ? null : _skip,
                  levelType: LevelType.redLevel,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
